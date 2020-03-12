--JPEG Encoder Block
-- D. Krishna Swaroop 2017A3PS0315P
-- Made as part of a Study Oriented Project in the 6th Semester


-- This block converts the incoming R,G,B 8-bit pixel data into Y, Cb, Cr 8-bit values.
-- The output values should be unsigned integers in the range of 0-255
-- data_in will have Red pixel value in [7:0], greeen pixel value [15:8] and blue in bits [23:16]

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- Entity description
entity rgb2ycbcr is port(
    clk           : in std_ulogic;
    rst           : in std_ulogic;
    enable        : in std_ulogic;
    data_in       : in std_ulogic_vector(23 downto 0);
    data_out      : out std_ulogic_vector(23 downto 0);
    enable_out : out std_ulogic);
end entity rgb2ycbcr;

architecture rgb2ycbcr_arch of rgb2ycbcr is
    --Signal description
    variable Y1  : std_ulogic_vector(13 downto 0):=14'd4899;
    variable Y2  : std_ulogic_vector(13 downto 0):=14'd9617;
    variable Y3  : std_ulogic_vector(13 downto 0):=14'd1868;
    variable CB1 : std_ulogic_vector(13 downto 0):=14'd2764;
    variable CB2 : std_ulogic_vector(13 downto 0):=14'd5428;
    variable CB3 : std_ulogic_vector(13 downto 0):=14'd8192;
    variable CR1 : std_ulogic_vector(13 downto 0):=14'd8192;
    variable CR2 : std_ulogic_vector(13 downto 0):=14'd6860;
    variable CR3 : std_ulogic_vector(13 downto 0):=14'd1332;

    

    signal Y_temp, CB_temp, CR_temp : std_ulogic_vector(21 downto 0);
    signal Y1_product, Y2_product, Y3_product : std_ulogic_vector(21 downto 0);
    signal CB1_product, CB2_product, CB3_product : std_ulogic_vector(21 downto 0);
    signal CR1_product, CR2_product, CR3_product : std_ulogic_vector(21 downto 0);
    signal Y, CB, CR : std_ulogic_vector(7 downto 0);
begin
    data_out <= (CR, CB, Y);
    
    process_1 : process(clk, rst, enable)
    begin
        if (rising_edge(clk)) then
            if (rst ='1') then
                Y1_product <= 0;	
                Y2_product <= 0;
                Y3_product <= 0;   
                CB1_product <= 0;	
                CB2_product <= 0;
                CB3_product <= 0;
                CR1_product <= 0;	
                CR2_product <= 0;
                CR3_product <= 0;
                Y_temp <= 0;
                CB_temp <= 0;
                CR_temp <= 0;
            elsif (enable ='1') then
                Y1_product <= Y1 * data_in[7:0];	
                Y2_product <= Y2 * data_in[15:8];
                Y3_product <= Y3 * data_in[23:16];   
                CB1_product <= CB1 * data_in[7:0];	
                CB2_product <= CB2 * data_in[15:8];
                CB3_product <= CB3 * data_in[23:16];
                CR1_product <= CR1 * data_in[7:0];	
                CR2_product <= CR2 * data_in[15:8];
                CR3_product <= CR3 * data_in[23:16];
                Y_temp <= Y1_product + Y2_product + Y3_product;
                CB_temp <= 22'd2097152 - CB1_product - CB2_product + CB3_product;
                CR_temp <= 22'd2097152 + CR1_product - CR2_product - CR3_product;   
            end if ;
        end if ;
    end process process_1;
    
    -- Rounding of Y, CB, CR wil require looking at bit 13, If bit 13 is '1' then values in [21:14] need to be rounded by adding 1 to the value in those btis

    process_2 : process(clk,rst,enable)
    begin
        if (rising_edge(clk)) then
            if (rst='1') then
                Y <= 0;
                CB <= 0;
                CR <= 0;
            elsif (enable = '1') then
                Y <= Y_temp[13] ? Y_temp[21:14] + 1: Y_temp[21:14];
		        CB <= CB_temp[13] & (CB_temp[21:14] != 8'd255) ? CB_temp[21:14] + 1: CB_temp[21:14];
		        CR <= CR_temp[13] & (CR_temp[21:14] != 8'd255) ? CR_temp[21:14] + 1: CR_temp[21:14];
            end if ;
        end if ;
    end process process_2;
    
    process_3 : process (clk,rst)
    begin
        if (rising_edge(clk)) then
            if (rst ='1') then
                enable_1 <= 0;
		        enable_2 <= 0;
                enable_out <= 0; 
            else
                enable_1 <= enable;
		        enable_2 <= enable_1;
		        enable_out <= enable_2;
            end if ;
        end if ;
    end process process_3;
end rgb2ycbcr_arch;


