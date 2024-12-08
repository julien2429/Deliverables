library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity first_segment is
  Port (
    aclk : IN STD_LOGIC;
    arst: IN STD_LOGIC;
    first_tvalid  : IN STD_LOGIC;
    first_tready  : OUT STD_LOGIC;
    first_tdata   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    second_tvalid : IN STD_LOGIC;
    second_tready : OUT STD_LOGIC;
    second_tdata  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    result_tvalid : OUT STD_LOGIC;                  
    result_tready : IN STD_LOGIC;                   
    result_tdata  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
   );
end first_segment;

architecture Behavioral of first_segment is

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


signal fifo1_tvalid : STD_LOGIC;
signal fifo1_tready : STD_LOGIC;
signal fifo1_tdata  :  STD_LOGIC_VECTOR(15 DOWNTO 0);

signal fifo2_tvalid : STD_LOGIC;
signal fifo2_tready : STD_LOGIC;
signal fifo2_tdata :  STD_LOGIC_VECTOR(15 DOWNTO 0);

signal fifo3_tvalid : STD_LOGIC;
signal fifo3_tready : STD_LOGIC;
signal fifo3_tdata :  STD_LOGIC_VECTOR(15 DOWNTO 0);

begin

FIFO1 : axis_data_fifo_0
  PORT MAP (
    s_axis_aresetn => arst,
    s_axis_aclk =>    aclk,
    s_axis_tvalid =>  first_tvalid,
    s_axis_tready =>  first_tready,
    s_axis_tdata =>   first_tdata,
    m_axis_tvalid =>  fifo1_tvalid,
    m_axis_tready =>  fifo1_tready,
    m_axis_tdata =>   fifo1_tdata  
  );
  
  FIFO2 : axis_data_fifo_0
  PORT MAP (
    s_axis_aresetn => arst,
    s_axis_aclk =>    aclk,
    s_axis_tvalid =>  second_tvalid,
    s_axis_tready =>  second_tready,
    s_axis_tdata =>   second_tdata,
    m_axis_tvalid =>  fifo2_tvalid,
    m_axis_tready =>  fifo2_tready,
    m_axis_tdata =>   fifo2_tdata  
  );
  
  
  sub: subtractor
  PORT MAP (
     aclk                 => aclk,
     s_axis_a_tvalid      =>  fifo1_tvalid, 
     s_axis_a_tready      =>  fifo1_tready,
     s_axis_a_tdata       =>  fifo1_tdata ,
     s_axis_b_tvalid      =>  fifo2_tvalid,
     s_axis_b_tready      =>  fifo2_tready,
     s_axis_b_tdata       =>  fifo2_tdata ,
     m_axis_result_tvalid =>  fifo3_tvalid,
     m_axis_result_tready =>  fifo3_tready,
     m_axis_result_tdata  =>  fifo3_tdata
  );
  
  
  FIFO3 : axis_data_fifo_0
  PORT MAP (
    s_axis_aresetn => arst,
    s_axis_aclk =>    aclk,
    s_axis_tvalid =>  fifo3_tvalid,
    s_axis_tready =>  fifo3_tready,
    s_axis_tdata =>   fifo3_tdata,
    m_axis_tvalid =>  result_tvalid,
    m_axis_tready =>  result_tready,
    m_axis_tdata =>   result_tdata 
  );




end Behavioral;
