Library IEEE;
Use IEEE.STD_LOGIC_1164.All;
Use ieee.numeric_std.All;


Entity sin Is
 Generic (
  N : Integer := 7;   --tedade bit zavie voroodi
  iteration_num : integer := 10 
 );
 Port (
  start : In STD_LOGIC;
  beta : In STD_LOGIC_VECTOR (N -1 Downto 0);
  result_ready : Out STD_LOGIC;
  clk, reset : In STD_LOGIC;
  sin_out : Out std_logic_vector(N-1 Downto 0)
 );
End sin;

Architecture Behavioral Of sin Is
  
  constant scaling: unsigned (17 downto 0 ):= "100110110111000100";
 signal sin_calc :unsigned(N+19 Downto 0);

-- signal i:std_logic_vector;
 TYPE ram_type IS ARRAY (0 TO iteration_num) OF
 std_logic_vector(N+2 DOWNTO 0);
 signal x_ram : ram_type;
 signal y_ram : ram_type;
  signal z_ram : ram_type;
  signal done_reg : std_logic_vector(iteration_num downto 0);
  signal z0:std_logic_vector (N+2 downto 0) ; 
  signal x0:std_logic_vector (N+2 downto 0 ):= (N=>'1' , others=>'0');
  signal y0:std_logic_vector(N+2 downto 0 ):= (others=>'0');
  signal sin_temp: unsigned(N+20 downto 0);
  signal y_temp:unsigned (N+2 downto 0);
BEGIN
  z0 <=beta & "000";
  
c0: entity work.cordic(behavioral)
  generic map(N => N)
 port map (x=>x0 ,y=>y0 ,z=>z0 ,x_out=>x_ram(0)  ,y_out=>y_ram(0) ,z_out=>z_ram(0) ,i=>0, done=> done_reg(0),start=>start ,reset=> reset, clk=>clk );
x :for j in 1 to iteration_num  generate 
c: entity work.cordic(behavioral) 
generic map(N => N)
port map (x=>x_ram(j-1) ,y=>y_ram(j-1),z=>z_ram(j-1) ,x_out=>x_ram(j),y_out=>y_ram(j) ,z_out=>z_ram(j) ,i=> j, done=> done_reg(j),start=>done_reg(j-1) ,reset=>reset, clk=>clk );
end generate;

result_ready <= done_reg(iteration_num);
y_temp<=unsigned(y_ram(iteration_num));
sin_temp <= y_temp(N+2) & (scaling * y_temp(N+1 downto 0));
sin_out <=std_logic_vector(sin_temp(N+20 downto 21));
        
End Behavioral;

