library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
Use ieee.numeric_std.All;


entity tb_sin is
end tb_sin;

architecture Behavioral of tb_sin is
constant SIX  :    integer :=10;
constant iteration_num : integer:=10;
    constant T  :   time    := 10 ns; -- clock period
    signal clk , reset,start, result_ready: std_logic;
    signal beta: std_logic_vector(SIX-1 downto 0);
    signal sin_beta: std_logic_vector(SIX-1 downto 0);
 --   signal mx1, my1, mz1, mx2, my2, mz2, ytemp, xtemp,x1reg, x2reg ,y1reg, y2reg , z1reg, z2reg: std_logic_vector(SIX-1 downto 0);
begin
counter_unit    : entity work.sin(Behavioral)
        generic map(N => SIX,
        iteration_num=>iteration_num
        )
        port map(
        clk => clk,
        reset => reset,
        beta=>beta,
        sin_out => sin_beta,
        result_ready=>result_ready,
        start =>start
        );
        
        
        
        
-- *******************************************************
         -- ***         clock           ***********************
         --************************************************************
        process
        begin
            clk<='0';
            wait for T/2;
            clk<='1';
            wait for T/2;
        end process;


--other stimulus
process
begin 


reset <='1';
wait for 2 * T ;
reset <='0';
start <='1';
beta<="0001000011"; -- 30 degree = 0.5236
wait for 4*T ;
beta<="0010011100"; --70 degree = 1.22173
wait for 4*T ;
beta<="0010000110"; --60 degree=1.0472
wait for 150 * T ;


assert false
    report "Simulation Completed"
    severity failure;
end process;

end Behavioral;
