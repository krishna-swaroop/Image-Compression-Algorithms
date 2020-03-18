--JPEG Encoder Block
-- D. Krishna Swaroop 2017A3PS0315P
-- Made as part of a Study Oriented Project in the 6th Semester

-- This block combines the Y, Cb and Cr blocks with the RGB to Y,Cb,Cr converter

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Entity Description
entity pre_fifo is
  port (
    clk,rst,enable    : in std_logic;
    data_in           : in std_logic_vector(23 downto 0);
    cr_JPEG_bitstream : out std_logic_vector(31 downto 0);
    cr_data_ready     : out std_logic;
    cr_orc            : out std_logic_vector(4 downto 0);
    cb_JPEG_bitstream : out std_logic_vector(31 downto 0);
    cb_data_ready     : out std_logic;
    cb_orc            : out std_logic_vector(4 downto 0);
    y_JPEG_bitstream  : out std_logic_vector(31 downto 0);
    y_data_ready      : out std_logic;
    y_orc             : out std_logic_vector(4 downto 0);
    y_eob_output      : out std_logic;
    y_eob_empty,cb_eob_empty, cr_eob_empty : out std_logic;
  ) ;
end pre_fifo;

-- Architecture description

architecture pre_fifo_arch of pre_fifo is

    component RGB2YCBCR is
        port(clk           : in std_ulogic;
            rst           : in std_ulogic;
            enable        : in std_ulogic;
            data_in       : in std_ulogic_vector(23 downto 0);
            data_out      : out std_ulogic_vector(23 downto 0);
            enable_out : out std_ulogic);
    end component;
    
    component crd_q_h is
        port()                 -- add ports after writing code for this
    end component;            

    component cbd_q_h is
        port()                 -- add ports after writing code for this
    end component;
    
    component yd_q_h is
        port()                 -- add ports after writing code for this
    end component;        

    signal rgb_enable : std_logic;
    signal dct_data_in: std_logic_vector(23 downto 0);
begin
    u4:RGB2YCBCR port map(clk => clk, rst =>rst, enable=>enable, data_in=>data_in, data_out=>dct_data_in, enable_out=>rgb_enable);
	
	u11: crd_q_h port map(clk=>clk, rst=>rst, enable=>rgb_enable, data_in=>dct_data_in(23 downto 16),JPEG_bitstream=>cr_JPEG_bitstream, data_ready=>cr_data_ready, cr_orc=>cr_orc,end_of_block_empty=>cr_eob_empty); 
	
	u12: cbd_q_h port map(clk=>clk, rst=>rst, enable=>rgb_enable, data_in=>dct_data_in(15 downto 8),JPEG_bitstream=>cb_JPEG_bitstream, data_ready=>cb_data_ready, cb_orc=>cb_orc, end_of_block_empty=>cb_eob_empty); 
 
  	u13: yd_q_h port map(clk=>clk, rst=>rst, enable=>rgb_enable, data_in=>dct_data_in(7 downto 0),JPEG_bitstream=>y_JPEG_bitstream, data_ready=>y_data_ready, y_orc=>y_orc,end_of_block_output=>y_eob_output, end_of_block_empty=>y_eob_empty);


end pre_fifo_arch ; -- pre_fifo_arch
