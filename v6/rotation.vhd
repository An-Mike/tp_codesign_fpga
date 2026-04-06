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

CONSTANT CONST_PWM : integer := 16#2800#;
CONSTANT CONST_PWM_OPPOSITE : integer := 16#3800#;

BEGIN

process(clk, reset_n)
begin

    if reset_n = '0' then

        PWMgauche <= (others => '0');
        PWMdroit  <= (others => '0');
        fin_rot   <= '0';

    elsif rising_edge(clk) then

        -- CONDITION PRINCIPALE
        --if (start_rot = '1' and (pos_ligne = 6 or pos_ligne = -6)) then
		  if (start_rot = '1' and not (pos_ligne > -3 and pos_ligne < 3)) then

            -- ROTATION
            fin_rot <= '0';

            if dir_rot = '0' then
                -- gauche
                PWMgauche <= to_unsigned(CONST_PWM_OPPOSITE,16);
                PWMdroit  <= to_unsigned(CONST_PWM,16);
            else
                -- droite
                PWMgauche <= to_unsigned(CONST_PWM,16);
                PWMdroit  <= to_unsigned(CONST_PWM_OPPOSITE,16);
            end if;

        else

            -- FIN ROTATION / STOP
            PWMgauche <= (others => '0');
            PWMdroit  <= (others => '0');
            fin_rot   <= '1';

        end if;

    end if;

end process;

END RTL;