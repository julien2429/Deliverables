library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity third_segment is
     Port (
        aclk : IN STD_LOGIC;
        arst: IN STD_LOGIC;
        gplus_tvalid   : IN STD_LOGIC;
        gplus_tready   : OUT STD_LOGIC;
        gplus_tdata    : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        gminus_tvalid  : IN STD_LOGIC;
        gminus_tready  : OUT STD_LOGIC;
        gminus_tdata   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        drift          : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        fifoplus_tvalid : OUT STD_LOGIC;                  
        fifoplus_tready : IN STD_LOGIC;                   
        fifoplus_tdata  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        fifominus_tvalid : OUT STD_LOGIC;                   
        fifominus_tready : IN STD_LOGIC;                    
        fifominus_tdata  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        
   );
end third_segment;

architecture Behavioral of third_segment is

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


signal sub1_tvalid : STD_LOGIC;
signal sub1_tready : STD_LOGIC;
signal sub1_tdata  :  STD_LOGIC_VECTOR(15 DOWNTO 0);

signal sub2_tvalid : STD_LOGIC;
signal sub2_tready : STD_LOGIC;
signal sub2_tdata :  STD_LOGIC_VECTOR(15 DOWNTO 0);

signal ready: STD_LOGIC;
begin


sub1: subtractor PORT MAP (
     aclk                 => aclk,
     s_axis_a_tvalid      => gplus_tvalid, 
     s_axis_a_tready      => gplus_tready,
     s_axis_a_tdata       => gplus_tdata ,
     s_axis_b_tvalid      =>  '1',
     s_axis_b_tready      =>  ready,
     s_axis_b_tdata       =>  drift ,
     m_axis_result_tvalid =>  sub1_tvalid,
     m_axis_result_tready =>  sub1_tready,
     m_axis_result_tdata  =>  sub1_tdata 
  );
  
sub2: subtractor PORT MAP (
     aclk                 => aclk,
     s_axis_a_tvalid      => gminus_tvalid, 
     s_axis_a_tready      => gminus_tready,
     s_axis_a_tdata       => gminus_tdata ,
     s_axis_b_tvalid      =>  '1',
     s_axis_b_tready      =>  ready,
     s_axis_b_tdata       =>  drift ,
     m_axis_result_tvalid =>  sub2_tvalid,
     m_axis_result_tready =>  sub2_tready,
     m_axis_result_tdata  =>  sub2_tdata 
  );
    
 FIFO1 : axis_data_fifo_0
  PORT MAP (
    s_axis_aresetn => arst,
    s_axis_aclk =>    aclk,
    s_axis_tvalid =>  sub1_tvalid,
    s_axis_tready =>  sub1_tready,
    s_axis_tdata =>   sub1_tdata ,
    m_axis_tvalid =>  fifoplus_tvalid,
    m_axis_tready =>  fifoplus_tready,
    m_axis_tdata =>   fifoplus_tdata 
  );
  
FIFO2 : axis_data_fifo_0
  PORT MAP (
    s_axis_aresetn => arst,
    s_axis_aclk =>    aclk,
    s_axis_tvalid =>  sub2_tvalid,
    s_axis_tready =>  sub2_tready,
    s_axis_tdata =>   sub2_tdata ,
    m_axis_tvalid =>  fifominus_tvalid,
    m_axis_tready =>  fifominus_tready,
    m_axis_tdata =>   fifominus_tdata 
  );


end Behavioral;
