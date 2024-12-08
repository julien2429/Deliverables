library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use STD.TEXTIO.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity testbench_top_lvl is
--  Port ( );
end testbench_top_lvl;

architecture Behavioral of testbench_top_lvl is

component top_level 
  Port (
    aclk : IN STD_LOGIC;
    arst : IN STD_LOGIC;
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

    constant CLK_PERIOD : time := 10 ns; -- Clock period
    signal rd_count : integer := 0;
    signal wr_count : integer := 0;
    
    signal end_of_reading : std_logic := '0';
    signal arst: std_logic := '0';
begin

    clock_gen : process
    begin
        aclk <= '0';
        wait for CLK_PERIOD / 2;
        aclk <= '1';
        wait for CLK_PERIOD / 2;
    end process clock_gen;
    
    arst<= '0', '1' after 1ns;
    
    tp_lvl: top_level port map (
        aclk           => aclk,
        arst           => arst,
        first_tvalid   => first_tvalid,
        first_tready   => first_tready,
        first_tdata    => first_tdata,
        second_tvalid  => second_tvalid,
        second_tready  => second_tready,
        second_tdata   => second_tdata,
        label_tvalid   => label_tvalid,
        label_tready   => label_tready,
        label_tdata    => label_tdata
    );



 process (aclk)
--        file sensors_data : text open read_mode is "C:/Users/Julie/BMP180_good_data.csv";
--        file sensors_data : text open read_mode is "C:/Users/Julie/DHT11_good_data.csv";
--        file sensors_data : text open read_mode is "C:/Users/Julie/DHT22_good_data.csv";
--        file sensors_data : text open read_mode is "C:/Users/Julie/DS18B20_good_data.csv";
--        file sensors_data : text open read_mode is "C:/Users/Julie/LM35DZ_good_data.csv";
        file sensors_data : text open read_mode is "C:/Users/Julie/Thermistor_good_data.csv";
        variable in_line : line;
        VARIABLE first: boolean := true;
        variable timestamp : string(1 to 16);
        variable temperature1 : std_logic_vector(15 downto 0);
        variable temperature2 : std_logic_vector(15 downto 0);
        variable space : character;
        variable comma : character;
    begin
        if rising_edge(aclk) then
            if arst = '1' and end_of_reading = '0'  then
                report "Values reading";

                if not endfile(sensors_data) then     
                    
                    if first_tready = '1' and second_tready = '1'  then     -- read from the file only when the module is ready to accept data
                        readline(sensors_data, in_line);
                        read(in_line, temperature1);
                        
                    
                        first_tdata <= second_tdata;
                        second_tdata <= temperature1;
                        
                        if first = true then
                            first := false;
                        else
                            first_tvalid <= '1';
                        second_tvalid <= '1';
                            rd_count <= rd_count + 1;
                        end if;
                        
                        report "Values read";
                    else
                        first_tvalid <= '0';
                        second_tvalid <= '0';
                    end if;
                        
                else
                    file_close(sensors_data);
                    end_of_reading <= '1';
                end if;
            end if;
        end if;
    end process;
    
    -- write results in the output file
    process 
--        file results : text open write_mode is "C:/Users/Julie/OneDrive/Desktop/Anul III/SCS/Lab/Lab 8/Software/csvs/BMP180_vhdl_out_data.csv";    
--        file results : text open write_mode is "C:/Users/Julie/OneDrive/Desktop/Anul III/SCS/Lab/Lab 8/Software/csvs/DHT11_vhdl_out_data.csv";     
--        file results : text open write_mode is "C:/Users/Julie/OneDrive/Desktop/Anul III/SCS/Lab/Lab 8/Software/csvs/DHT22_vhdl_out_data.csv";     
--        file results : text open write_mode is "C:/Users/Julie/OneDrive/Desktop/Anul III/SCS/Lab/Lab 8/Software/csvs/DS18B20_vhdl_out_data.csv";   
--        file results : text open write_mode is "C:/Users/Julie/OneDrive/Desktop/Anul III/SCS/Lab/Lab 8/Software/csvs/LM35DZ_vhdl_out_data.csv";    
        file results : text open write_mode is "C:/Users/Julie/OneDrive/Desktop/Anul III/SCS/Lab/Lab 8/Software/csvs/Thermistor_vhdl_out_data.csv";
        variable out_line : line;
    begin
        wait until rising_edge(aclk);
            
        if arst = '0' then
            wait until rising_edge(arst);
        end if;
    
        if wr_count <= rd_count  then
            if label_tvalid = '1' then   -- write the result only when it is valid
                write(out_line, wr_count);
                write(out_line, string'(", "));
                write(out_line, label_tdata);
                writeline(results, out_line);
                
                wr_count <= wr_count + 1;
            end if;
        else
            if rd_count > 2 then
                file_close(results);
                report "execution finished...";
                wait;
            end if;
        end if;
    end process;

end Behavioral;
