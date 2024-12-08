library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity tec_testbench is
--  Port ( );
end tec_testbench;

architecture Behavioral of tec_testbench is

component treshold 
Port (
    aclk                    : IN STD_LOGIC;
    s_axis_plus_tvalid      : IN STD_LOGIC;
    s_axis_plus_tready      : OUT STD_LOGIC;
    s_axis_plus_tdata       : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    s_axis_treshold_tvalid  : IN STD_LOGIC;
    s_axis_treshold_tready  : OUT STD_LOGIC;
    s_axis_treshold_tdata   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    s_axis_minus_tvalid     : IN STD_LOGIC;
    s_axis_minus_tready     : OUT STD_LOGIC;
    s_axis_minus_tdata      : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    m_axis_result_tvalid    : OUT STD_LOGIC;
    m_axis_result_tready    : IN STD_LOGIC;
    m_axis_result_tdata     : OUT STD_LOGIC;
    m_axis_gminus_tvalid    : OUT STD_LOGIC;
    m_axis_gminus_tready    : IN STD_LOGIC;
    m_axis_gminus_tdata     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    m_axis_gplus_tvalid     : OUT STD_LOGIC;
    m_axis_gplus_tready     : IN STD_LOGIC;
    m_axis_gplus_tdata      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
);
end component;
    signal aclk            : STD_LOGIC := '0';                     
    signal first_tvalid    : STD_LOGIC := '0';                   
    signal first_tready    : STD_LOGIC;                            
    signal first_tdata     : STD_LOGIC_VECTOR(15 DOWNTO 0) := (others => '0'); 
    
    signal second_tvalid   : STD_LOGIC := '0';                     
    signal second_tready   : STD_LOGIC;                          
    signal second_tdata    : STD_LOGIC_VECTOR(15 DOWNTO 0) := (others => '0'); 
    
    signal label_tvalid    : STD_LOGIC ;                          
    signal label_tready    : STD_LOGIC := '1';                    
    signal label_tdata     : STD_LOGIC; 

    signal gminus_out_tvalid: STD_LOGIC := '0';                                
    signal gminus_out_tready: STD_LOGIC := '1';                                       
    signal gminus_out_tdata : STD_LOGIC_VECTOR(15 DOWNTO 0) := (others => '0');
    
    signal gplus_out_tvalid : STD_LOGIC ;                                      
    signal gplus_out_tready : STD_LOGIC := '1';                                
    signal gplus_out_tdata  : STD_LOGIC_VECTOR(15 DOWNTO 0) := (others => '0');
      
    signal ready: std_logic :='1';
    signal treshold_val : STD_LOGIC_VECTOR(15 DOWNTO 0);
    
      
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
    first_tdata <= x"0000", x"0110" after 50ns, x"00A0" after 100ns, x"00F0" after 150ns, x"0005" after 200ns;
    second_tdata <= x"0001", x"0020" after 50ns, x"01D0" after 100ns, x"0000" after 150ns, x"ff9c" after 250ns, x"ffff" after 300ns;
    treshold_val <= x"00aa";
    
tresh: treshold
        port map(
        aclk    => aclk,                  
        s_axis_plus_tvalid     =>  first_tvalid,
        s_axis_plus_tready     =>  first_tready,
        s_axis_plus_tdata      =>  first_tdata ,
        s_axis_treshold_tvalid =>  '1',
        s_axis_treshold_tready =>  ready,
        s_axis_treshold_tdata  =>  treshold_val,
        s_axis_minus_tvalid    =>  second_tvalid,
        s_axis_minus_tready    =>  second_tready,
        s_axis_minus_tdata     =>  second_tdata ,
        m_axis_result_tvalid   =>  label_tvalid,
        m_axis_result_tready   =>  label_tready, 
        m_axis_result_tdata    =>  label_tdata ,
        m_axis_gminus_tvalid   =>  gminus_out_tvalid,
        m_axis_gminus_tready   =>  gminus_out_tready,
        m_axis_gminus_tdata    =>  gminus_out_tdata ,
        m_axis_gplus_tvalid    =>  gplus_out_tvalid ,
        m_axis_gplus_tready    =>  gplus_out_tready ,
        m_axis_gplus_tdata     =>  gplus_out_tdata
        );


end Behavioral;
