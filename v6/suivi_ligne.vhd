LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
ENTITY suivi_ligne IS
PORT(
    clk        : IN std_logic;
    reset_n    : IN std_logic;
    start_SL   : IN std_logic;
    pos_ligne  : IN integer range -6 to 6;   
    PWMgauche  : OUT unsigned(15 downto 0);
    PWMdroit   : OUT unsigned(15 downto 0);
    fin_SL     : OUT std_logic
);
END suivi_ligne;
ARCHITECTURE RTL OF suivi_ligne IS
-- machine à états
TYPE state_type IS (NOLINEDETECTED, LINEDETECTED);
SIGNAL state : state_type;
-- vitesse de base
CONSTANT CONST_PWM : integer := 16#2785#; --2900
-- gain de correction
CONSTANT GAIN : integer := 190;  --256
SIGNAL bias : integer;
BEGIN
process(clk, reset_n)
    variable pwm_d : integer;
    variable pwm_g : integer;
begin
if reset_n = '0' then
    state <= NOLINEDETECTED;
    PWMgauche <= (others => '0');
    PWMdroit  <= (others => '0');
    fin_SL <= '1';
elsif rising_edge(clk) then
    ------------------------------------------------
    -- TRANSITION ENTRE ETATS
    ------------------------------------------------
    if (pos_ligne = -6) or (pos_ligne = 6) then
        state <= NOLINEDETECTED;
    else
        state <= LINEDETECTED;
    end if;
    ------------------------------------------------
    -- ETAT 1 : NOLINEDETECTED
    ------------------------------------------------
    if state = NOLINEDETECTED then
        -- robot arrêté
        PWMgauche <= (others => '0');
        PWMdroit  <= (others => '0');
        -- LED6 allumée
        fin_SL <= '1';
        -- LED7 sera gérée dans lights.vhd avec start_SL
    ------------------------------------------------
    -- ETAT 2 : LINEDETECTED
    ------------------------------------------------
    else
        -- LED6 éteinte
        fin_SL <= '0';
        if start_SL = '1' then
            -- suivi de ligne actif
            bias <= pos_ligne * GAIN;
            pwm_d := CONST_PWM + bias;
            pwm_g := CONST_PWM - bias;
            PWMdroit  <= to_unsigned(pwm_d,16);
            PWMgauche <= to_unsigned(pwm_g,16);
        else
            --robot arrêté si start_SL = 0
            PWMgauche <= (others => '0');
            PWMdroit  <= (others => '0');
        end if;
    end if;
end if;
end process;
END RTL; 