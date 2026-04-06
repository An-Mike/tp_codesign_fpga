LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY rotation IS
PORT(
    clk       : IN std_logic;
    reset_n   : IN std_logic;

    start_rot : IN std_logic;
    dir_rot   : IN std_logic;

    pos_ligne : IN integer range -6 to 6;

    PWMgauche : OUT unsigned(15 downto 0);
    PWMdroit  : OUT unsigned(15 downto 0);

    fin_rot   : OUT std_logic
);
END rotation;


ARCHITECTURE RTL OF rotation IS

TYPE state_type IS (ATTENTE, ROTATION, FIN);
SIGNAL state : state_type;

CONSTANT CONST_PWM : integer := 16#2900#;
CONSTANT CONST_PWM_OPPOSITE : integer := 16#3900#;

BEGIN

process(clk, reset_n)

begin

if reset_n = '0' then

    state <= ATTENTE;

    PWMgauche <= (others => '0');
    PWMdroit  <= (others => '0');

    fin_rot <= '0';

elsif rising_edge(clk) then

    case state is

    ------------------------------------------------
    -- ATTENTE
    ------------------------------------------------
    when ATTENTE =>

        PWMgauche <= (others => '0');
        PWMdroit  <= (others => '0');

        fin_rot <= '0';

        if start_rot = '1' then
            state <= ROTATION;
        end if;


    ------------------------------------------------
    -- ROTATION
    ------------------------------------------------
    when ROTATION =>

        fin_rot <= '0';

        if dir_rot = '0' then
            -- rotation gauche
            PWMgauche <= to_unsigned(CONST_PWM_OPPOSITE,16);
            PWMdroit  <= to_unsigned(CONST_PWM,16);
        else
            -- rotation droite
            PWMgauche <= to_unsigned(CONST_PWM,16);
            PWMdroit  <= to_unsigned(CONST_PWM_OPPOSITE,16);
        end if;

        if pos_ligne = 0 then
            state <= FIN;
        end if;


    ------------------------------------------------
    -- FIN
    ------------------------------------------------
    when FIN =>

        PWMgauche <= (others => '0');
        PWMdroit  <= (others => '0');

        fin_rot <= '1';

        if start_rot = '0' then
            state <= ATTENTE;
        end if;

    end case;

end if;

end process;

END RTL;