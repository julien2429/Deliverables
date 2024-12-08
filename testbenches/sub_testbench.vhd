
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity sub_testbench is
--  Port ( );
end sub_testbench;

architecture Behavioral of sub_testbench is

    COMPONENT subtractor
    Port (
        aclk                 : IN STD_LOGIC;
        s_axis_a_tvalid      : IN STD_LOGIC;
        s_axis_a_tready      : OUT STD_LOGIC;
        s_axis_a_tdata       : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        s_axis_b_tvalid      : IN STD_LOGIC;
        s_axis_b_tready      : OUT STD_LOGIC;
        s_axis_b_tdata       : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        m_axis_result_tvalid : OUT STD_LOGIC;
        m_axis_result_tready : IN STD_LOGIC;
        m_axis_result_tdata  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
    END COMPONENT;

    signal aclk            : STD_LOGIC := '0';                     
    signal first_tvalid    : STD_LOGIC := '0';                   
    signal first_tready    : STD_LOGIC;                            
    signal first_tdata     : STD_LOGIC_VECTOR(15 DOWNTO 0) := (others => '0'); 
    signal second_tvalid   : STD_LOGIC := '0';                     
    signal second_tready   : STD_LOGIC;                          
    signal second_tdata    : STD_LOGIC_VECTOR(15 DOWNTO 0) := (others => '0'); 
    signal label_tvalid    : STD_LOGIC ;                          
    signal label_tready    : STD_LOGIC := '1';                    
    signal label_tdata     : STD_LOGIC_VECTOR(15 DOWNTO 0) := (others => '0');   

    constant CLK_PERIOD : time := 10 ns; -- Clock period
begin

    clock_gen : process
    begin
        aclk <= '0';
        wait for CLK_PERIOD / 2;
        aclk <= '1';
        wait for CLK_PERIOD / 2;
    end process clock_gen;
  
    first_tvalid <= '1';

    second_tvalid <= '1';
    
    label_tready <= '1';
 
    first_tdata <= x"1000", x"2000" after 50ns, x"4000" after 100ns, x"FFFF" after 150ns, x"0000" after 200ns, x"0001" after 250ns;
    second_tdata <= x"0000", x"0001" after 50 ns, x"FFFF" after 100 ns, x"1230" after 150ns, x"0010" after 200ns;
  
    
    
  PLUS: subtractor
  PORT MAP (
     aclk                 => aclk,
     s_axis_a_tvalid      =>  first_tvalid ,
     s_axis_a_tready      =>  first_tready ,
     s_axis_a_tdata       =>  first_tdata  ,
     s_axis_b_tvalid      =>  second_tvalid,
     s_axis_b_tready      =>  second_tready,
     s_axis_b_tdata       =>  second_tdata ,
     m_axis_result_tvalid =>  label_tvalid ,
     m_axis_result_tready =>  label_tready ,
     m_axis_result_tdata  =>  label_tdata  
  );
    

end Behavioral;
