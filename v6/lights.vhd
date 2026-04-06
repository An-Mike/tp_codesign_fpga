LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY lights IS
PORT(
    SW : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    KEY : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    CLOCK_50 : IN STD_LOGIC;

    LED : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);

    MTR_Sleep_n : OUT STD_LOGIC;
    VCC3P3_PWRON_n : OUT STD_LOGIC;

    MTRR_P : OUT STD_LOGIC;
    MTRR_N : OUT STD_LOGIC;
    MTRL_P : OUT STD_LOGIC;
    MTRL_N : OUT STD_LOGIC;

    DRAM_CLK, DRAM_CKE : OUT STD_LOGIC;
    DRAM_ADDR : OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
    DRAM_BA : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    DRAM_CS_N, DRAM_CAS_N, DRAM_RAS_N, DRAM_WE_N : OUT STD_LOGIC;
    DRAM_DQ : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    DRAM_DQM : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);

    LTC_ADC_CONVST : OUT std_logic;
    LTC_ADC_SCK    : OUT std_logic;
    LTC_ADC_SDI    : OUT std_logic;
    LTC_ADC_SDO    : IN  std_logic
);
END lights;


ARCHITECTURE Structure OF lights IS

------------------------------------------------
-- NIOS
------------------------------------------------

COMPONENT v1
PORT(
    clk_clk : in std_logic;
    reset_reset_n : in std_logic;
    led_export : out std_logic_vector(7 downto 0);
    sw_export : in std_logic_vector(7 downto 0);

    sdram_wire_addr : out std_logic_vector(12 downto 0);
    sdram_wire_ba : out std_logic_vector(1 downto 0);
    sdram_wire_cas_n : out std_logic;
    sdram_wire_cke : out std_logic;
    sdram_wire_cs_n : out std_logic;
    sdram_wire_dq : inout std_logic_vector(15 downto 0);
    sdram_wire_dqm : out std_logic_vector(1 downto 0);
    sdram_wire_ras_n : out std_logic;
    sdram_wire_we_n : out std_logic;
    sdram_clk_clk : out std_logic;

    motorleft_export : out std_logic_vector(13 downto 0);
    motorright_export : out std_logic_vector(13 downto 0);

    -- AJOUT NIOS
    start_sl_export_export  : out std_logic;
    start_rot_export_export : out std_logic;
    dir_rot_export_export   : out std_logic;
    fin_sl_export_export    : in  std_logic;
    fin_rot_export_export   : in  std_logic
);
END COMPONENT;


------------------------------------------------
-- Signaux moteurs
------------------------------------------------

signal motorleft_sig : std_logic_vector(13 downto 0);
signal motorright_sig : std_logic_vector(13 downto 0);

------------------------------------------------
-- Horloges
------------------------------------------------

signal clk_40M : std_logic;
signal clk_2k : std_logic;

------------------------------------------------
-- Capteurs
------------------------------------------------

signal vect_capt : std_logic_vector(6 downto 0);
signal niveau_seuil : std_logic_vector(7 downto 0);

------------------------------------------------
-- Position ligne
------------------------------------------------

signal pos_ligne : integer range -6 to 8;

------------------------------------------------
-- Suivi ligne
------------------------------------------------

signal start_SL : std_logic;
signal fin_SL   : std_logic;

signal PWMgauche_SL : unsigned(15 downto 0);
signal PWMdroit_SL  : unsigned(15 downto 0);
signal PWMstop : unsigned(15 downto 0) := (others => '0');

------------------------------------------------
-- Rotation
------------------------------------------------

signal start_rot : std_logic;
signal dir_rot   : std_logic;
signal fin_rot   : std_logic;

signal PWMgauche_ROT : unsigned(15 downto 0);
signal PWMdroit_ROT  : unsigned(15 downto 0);

------------------------------------------------
-- PWM final moteurs
------------------------------------------------

signal PWMgauche : unsigned(15 downto 0);
signal PWMdroit  : unsigned(15 downto 0);

------------------------------------------------
-- SIGNAUX NIOS
------------------------------------------------

signal start_sl_sig  : std_logic;
signal start_rot_sig : std_logic;
signal dir_rot_sig   : std_logic;

BEGIN

------------------------------------------------
-- Activation robot
------------------------------------------------

MTR_Sleep_n <= '1';
VCC3P3_PWRON_n <= '0';

------------------------------------------------
-- Connexion NIOS -> logique
------------------------------------------------

start_SL  <= start_sl_sig;
start_rot <= start_rot_sig;
dir_rot   <= dir_rot_sig;

------------------------------------------------
-- Seuil capteurs
------------------------------------------------

niveau_seuil <= x"69";

------------------------------------------------
-- PLL
------------------------------------------------

PLL_inst : entity work.pll_2freqs
port map(
    inclk0 => CLOCK_50,
    c0 => clk_40M,
    c1 => clk_2k
);

------------------------------------------------
-- NIOS
------------------------------------------------

NiosII: v1
PORT MAP(
    clk_clk => CLOCK_50,
    reset_reset_n => KEY(0),

    led_export => open,
    sw_export => SW,

    sdram_wire_addr => DRAM_ADDR,
    sdram_wire_ba => DRAM_BA,
    sdram_wire_cas_n => DRAM_CAS_N,
    sdram_wire_cke => DRAM_CKE,
    sdram_wire_cs_n => DRAM_CS_N,
    sdram_wire_dq => DRAM_DQ,
    sdram_wire_dqm => DRAM_DQM,
    sdram_wire_ras_n => DRAM_RAS_N,
    sdram_wire_we_n => DRAM_WE_N,
    sdram_clk_clk => DRAM_CLK,

    motorleft_export => open,
    motorright_export => open,

    -- NOUVELLES CONNEXIONS
    start_sl_export_export  => start_sl_sig,
    start_rot_export_export => start_rot_sig,
    dir_rot_export_export   => dir_rot_sig,

    fin_sl_export_export    => fin_SL,
    fin_rot_export_export   => fin_rot
);

------------------------------------------------
-- SUIVI DE LIGNE
------------------------------------------------

suivi_inst : entity work.suivi_ligne
port map(
    clk       => CLOCK_50,
    reset_n   => KEY(0),

    start_SL  => start_SL,
    pos_ligne => pos_ligne,

    PWMgauche => PWMgauche_SL,
    PWMdroit  => PWMdroit_SL,

    fin_SL    => fin_SL
);

------------------------------------------------
-- ROTATION
------------------------------------------------

rotation_inst : entity work.rotation
port map(
    clk       => CLOCK_50,
    reset_n   => KEY(0),

    start_rot => start_rot,
    dir_rot   => dir_rot,

    pos_ligne => pos_ligne,

    PWMgauche => PWMgauche_ROT,
    PWMdroit  => PWMdroit_ROT,

    fin_rot   => fin_rot
);

------------------------------------------------
-- SELECTION
------------------------------------------------

process(start_rot, start_SL, PWMgauche_SL, PWMgauche_ROT, PWMdroit_SL, PWMdroit_ROT)
begin

    if (start_rot = '1' and start_SL = '0') then
        PWMgauche <= PWMgauche_ROT;
        PWMdroit  <= PWMdroit_ROT;

    elsif (start_SL = '1' and start_rot = '0') then
        PWMgauche <= PWMgauche_SL;
        PWMdroit  <= PWMdroit_SL;

    else
        PWMgauche <= PWMstop;
        PWMdroit  <= PWMstop;
    end if;

end process;

------------------------------------------------
-- Conversion PWM
------------------------------------------------

motorleft_sig  <= std_logic_vector(PWMgauche(13 downto 0));
motorright_sig <= std_logic_vector(PWMdroit(13 downto 0));

------------------------------------------------
-- PWM moteurs
------------------------------------------------

PWM_inst : entity work.PWM_generation
port map(
    clk => CLOCK_50,
    reset_n => KEY(0),

    s_writedataL => motorleft_sig,
    s_writedataR => motorright_sig,

    dc_motor_p_R => MTRR_P,
    dc_motor_n_R => MTRR_N,
    dc_motor_p_L => MTRL_P,
    dc_motor_n_L => MTRL_N
);

------------------------------------------------
-- Capteurs
------------------------------------------------

capteurs_inst : entity work.capteurs_sol_seuil
port map(
    clk => clk_40M,
    reset_n => KEY(0),

    data_capture => clk_2k,

    NIVEAU => niveau_seuil,
    vect_capt => vect_capt,

    ADC_CONVSTr => LTC_ADC_CONVST,
    ADC_SCK => LTC_ADC_SCK,
    ADC_SDIr => LTC_ADC_SDI,
    ADC_SDO => LTC_ADC_SDO
);

------------------------------------------------
-- Position ligne
------------------------------------------------

pos_inst : entity work.calcul_position
port map(
    vect_capt => vect_capt,
    pos_ligne => pos_ligne
);

------------------------------------------------
-- LEDs debug
------------------------------------------------

LED(7) <= start_rot;
LED(6) <= start_SL;
LED(5) <= fin_rot;
LED(4) <= fin_SL;

END Structure;