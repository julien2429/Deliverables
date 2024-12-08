library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity forth_segment is
     Port (
        aclk : IN STD_LOGIC;
        arst: IN STD_LOGIC;
        gplus_tvalid   : IN STD_LOGIC;
        gplus_tready   : OUT STD_LOGIC;
        gplus_tdata    : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        gminus_tvalid  : IN STD_LOGIC;
        gminus_tready  : OUT STD_LOGIC;
        gminus_tdata   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        fifoplus_tvalid : OUT STD_LOGIC;                  
        fifoplus_tready : IN STD_LOGIC;                   
        fifoplus_tdata  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        fifominus_tvalid : OUT STD_LOGIC;                   
        fifominus_tready : IN STD_LOGIC;                    
        fifominus_tdata  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        
   );
end forth_segment;

architecture Behavioral of forth_segment is

COMPONENT axis_data_fifo_0
  PORT (
    s_axis_aresetn : IN STD_LOGIC;
    s_axis_aclk : IN STD_LOGIC;
    s_axis_tvalid : IN STD_LOGIC;
    s_axis_tready : OUT STD_LOGIC;
    s_axis_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    m_axis_tvalid : OUT STD_LOGIC;
    m_axis_tready : IN STD_LOGIC;
    m_axis_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) 
  );
END COMPONENT;

COMPONENT maximum
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

signal max1_tvalid : STD_LOGIC;
signal max1_tready : STD_LOGIC;
signal max1_tdata  :  STD_LOGIC_VECTOR(15 DOWNTO 0);

signal max2_tvalid : STD_LOGIC;
signal max2_tready : STD_LOGIC;
signal max2_tdata :  STD_LOGIC_VECTOR(15 DOWNTO 0);

signal ready1: STD_LOGIC:= '0';
signal ready2: STD_LOGIC:= '0';

signal reference_value: STD_LOGIC_VECTOR(15 DOWNTO 0) :=x"0000";
begin


maximum1: maximum PORT MAP (
     aclk                 => aclk,
     s_axis_a_tvalid      => gplus_tvalid, 
     s_axis_a_tready      => gplus_tready,
     s_axis_a_tdata       => gplus_tdata ,
     s_axis_b_tvalid      =>  '1',
     s_axis_b_tready      =>  ready1,
     s_axis_b_tdata       =>  reference_value,
     m_axis_result_tvalid =>  max1_tvalid,
     m_axis_result_tready =>  max1_tready,
     m_axis_result_tdata  =>  max1_tdata 
  );
  
maximum2: maximum PORT MAP (
     aclk                 => aclk,
     s_axis_a_tvalid      => gminus_tvalid, 
     s_axis_a_tready      => gminus_tready,
     s_axis_a_tdata       => gminus_tdata ,
     s_axis_b_tvalid      =>  '1',
     s_axis_b_tready      =>  ready2,
     s_axis_b_tdata       =>  reference_value,
     m_axis_result_tvalid =>  max2_tvalid,
     m_axis_result_tready =>  max2_tready,
     m_axis_result_tdata  =>  max2_tdata 
  );
    
 FIFO1 : axis_data_fifo_0
  PORT MAP (
    s_axis_aresetn => arst,
    s_axis_aclk =>    aclk,
    s_axis_tvalid =>  max1_tvalid,
    s_axis_tready =>  max1_tready,
    s_axis_tdata =>   max1_tdata ,
    m_axis_tvalid =>  fifoplus_tvalid,
    m_axis_tready =>  fifoplus_tready,
    m_axis_tdata =>   fifoplus_tdata 
  );
  
FIFO2 : axis_data_fifo_0
  PORT MAP (
    s_axis_aresetn => arst,
    s_axis_aclk =>    aclk,
    s_axis_tvalid =>  max2_tvalid,
    s_axis_tready =>  max2_tready,
    s_axis_tdata =>   max2_tdata ,
    m_axis_tvalid =>  fifominus_tvalid,
    m_axis_tready =>  fifominus_tready,
    m_axis_tdata =>   fifominus_tdata 
  );


end Behavioral;
