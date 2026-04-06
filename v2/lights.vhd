LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY lights IS
    PORT (
        SW : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        KEY : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        CLOCK_50 : IN STD_LOGIC;
        LED : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        
        -- Activation carte robot
        MTR_Sleep_n : OUT STD_LOGIC;
        VCC3P3_PWRON_n : OUT STD_LOGIC;

        -- Sorties moteurs (noms du manuel)
        MTRR_P : OUT STD_LOGIC;
        MTRR_N : OUT STD_LOGIC;
        MTRL_P : OUT STD_LOGIC;
        MTRL_N : OUT STD_LOGIC;

        -- SDRAM
        DRAM_CLK, DRAM_CKE : OUT STD_LOGIC;
        DRAM_ADDR : OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
        DRAM_BA : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        DRAM_CS_N, DRAM_CAS_N, DRAM_RAS_N, DRAM_WE_N : OUT STD_LOGIC;
        DRAM_DQ : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        DRAM_DQM : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
    );
END lights;

ARCHITECTURE Structure OF lights IS

    COMPONENT v1
        PORT (
            clk_clk           : in    std_logic;
            reset_reset_n     : in    std_logic;
            led_export        : out   std_logic_vector(7 downto 0);
            sw_export         : in    std_logic_vector(7 downto 0);
            sdram_wire_addr   : out   std_logic_vector(12 downto 0);
            sdram_wire_ba     : out   std_logic_vector(1 downto 0);
            sdram_wire_cas_n  : out   std_logic;
            sdram_wire_cke    : out   std_logic;
            sdram_wire_cs_n   : out   std_logic;
            sdram_wire_dq     : inout std_logic_vector(15 downto 0);
            sdram_wire_dqm    : out   std_logic_vector(1 downto 0);
            sdram_wire_ras_n  : out   std_logic;
            sdram_wire_we_n   : out   std_logic;
            sdram_clk_clk     : out   std_logic;
            motorleft_export  : out   std_logic_vector(13 downto 0);
            motorright_export : out   std_logic_vector(13 downto 0)
        );
    END COMPONENT;

    signal motorleft_sig  : std_logic_vector(13 downto 0);
    signal motorright_sig : std_logic_vector(13 downto 0);

BEGIN

    -- Activation carte robot
    MTR_Sleep_n <= '1';        -- sortir du sleep
    VCC3P3_PWRON_n <= '0';     -- activer alim 3.3V

    -- Instance Nios
    NiosII: v1
        PORT MAP (
            clk_clk           => CLOCK_50,
            reset_reset_n     => KEY(0),
            led_export        => LED,
            sw_export         => SW,
            sdram_wire_addr   => DRAM_ADDR,
            sdram_wire_ba     => DRAM_BA,
            sdram_wire_cas_n  => DRAM_CAS_N,
            sdram_wire_cke    => DRAM_CKE,
            sdram_wire_cs_n   => DRAM_CS_N,
            sdram_wire_dq     => DRAM_DQ,
            sdram_wire_dqm    => DRAM_DQM,
            sdram_wire_ras_n  => DRAM_RAS_N,
            sdram_wire_we_n   => DRAM_WE_N,
            sdram_clk_clk     => DRAM_CLK,
            motorleft_export  => motorleft_sig,
            motorright_export => motorright_sig
        );

    -- Instance PWM
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

END Structure;
