library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;


entity second_segment is
    Port (
        aclk : IN STD_LOGIC;
        arst: IN STD_LOGIC;
        gplus_tvalid  : IN STD_LOGIC;
        gplus_tready  : OUT STD_LOGIC;
        gplus_tdata   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        gminus_tvalid  : IN STD_LOGIC;
        gminus_tready  : OUT STD_LOGIC;
        gminus_tdata   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        broadcast_tvalid : IN STD_LOGIC;
        broadcast_tready : OUT STD_LOGIC;
        broadcast_tdata  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        fifoplus_tvalid : OUT STD_LOGIC;                  
        fifoplus_tready : IN STD_LOGIC;                   
        fifoplus_tdata  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        fifominus_tvalid : OUT STD_LOGIC;                   
        fifominus_tready : IN STD_LOGIC;                    
        fifominus_tdata  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        
   );
end second_segment;

architecture Behavioral of second_segment is


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

COMPONENT adder
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

COMPONENT axis_broadcaster_0
  PORT (
    aclk : IN STD_LOGIC;
    aresetn : IN STD_LOGIC;
    s_axis_tvalid : IN STD_LOGIC;
    s_axis_tready : OUT STD_LOGIC;
    s_axis_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    m_axis_tvalid : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    m_axis_tready : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    m_axis_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) 
  );
END COMPONENT;

signal fifo1_tvalid :  STD_LOGIC;
signal fifo1_tready :  STD_LOGIC;
signal fifo1_tdata  :  STD_LOGIC_VECTOR(15 DOWNTO 0);

signal fifo2_tvalid : STD_LOGIC;
signal fifo2_tready : STD_LOGIC;
signal fifo2_tdata :  STD_LOGIC_VECTOR(15 DOWNTO 0);

signal broadcast_out_tvalid : STD_LOGIC_VECTOR(1 DOWNTO 0);
signal broadcast_out_tready : STD_LOGIC_VECTOR(1 DOWNTO 0);
signal broadcast_out_tdata  : STD_LOGIC_VECTOR(31 DOWNTO 0);


signal adder_tvalid : STD_LOGIC;
signal adder_tready : STD_LOGIC;
signal adder_tdata  :  STD_LOGIC_VECTOR(15 DOWNTO 0);

signal sub_tvalid : STD_LOGIC;
signal sub_tready : STD_LOGIC;
signal sub_tdata :  STD_LOGIC_VECTOR(15 DOWNTO 0);



begin 

FIFO1 : axis_data_fifo_0
  PORT MAP (
    s_axis_aresetn => arst,
    s_axis_aclk =>    aclk,
    s_axis_tvalid =>  gplus_tvalid ,
    s_axis_tready =>  gplus_tready ,
    s_axis_tdata =>   gplus_tdata  ,
    m_axis_tvalid =>  fifo1_tvalid ,
    m_axis_tready =>  fifo1_tready ,
    m_axis_tdata =>   fifo1_tdata  
  );

FIFO2 : axis_data_fifo_0
  PORT MAP (
    s_axis_aresetn => arst,
    s_axis_aclk =>    aclk,
    s_axis_tvalid =>  gminus_tvalid ,
    s_axis_tready =>  gminus_tready ,
    s_axis_tdata =>   gminus_tdata  ,
    m_axis_tvalid =>  fifo2_tvalid ,
    m_axis_tready =>  fifo2_tready ,
    m_axis_tdata =>   fifo2_tdata  
  );
  
 BROADCAST : axis_broadcaster_0
  PORT MAP (
    aclk => aclk,
    aresetn => arst,
    s_axis_tvalid =>  broadcast_tvalid  ,
    s_axis_tready =>  broadcast_tready  ,
    s_axis_tdata  =>  broadcast_tdata   ,
    m_axis_tvalid =>  broadcast_out_tvalid ,
    m_axis_tready =>  broadcast_out_tready ,
    m_axis_tdata  =>  broadcast_out_tdata 
  );
  
  
  PLUS: adder
  PORT MAP (
     aclk                 => aclk,
     s_axis_a_tvalid      =>  fifo1_tvalid, 
     s_axis_a_tready      =>  fifo1_tready,
     s_axis_a_tdata       =>  fifo1_tdata ,
     s_axis_b_tvalid      =>  broadcast_out_tvalid(0),
     s_axis_b_tready      =>  broadcast_out_tready(0),
     s_axis_b_tdata       =>  broadcast_out_tdata(15 downto 0),
     m_axis_result_tvalid =>  adder_tvalid,
     m_axis_result_tready =>  adder_tready,
     m_axis_result_tdata  =>  adder_tdata 
  );
  
  SUB: subtractor
  PORT MAP (
     aclk                 =>  aclk,
     s_axis_a_tvalid      =>  fifo2_tvalid, 
     s_axis_a_tready      =>  fifo2_tready,
     s_axis_a_tdata       =>  fifo2_tdata ,
     s_axis_b_tvalid      =>  broadcast_out_tvalid(1),
     s_axis_b_tready      =>  broadcast_out_tready(1),
     s_axis_b_tdata       =>  broadcast_out_tdata(31 downto 16),
     m_axis_result_tvalid =>  sub_tvalid,
     m_axis_result_tready =>  sub_tready,
     m_axis_result_tdata  =>  sub_tdata 
  );
  
  FIFO3 : axis_data_fifo_0
  PORT MAP (
    s_axis_aresetn => arst,
    s_axis_aclk =>    aclk,
    s_axis_tvalid =>  adder_tvalid ,
    s_axis_tready =>  adder_tready ,
    s_axis_tdata =>   adder_tdata  ,
    m_axis_tvalid =>  fifoplus_tvalid,
    m_axis_tready =>  fifoplus_tready,
    m_axis_tdata =>   fifoplus_tdata 
  );
  
  FIFO4 : axis_data_fifo_0
  PORT MAP (
    s_axis_aresetn => arst,
    s_axis_aclk =>    aclk,
    s_axis_tvalid =>  sub_tvalid ,
    s_axis_tready =>  sub_tready ,
    s_axis_tdata =>   sub_tdata  ,
    m_axis_tvalid =>  fifominus_tvalid ,
    m_axis_tready =>  fifominus_tready ,
    m_axis_tdata =>   fifominus_tdata   
  );

end Behavioral;
