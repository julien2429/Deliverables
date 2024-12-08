library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_signed.all;
entity treshold is
Port (
    aclk : IN STD_LOGIC;
    s_axis_plus_tvalid : IN STD_LOGIC;
    s_axis_plus_tready : OUT STD_LOGIC;
    s_axis_plus_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    
    s_axis_treshold_tvalid : IN STD_LOGIC;
    s_axis_treshold_tready : OUT STD_LOGIC;
    s_axis_treshold_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    
    s_axis_minus_tvalid : IN STD_LOGIC;
    s_axis_minus_tready : OUT STD_LOGIC;
    s_axis_minus_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    
    m_axis_result_tvalid : OUT STD_LOGIC;
    m_axis_result_tready : IN STD_LOGIC;
    m_axis_result_tdata : OUT STD_LOGIC;
    
    m_axis_gminus_tvalid : OUT STD_LOGIC;
    m_axis_gminus_tready : IN STD_LOGIC;
    m_axis_gminus_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    
    m_axis_gplus_tvalid : OUT STD_LOGIC;
    m_axis_gplus_tready : IN STD_LOGIC;
    m_axis_gplus_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
);
end treshold;
architecture Behavioral of treshold is
type state_type is (S_READ, S_WRITE, S_INIT);
signal state : state_type := S_INIT;
signal res_valid : STD_LOGIC := '0';
signal result : STD_LOGIC := '0';
signal plus: std_logic_vector(15 downto 0) := x"0000";
signal minus: std_logic_vector(15 downto 0) := x"0000";
signal a_ready, b_ready, c_ready: STD_LOGIC := '0';
signal internal_ready, external_ready, inputs_valid : STD_LOGIC := '0';

begin
s_axis_plus_tready <= external_ready;
s_axis_treshold_tready <= external_ready;
s_axis_minus_tready <= external_ready;

internal_ready <= '1' when ( state = S_READ or state = S_INIT) else '0';

inputs_valid <= s_axis_plus_tvalid and s_axis_treshold_tvalid and s_axis_minus_tvalid;

external_ready <= internal_ready and inputs_valid;

m_axis_result_tvalid <= '1' when (state = S_WRITE ) else '0';
m_axis_gplus_tvalid <= '1' when (state = S_WRITE ) else '0';
m_axis_gminus_tvalid <= '1' when (state = S_WRITE ) else '0';

m_axis_result_tdata <= result;
m_axis_gplus_tdata <= plus;
m_axis_gminus_tdata <= minus;


process(aclk)
variable plus_var : integer;
variable minus_var : integer;
variable treshold_var : integer;
begin

if rising_edge(aclk) then
    case state is
        when S_INIT =>
            result<= '0';
            plus <= x"0000";
            minus <= x"0000";
            state <= S_WRITE;
        when S_READ =>
        if external_ready = '1' and inputs_valid = '1' then
        
            plus_var:=  to_integer(signed(s_axis_plus_tdata));
            minus_var:=  to_integer(signed(s_axis_minus_tdata));
            treshold_var:=  to_integer(signed(s_axis_treshold_tdata));
            REPORT "TRESHOLD" & INTEGER'image(treshold_var) & "and " & INTEGER'image(plus_var) & "and " & INTEGER'image(minus_var);
            if plus_var > treshold_var or minus_var > treshold_var then
                result <= '1';
                plus <= x"0000";
                minus <= x"0000";
            else
                result <= '0';
                plus <= s_axis_plus_tdata;
                minus <= s_axis_minus_tdata;
            end if; 
            state <= S_WRITE;
        end if;
        when S_WRITE =>
            if m_axis_result_tready = '1' and m_axis_gplus_tready = '1' and m_axis_gminus_tready = '1' then
                state <= S_READ;
            end if;
    end case;
end if;

end process;
end Behavioral;