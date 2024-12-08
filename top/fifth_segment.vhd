library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity fifth_segment is
     Port (
        aclk : IN STD_LOGIC;
        gplus_tvalid   : IN STD_LOGIC;
        gplus_tready   : OUT STD_LOGIC;
        gplus_tdata    : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        gminus_tvalid  : IN STD_LOGIC;
        gminus_tready  : OUT STD_LOGIC;
        gminus_tdata   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        treshold_val       : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        gplus_out_tvalid : OUT STD_LOGIC;                  
        gplus_out_tready : IN STD_LOGIC;                   
        gplus_out_tdata  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        gminus_out_tvalid  : OUT STD_LOGIC;                   
        gminus_out_tready  : IN STD_LOGIC;                    
        gminus_out_tdata   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        label_tvalid : OUT STD_LOGIC;                  
        label_tready : IN STD_LOGIC;                   
        label_tdata  : OUT STD_LOGIC
        
   );
end fifth_segment;

architecture Behavioral of fifth_segment is

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

signal ready: std_logic :='1';

begin


tresh: treshold
        port map(
        aclk    => aclk,                  
        s_axis_plus_tvalid     =>  gplus_tvalid,
        s_axis_plus_tready     =>  gplus_tready,
        s_axis_plus_tdata      =>  gplus_tdata ,
        s_axis_treshold_tvalid =>  '1',
        s_axis_treshold_tready =>  ready,
        s_axis_treshold_tdata  =>  treshold_val,
        s_axis_minus_tvalid    =>  gminus_tvalid,
        s_axis_minus_tready    =>  gminus_tready,
        s_axis_minus_tdata     =>  gminus_tdata ,
        m_axis_result_tvalid   =>  label_tvalid,
        m_axis_result_tready   =>  label_tready,
        m_axis_result_tdata    =>  label_tdata ,
        m_axis_gminus_tvalid   =>  gminus_out_tvalid,
        m_axis_gminus_tready   =>  gminus_out_tready,
        m_axis_gminus_tdata    =>  gminus_out_tdata ,
        m_axis_gplus_tvalid    =>  gplus_out_tvalid,
        m_axis_gplus_tready    =>  gplus_out_tready,
        m_axis_gplus_tdata     =>  gplus_out_tdata
        );

end Behavioral;
