

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_level is
  Port (
    aclk : IN STD_LOGIC;
    arst: IN STD_LOGIC;
    first_tvalid  : IN STD_LOGIC;
    first_tready  : OUT STD_LOGIC;
    first_tdata   : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    second_tvalid : IN STD_LOGIC;
    second_tready : OUT STD_LOGIC;
    second_tdata  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    label_tvalid : OUT STD_LOGIC;                  
    label_tready : IN STD_LOGIC;                   
    label_tdata  : OUT STD_LOGIC
   );
end top_level;

architecture Behavioral of top_level is
    
  component first_segment 
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
end component;


component second_segment
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
end component;

component third_segment 
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
end component;

component forth_segment
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
end component;

component fifth_segment 
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
end component;
    
     -- Signal declarations
    signal first_to_second_valid    : STD_LOGIC := '0';
    signal first_to_second_ready    : STD_LOGIC := '0';
    signal first_to_second_data     : STD_LOGIC_VECTOR(15 DOWNTO 0) := (others => '0');
    
    
    
    signal second_to_third_fifoplus_valid    : STD_LOGIC := '0';                                
    signal second_to_third_fifoplus_ready    : STD_LOGIC := '0';                                
    signal second_to_third_fifoplus_data     : STD_LOGIC_VECTOR(15 DOWNTO 0) := (others => '0');
    
    signal second_to_third_fifominus_valid    : STD_LOGIC := '0';                                
    signal second_to_third_fifominus_ready    : STD_LOGIC := '0';                                
    signal second_to_third_fifominus_data     : STD_LOGIC_VECTOR(15 DOWNTO 0) := (others => '0');
    

    
    signal third_to_forth_plus_valid     :STD_LOGIC := '0';                                
    signal third_to_forth_plus_ready     :STD_LOGIC := '0';                                
    signal third_to_forth_plus_data      :STD_LOGIC_VECTOR(15 DOWNTO 0) := (others => '0');
    
    signal third_to_forth_minus_valid     : STD_LOGIC := '0';                                
    signal third_to_forth_minus_ready     : STD_LOGIC := '0';                                
    signal third_to_forth_minus_data      : STD_LOGIC_VECTOR(15 DOWNTO 0) := (others => '0');
    
    
    
    signal forth_to_fifth_plus_valid     : STD_LOGIC := '0';                                
    signal forth_to_fifth_plus_ready     : STD_LOGIC := '0';                                
    signal forth_to_fifth_plus_data      : STD_LOGIC_VECTOR(15 DOWNTO 0) := (others => '0');
    
    signal forth_to_fifth_minus_valid     : STD_LOGIC := '0';                                
    signal forth_to_fifth_minus_ready     : STD_LOGIC := '0';                                
    signal forth_to_fifth_minus_data      : STD_LOGIC_VECTOR(15 DOWNTO 0) := (others => '0');
    
    
    
    signal fifth_to_second_gplus_valid     : STD_LOGIC := '0';                                
    signal fifth_to_second_gplus_ready     : STD_LOGIC := '0';                                
    signal fifth_to_second_gplus_data      : STD_LOGIC_VECTOR(15 DOWNTO 0) := (others => '0');
    
    signal fifth_to_second_gminus_valid     : STD_LOGIC := '0';                                
    signal fifth_to_second_gminus_ready     : STD_LOGIC := '0';                                
    signal fifth_to_second_gminus_data      : STD_LOGIC_VECTOR(15 DOWNTO 0) := (others => '0');
    
    
    
    signal drift_signal             : STD_LOGIC_VECTOR(15 DOWNTO 0) := X"0032"; 
    signal threshold_signal         : STD_LOGIC_VECTOR(15 DOWNTO 0) := X"00C8"; 
    
    
begin

U1: first_segment
        port map (
            aclk           => aclk,
            arst           => arst,
            first_tvalid   => first_tvalid,
            first_tready   => first_tready,
            first_tdata    => first_tdata,
            second_tvalid  => second_tvalid,
            second_tready  => second_tready,
            second_tdata   => second_tdata,
            result_tvalid  => first_to_second_valid,
            result_tready  => first_to_second_ready,
            result_tdata   => first_to_second_data
        );

    -- Instantiate second_segment
    U2: second_segment
        port map (
            aclk            => aclk,
            arst           => arst,
            gplus_tvalid    => fifth_to_second_gplus_valid ,
            gplus_tready    => fifth_to_second_gplus_ready ,
            gplus_tdata     => fifth_to_second_gplus_data  ,
            gminus_tvalid   => fifth_to_second_gminus_valid , 
            gminus_tready   => fifth_to_second_gminus_ready ,
            gminus_tdata    => fifth_to_second_gminus_data  ,
            broadcast_tvalid => first_to_second_valid,
            broadcast_tready => first_to_second_ready,
            broadcast_tdata  => first_to_second_data,
            fifoplus_tvalid =>  second_to_third_fifoplus_valid  ,
            fifoplus_tready =>  second_to_third_fifoplus_ready  ,
            fifoplus_tdata  =>  second_to_third_fifoplus_data   ,
            fifominus_tvalid => second_to_third_fifominus_valid ,
            fifominus_tready => second_to_third_fifominus_ready ,
            fifominus_tdata  => second_to_third_fifominus_data  
        );

    -- Instantiate third_segment
    U3: third_segment
        port map (
            aclk            => aclk,
            arst           => arst,
            gplus_tvalid    => second_to_third_fifoplus_valid  ,
            gplus_tready    => second_to_third_fifoplus_ready  ,
            gplus_tdata     => second_to_third_fifoplus_data   ,
            gminus_tvalid   => second_to_third_fifominus_valid ,
            gminus_tready   => second_to_third_fifominus_ready ,
            gminus_tdata    => second_to_third_fifominus_data  ,
            drift           => drift_signal,
            fifoplus_tvalid =>  third_to_forth_plus_valid   ,
            fifoplus_tready =>  third_to_forth_plus_ready   ,
            fifoplus_tdata  =>  third_to_forth_plus_data    ,
            fifominus_tvalid => third_to_forth_minus_valid ,
            fifominus_tready => third_to_forth_minus_ready ,
            fifominus_tdata  => third_to_forth_minus_data 
        );

    -- Instantiate forth_segment
    U4: forth_segment
        port map (
            aclk            => aclk,
            arst           => arst,
            gplus_tvalid    => third_to_forth_plus_valid   ,
            gplus_tready    => third_to_forth_plus_ready   ,
            gplus_tdata     => third_to_forth_plus_data    ,
            gminus_tvalid   => third_to_forth_minus_valid , 
            gminus_tready   => third_to_forth_minus_ready , 
            gminus_tdata    => third_to_forth_minus_data  ,  
            fifoplus_tvalid  => forth_to_fifth_plus_valid ,
            fifoplus_tready  => forth_to_fifth_plus_ready ,
            fifoplus_tdata   => forth_to_fifth_plus_data  , 
            fifominus_tvalid => forth_to_fifth_minus_valid,
            fifominus_tready => forth_to_fifth_minus_ready,
            fifominus_tdata  => forth_to_fifth_minus_data 
        );                      

    -- Instantiate fifth_segment
    U5: fifth_segment
        port map (
            aclk              => aclk,
            gplus_tvalid      => forth_to_fifth_plus_valid ,
            gplus_tready      => forth_to_fifth_plus_ready ,
            gplus_tdata       => forth_to_fifth_plus_data  ,
            gminus_tvalid     => forth_to_fifth_minus_valid,
            gminus_tready     => forth_to_fifth_minus_ready,
            gminus_tdata      => forth_to_fifth_minus_data ,
            treshold_val      => threshold_signal,
            gplus_out_tvalid  => fifth_to_second_gplus_valid ,
            gplus_out_tready  => fifth_to_second_gplus_ready ,
            gplus_out_tdata   => fifth_to_second_gplus_data  ,
            gminus_out_tvalid => fifth_to_second_gminus_valid,
            gminus_out_tready => fifth_to_second_gminus_ready,
            gminus_out_tdata  => fifth_to_second_gminus_data ,
            label_tvalid      => label_tvalid,
            label_tready      => label_tready,
            label_tdata       => label_tdata
        );

end Behavioral;
