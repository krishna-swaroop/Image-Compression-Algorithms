--JPEG Encoder Block
-- D. Krishna Swaroop 2017A3PS0315P
-- Made as part of a Study Oriented Project in the 6th Semester

-- This block defines a 32-bit Synthesizable FIFO

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Entity Description

entity sync_fifo_32 is
    port (
        clk         : in std_ulogic;
        rst         : in std_ulogic;
        read_req    : in std_ulogic;
        write_data  : in std_ulogic_vector(31 downto 0);
        write_enable: in std_ulogic;

        read_data   : out std_ulogic_vector(31 downto 0);
        fifo_empty  : out std_ulogic;
        rdata_valid : out std_ulogic;
        
    );
end entity sync_fifo_32;

architecture sync_fifo_32_arch of sync_fifo_32 is
    variable read_ptr : std_ulogic_vector(4 downto 0);
    variable write_ptr: std_logic_vector(4 downto 0);
    variable rdata_valid : std_ulogic;
    variable read_data : std_logic_vector(31 downto 0)

    signal mem is array (0 to 15) of std_ulogic_vector(31 downto 0);
    signal write_addr : std_ulogic_vector(3 downto 0):= write_ptr(3 downto 0);
    signal read_addr : std_ulogic_vector(3 downto 0):= read_ptr(3 downto 0);
    
    signal read_enable : std_logic:= read_req and not fifo_empty;
begin
    if (read_ptr and write_ptr = '1') then
        fifo_empty <= 1;
    else
        fifo_empty <= 0;    
    end if ;

    process_1 : process(clk, rst, write_enable)
    begin
        if (rising_edge(clk)) then
            if (rst ='1') then
                write_ptr <= {(5){1'b0}};
            elsif (write_enable = '1') then
                write_ptr <= write_ptr + {{4{1'b0}},1'b1};
            end if ;
        end if ;
    end process process_1;
    
    process_2 : process(clk,rst, read_enable)
    begin
    if (rising_edge(clk)) then
        if (rst='1') then
            rdata_valid <= 1'b0;
        elsif (read_enable='1') then
            rdata_valid <= 1'b1;
        else
            rdata_valid <= 1'b0;
        end if ;
    end if ;
    end process process_2;

    process_3: process(clk,rst, read_enable)
    begin
        if rising_edge(clk) then
            if (rst = '1') then
                read_ptr <= {(5){1'b0}};
            elsif (read_enable='1') then
                read_ptr <= read_ptr + {{4{1'b0}},1'b1};
            end if;
        end if;
    end process process_3;

    process_4 : process (clk)
    begin
        if (write_enable ='1') then
            mem[write_addr] <= write_data;
        end if ;
    end process process_4;
    
    process_5: process(clk, read_enable)
    begin
        if (read_enable) then
            read_data <= mem[read_addr];
        end if ;
        
    end process process_5; 


end sync_fifo_32_arch ; 