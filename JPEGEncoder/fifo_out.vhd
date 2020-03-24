--JPEG Encoder Block
-- D. Krishna Swaroop 2017A3PS0315P
-- Made as part of a Study Oriented Project in the 6th Semester

-- This block combines Y,Cb, Cr inputs from pre_fifo block into the
-- JPEG bitstream. This uses 3 FIFOs to write the Y, Cb, Cr data while its processing
-- the data. The output of this block goes to the input of the 
-- ff_checker block to check for any FFs in the bitstream.


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Entity Description
entity fifo_out is
  port (
    clk   : in std_logic;
    rst   : in std_logic;
    enable: in std_logic;
    data_in: in std_ulogic_vector(23 downto 0);
    JPEG_bitstream: in std_ulogic_vector(31 downto 0);

    data_ready: out std_ulogic;
    orc_reg   : out std_logic_vector(4 downto 0));
end fifo_out;

-- Architecture Description

architecture fifo_out_arch of fifo_out is

    signal cb_JPEG_bitstream, cr_JPEG_bitstream, y_JPEG_bitstream : std_logic_vector(31 downto 0);
    signal cr_orc, cb_orc, y_orc: std_logic_vector(4 downto 0);
    signal y_bits_out: std_logic_vector(31 downto 0);
    signal y_out_enable : std_logic;
    signal cb_data_ready, cr_data_ready, y_data_ready: std_logic;
    signal end_of_block_output, y_eob_empty: std_logic; 
    signal cb_eob_empty, cr_eob_empty: std_logic;
    signal y_fifo_empty: std_logic;


    signal cr_bits_out1, cr_bits_out2, cb_bits_out1, cb_bits_out2: std_logic_vector(31 downto 0);
    signal cr_fifo_empty1, cr_fifo_empty2, cb_fifo_empty1, cb_fifo_empty2 : std_logic;
    signal cr_out_enable1, cr_out_enable2, cb_out_enable1, cb_out_enable2 : std_logic;
    signal cb_write_enable : std_logic;
    signal cr_write_enable : std_logic;
    signal y_write_enable  : std_logic;
    signal cr_read_req1    : std_logic;
    
    signal cr_read_req2  : std_logic;
    signal cr_JPEG_bitstream1: std_logic_vector(31 downto 0);
    signal cr_JPEG_bitstream2: std_logic_vector(31 downto 0);
    signal cr_write_enable1 : std_logic;
    signal cr_write_enable2: std_logic;
    signal cr_bits_out : std_logic_vector(31 downto 0);
    signal cr_fifo_empty : std_logic;
    signal cr_out_enable : std_logic;
    signal cb_read_req1: std_logic;
    signal cb_read_req2 : std_logic;
    signal cb_JPEG_bitstream1 : std_logic_vector(31 downto 0) ;
    signal cb_JPEG_bitstream2 : std_logic_vector(31 downto 0);
    signal cb_write_enable1 : std_logic;
    signal cb_write_enable2 : std_logic;
    signal cb_bits_out   : std_logic_vector(31 downto 0);
    signal cb_fifo_empty : std_logic;
    signal cb_out_enable : std_logic;



    variable orc, orc_reg, orc_cb, orc_cr, old_orc_reg, sorc_reg, roll_orc_reg   : std_logic_vector(4 downto 0);
    variable orc_1, orc_2, orc_3, orc_4, orc_5, orc_reg_delay                    : std_logic_vector(4 downto 0);
    variable static_orc_1, static_orc_2, static_orc_3, static_orc_4, static_orc_5: std_logic_vector(4 downto 0);
    variable static_orc_6                                                        : std_logic_vector(4 downto 0);
    variable edge_ro_1, edge_ro_2, edge_ro_3, edge_ro_4, edge_ro_5               : std_logic_vector(4 downto 0);
    variable jpeg_ro_1, jpeg_ro_2, jpeg_ro_3, jpeg_ro_4, jpeg_ro_5, jpeg_delay   : std_logic_vector(31 downto 0);
    variable jpeg, jpeg_1, jpeg_2, jpeg_3, jpeg_4, jpeg_5, jpeg_6, JPEG_bitstream: std_logic_vector(31 downto 0);
    variable cr_orc_1, cb_orc_1, y_orc_1                                         : std_logic_vector(4 downto 0);
    variable cr_out_enable_1, cb_out_enable_1, y_out_enable_1, eob_1             : std_logic;
    variable eob_2, eob_3, eob_4                                                 : std_logic;
    variable enable_1, enable_2, enable_3, enable_4, enable_5                    : std_logic;
    variable enable_6, enable_7, enable_8, enable_9, enable_10                   : std_logic;
    variable enable_11, enable_12, enable_13, enable_14, enable_15               : std_logic;
    variable enable_16, enable_17, enable_18, enable_19, enable_20               : std_logic;
    variable enable_21, enable_22, enable_23, enable_24, enable_25               : std_logic;
    variable enable_26, enable_27, enable_28, enable_29, enable_30               : std_logic;
    variable enable_31, enable_32, enable_33, enable_34, enable_35               : std_logic;
    variable   bits_mux, old_orc_mux, read_mux                                   : std_logic_vector(2 downto 0);
    variable bits_ready, br_1, br_2, br_3, br_4, br_5, br_6, br_7, br_8          : std_logic;
    variable rollover, rollover_1, rollover_2, rollover_3, rollover_eob          : std_logic;
    variable rollover_4, rollover_5, rollover_6, rollover_7                      : std_logic;
    variable data_ready, eobe_1, cb_read_req, cr_read_req, y_read_req            : std_logic;
    variable eob_early_out_enable, fifo_mux                                      : std_logic;



begin
    cb_write_enable <= cb_data_ready and not cb_eob_empty;
    cr_write_enable <= cr_data_ready and not cr_eob_empty;
    y_write_enable  <= y_data_ready and not  y_eob_empty;
    cr_read_req1    <= 0 when fifo_mux ='1' else
                      cr_read_req when fifo_mux ='0';
    cr_read_req2    <= cr_read_req when fifo_mux = '1'else
                      0 when fifo_mux ='0';
    cr_JPEG_bitstream1 <= cr_JPEG_bitstream when fifo_mux='1' else 0 when fifo_mux ='0';
    cr_JPEG_bitstream2 <= 0 when fifo_mux='1' else cr_JPEG_bitstream when fifo_mux ='0';                                                                     

    
    cr_write_enable1   <= fifo_mux and cr_write_enable;
    cr_write_enable2   <= not fifo_mux and cr_write_enable;
    cr_bits_out        <= cr_bits_out2 when fifo_mux='1' else cr_bits_out1 when fifo_mux='0';
    cr_fifo_empty      <= cr_fifo_empty2 when fifo_mux='1' else cr_fifo_empty1 when fifo_mux='0';
    cr_out_enable      <= cr_out_enable2 when fifo_mux='1' else cr_out_enable1 when fifo_mux='0';

    cb_read_req1 <= 0 when fifo_mux='1' else cb_read_req when fifo_mux='0';
    cb_read_req2 <= cb_read_req when fifo_mux='1' else 0 when fifo_mux='0';

    cb_JPEG_bitstream1<= cb_JPEG_bitstream when fifo_mux='1' else 0 when fifo_mux='0';
    cb_JPEG_bitstream2<= 0 when fifo_mux='1' else cb_JPEG_bitstream when fifo_mux='0';

    cb_write_enable1 <= fifo_mux and cb_write_enable;
    cb_write_enable2 <= not fifo_mux and cb_write_enable;

    cb_bits_out <= cb_bits_out2 when fifo_mux='1' else cr_bits_out1 when fifo_mux='0';
    cb_fifo_empty <= cb_fifo_empty2 when fifo_mux='1' else cb_fifo_empty1 when fifo_mux='0';
    cb_out_enable <= cb_outenable2 when fifo_mux='1' else cb_out_enable1 when fifo_mux='0';

    u14: pre_fifo(clk=>clk, rst=>rst, enable=>enable,data_in=>data_in, cr_JPEG_bitstream=>cr_JPEG_bitstream,
    cr_data_ready=> cr_data_ready, cr_orc=>cr_orc,
    cb_JPEG_bitstream=>cb_JPEG_bitstream,cb_data_ready=>cb_data_ready,
    cb_orc=>cb_orc,
    y_JPEG_bitstream=>y_JPEG_bitstream;
    y_data_ready=>y_data_ready, y_orc=>y_orc,
    y_eob_output=>end_of_block_output,
    y_eob_empty=>y_eob_empty,
    cb_eob_empty=>cb_eob_empty,
    cr_eob_empty=>cr_eob_empty);
    
    u15: sync_fifo_32(clk=>clk, rst=>rst, read_req=>cb_read_req1, 
    write_data=>cb_JPEG_bitstream1, write_enable=>cb_write_enable1, 
    read_data=>cb_bits_out1, 
    fifo_empty=>cb_fifo_empty1, rdata_valid=>cb_out_enable1); 
    
    u25: sync_fifo_32(clk=>clk, rst=>rst, read_req=>cb_read_req2, 
    write_data=>cb_JPEG_bitstream2, write_enable=>cb_write_enable2, 
    read_data=>cb_bits_out2, 
    fifo_empty=>cb_fifo_empty2, rdata_valid=>cb_out_enable2);

    u16: sync_fifo_32(clk=>clk, rst=>rst, read_req=>cr_read_req1, 
    write_data=>cr_JPEG_bitstream1, write_enable=>cr_write_enable1, 
    read_data=>cr_bits_out1, 
    fifo_empty=>cr_fifo_empty1, rdata_valid=>cr_out_enable1);

    u24: sync_fifo_32(clk=>clk, rst=>rst, read_req=>cr_read_req2, 
    write_data=>cr_JPEG_bitstream2, write_enable=>cr_write_enable2, 
    read_data=>cr_bits_out2, 
    fifo_empty=>cr_fifo_empty2, rdata_valid=>cr_out_enable2);

    u17: sync_fifo_32(clk=>clk, rst=>rst, read_req=>y_read_req, 
    write_data=>y_JPEG_bitstream, write_enable=>y_write_enable, 
    read_data=>y_bits_out, 
    fifo_empty=>y_fifo_empty, rdata_valid=>y_out_enable);

    if (rising_edge(clk)) then
        --Defining fifo_mux signal value
        if (rst) then
            fifo_mux<=0;
        elsif (end_of_block_output) then
            fifo_mux <= fifo_mux + 1;
        end if ;
        
        
        -- Defining read request signal values for 3 streams
        if (y_fifo_empty='1' or read_mux /= 3'b001) then
            y_read_req <= 0;
        elsif (y_fifo_empty='0' and read_mux = 3'b001) then
            y_read_req <= 1;
        end if ;

        if (cb_fifo_empty='1' or read_mux /= 3'b010) then
            cb_read_req <= 0;
        elsif (cb_fifo_empty='0' and read_mux= 3'b010) then
            cb_read_req<=1;
        end if ;

        if(cr_fifo_empty='1' or read_mux /= 3'b100) then
            cr_read_req <= 0;
        elsif (cr_fifo_empty='0' and read_mux = 3'b100) then
            cr_read_req <= 1;
        end if;
        

        --Defining orc and rollover values
        if (rst) then
            br_1 <= 0; br_2 <= 0; br_3 <= 0; br_4 <= 0; br_5 <= 0; br_6 <= 0;
            br_7 <= 0; br_8 <= 0;
            static_orc_1 <= 0; static_orc_2 <= 0; static_orc_3 <= 0; 
            static_orc_4 <= 0; static_orc_5 <= 0; static_orc_6 <= 0;
            data_ready <= 0; eobe_1 <= 0;
        else
            br_1 <= bits_ready & !eobe_1; br_2 <= br_1; br_3 <= br_2;
            br_4 <= br_3; br_5 <= br_4; br_6 <= br_5;
            br_7 <= br_6; br_8 <= br_7;
            static_orc_1 <= sorc_reg; static_orc_2 <= static_orc_1; 
            static_orc_3 <= static_orc_2; static_orc_4 <= static_orc_3; 
            static_orc_5 <= static_orc_4; static_orc_6 <= static_orc_5;
            data_ready <= br_6 & rollover_5;
            eobe_1 <= y_eob_empty;
        end if ;

        if (rst) then
            rollover_eob<=0;
        elsif (br_3='1') then
            rollover_eob<= old_orc_reg;
            roll_orc_reg<= old_orc_reg;
        end if ;

        if(rst) then
            rollover_1 <= 0; rollover_2 <= 0; rollover_3 <= 0; 
            rollover_4 <= 0; rollover_5 <= 0; rollover_6 <= 0; 
            rollover_7 <= 0; eob_1 <= 0; eob_2 <= 0;
            eob_3 <= 0; eob_4 <= 0;
            eob_early_out_enable <= 0;
        else
            rollover_1 <= rollover; rollover_2 <= rollover_1; 
            rollover_3 <= rollover_2;
            rollover_4 <= rollover_3 | rollover_eob; 
            rollover_5 <= rollover_4; rollover_6 <= rollover_5; 
            rollover_7 <= rollover_6; eob_1 <= end_of_block_output; 
            eob_2 <= eob_1; eob_3 <= eob_2; eob_4 <= eob_3;	
            eob_early_out_enable <= y_out_enable & y_out_enable_1 & eob_2;
        end if;
        
        case( bits_mux ) is
        
            when 3'b001 =>
            rollover <= (y_out_enable_1) and (not eob_4) and (not eob_early_out_enable); 
            jpeg <= y_bits_out; 
            bits_ready <= y_out_enable;
            sorc_reg <= orc;
            orc_reg <= orc;

            when 3'b010 =>
            rollover <= cb_out_enable_1 and cb_out_enable; 
            jpeg <= cb_bits_out; 
            bits_ready <= cb_out_enable;
            sorc_reg <= orc_cb;
            orc_reg <= orc_cb;

            when 3'b100 =>
            rollover <= cr_out_enable_1 and cr_out_enable; 
            jpeg <= cr_bits_out;
            bits_ready <= cr_out_enable;
            sorc_reg<= orc_cr;
            orc_reg <= orc_cr;

            when others =>
            rollover<= y_out_enable_1 and (not eob_4); 
            jpeg <= y_bits_out;
            bits_ready<= y_out_enable;
            sorc_reg<=orc;
            orc_reg <= orc;
        
        end case ;

        if (rst) then
            orc<=0;
        elsif (enable_20) then
            orc<= orc_cr + cr_orc_1;
        end if ;

        if (rst) then
            orc_cb<=0;
        elsif (eob_1='1') then
            orc_cb <= orc + y_orc_1;
        end if ;

        if (rst) then
            orc_cr<=0;
        elsif (enable_5) then
            orc_cr <= orc_cb + cb_orc_1;
        end if ;

        if (rst) then
            cr_out_enable_1 <= 0;
            cb_out_enable_1 <= 0;
            y_out_enable_1 <= 0;
        else
            cr_out_enable_1 <= cr_out_enable;
            cb_out_enable_1 <= cb_out_enable;
            y_out_enable_1 <= y_out_enable;   
        end if ;

        case( old_orc_mux ) is
        
            when 3'b001 =>
            roll_orc_reg<= orc;
            old_orc_reg <= orc_cr;

            when 3'b010 =>
            roll_orc_reg<= orc_cb;
            old_orc_reg <= orc;

            when 3'b100 =>
            roll_orc_reg<= orc_cr;
            old_orc_reg <= orc_cb;
                
        
            when others =>
            roll_orc_reg<= orc;
            old_orc_reg <= orc_cr;
        
        end case ;
        

        -- Defining bits_mux, read_mux and old_orc_mux signals
        -- the convenience of HDL lul
        -- Literally used these signal like 30 times above
        if (rst='1') then
            bits_mux <= 3'b001;  -- Y channel
        elsif (enable_3='1') then
            bits_mux <= 3'b010;  -- Cb channel
        elsif (enable_19) then
            bits_mux <= 3'b100;  -- Cr Channel
        elsif (enable_35) then
            bits_mux <= 3'b001;  -- Y channel Again :)    
        end if ;

        if (rst='1') then
            old_orc_mux <= 3'b001;  -- Y channel
        elsif (enable_1) then
            old_orc_mux <= 3'b010;  --Cb channel
        elsif (enable_6) then
            old_orc_mux <= 3'b100;  -- Cr Channel
        elsif (enable_22) then
            old_orc_mux <= 3'b001;  -- Y channel again :)))    
        end if ;
        
        if (rst='1') then
            read_mux <= 3'b001;  -- Y channel
        elsif (enable_1) then
            read_mux <= 3'b010;  --Cb channel
        elsif (enable_17) then
            read_mux <= 3'b100;  -- Cr Channel
        elsif (enable_33) then
            read_mux <= 3'b001;  -- Y channel again :)))    
        end if ;




        if (rst='1') then
            cr_orc_1 <= 0; cb_orc_1 <= 0; y_orc_1 <= 0;
        elsif (end_of_block_output) then
            cr_orc_1 <= cr_orc;
            cb_orc_1 <= cb_orc;
            y_orc_1 <= y_orc;
        end if ;

        if (rst='1') then
            jpeg_ro_5 <= 0; edge_ro_5 <= 0;
        elsif (br_5) then
            jpeg_ro_5 <= shift_right(jpeg_ro_4,1) when (edge_ro_4 <= 1)='1' else jpeg_ro_4;
            edge_ro_5 <= edge_ro_4 when (edge_ro_4<=1)='1' else (edge_ro_4-'1');
        end if ;

        if (rst='1') then
            jpeg_5 <= 0; orc_5 <= 0; jpeg_ro_4 <= 0; edge_ro_4 <= 0
        elsif (br_4) then
            jpeg_5 <= shift_right(jpeg_4,1) when (orc_4>=1)='1' else jpeg_4;
            orc_5  <= orc_4-1 when (orc_4>=1)='1' else orc_4;
            jpeg_ro_4 <= shift_left(jpeg_ro_3,2) whe (edge_ro_3<=2)='1' else jpeg_ro_3;
            edge_ro_4 <= edge_ro_3 when (edge_ro_3<= 2)='1' else edge_ro_3-2;
        end if ;

        if (rst='1') then
            jpeg_4 <= 0; orc_4 <= 0; jpeg_ro_3 <= 0; edge_ro_3 <= 0;

        elsif (br_3='1') then
            jpeg_4 <= shift_right(jpeg_3,2) when (orc_3>=2)='1' else jpeg_3;
            orc_4  <= orc_3 - 2 when (orc_3>=2)='1' else orc_3;
            jpeg_ro_3 <= shift_left(jpeg_ro_2,4) when (edge_ro_2<=4)='1' else jpeg_ro_2;
            edge_ro_3 <= edge_ro_2 when (edge_ro_2 <= 4)='1' else edge_ro_2 - 4;
        end if ;

        if (rising_edge(clk)) then
            if (rst='1') then
                jpeg_3 <= 0; orc_3 <= 0; jpeg_ro_2 <= 0; edge_ro_2 <= 0;
            elsif (br_2='1') then
                jpeg_3 <= shift_right(jpeg_2,4) when (orc_2>=4)='1' else jpeg_2;
                orc_3  <= orc_2 - 4 when (orc_2 >=4)='1' else orc_2;
                jpeg_ro_2 <= shift_left(jpeg_ro_1,8) when (edge_ro_1 <= 8) ='1' else jpeg_ro_1;
                edge_ro_2 <= edge_ro_1 when (edge_ro_1 <= 8) ='1' else edge_ro_1 - 8;    
            end if ;
            
        end if ;

        if (rising_edge(clk)) then
            if (rst='1') then
                jpeg_2 <= 0; orc_2 <= 0; jpeg_ro_1 <= 0; edge_ro_1 <= 0;
            elsif (br_1='1') then
                jpeg_2 <= shift_right(jpeg_1,8) when (orc_1 >=8)='1' else jpeg_1;
                orc_2  <= orc_1 - 8 when (orc_1>=8)='1' else orc_1;
                jpeg_ro_1 <= shift_left(jpeg_delay,16) when (orc_reg_delay <= 16)='1' else jpeg_delay;
                edge_ro_1 <= orc_reg_delay when (orc_reg_delay <= 16) ='1' else orc_reg_delay - 16;
            end if ;
            
        end if ;
        
        if (rising_edge(clk)) then
            if (rst='1') then
                jpeg_1 <= 0; orc_1 <= 0; jpeg_delay <= 0; orc_reg_delay <= 0;
            elsif (bits_ready) then
                jpeg_1 <= shift_right(jpeg,16) when (orc_reg>= 16)='1' else jpeg;
                orc_1  <= orc_reg - 16 when (orc_reg >= 16)='1' else orc_reg;
                jpeg_delay <= jpeg;
                orc_reg_delay <= orc_reg;
            end if ;
            
        end if ;

        if (rising_edge(clk)) then
            if (rst='1') then
                enable_1 <= 0; enable_2 <= 0; enable_3 <= 0; enable_4 <= 0; enable_5 <= 0;
		        enable_6 <= 0; enable_7 <= 0; enable_8 <= 0; enable_9 <= 0; enable_10 <= 0;
		        enable_11 <= 0; enable_12 <= 0; enable_13 <= 0; enable_14 <= 0; enable_15 <= 0;
		        enable_16 <= 0; enable_17 <= 0; enable_18 <= 0; enable_19 <= 0; enable_20 <= 0;
		        enable_21 <= 0; enable_22 <= 0; enable_23 <= 0; enable_24 <= 0; enable_25 <= 0;
		        enable_26 <= 0; enable_27 <= 0; enable_28 <= 0; enable_29 <= 0; enable_30 <= 0;
                enable_31 <= 0; enable_32 <= 0; enable_33 <= 0; enable_34 <= 0; enable_35 <= 0;
            else
                enable_1 <= end_of_block_output; enable_2 <= enable_1; 
                enable_3 <= enable_2; enable_4 <= enable_3; enable_5 <= enable_4;
                enable_6 <= enable_5; enable_7 <= enable_6; enable_8 <= enable_7; 
                enable_9 <= enable_8; enable_10 <= enable_9; enable_11 <= enable_10; 
                enable_12 <= enable_11; enable_13 <= enable_12; enable_14 <= enable_13; 
                enable_15 <= enable_14; enable_16 <= enable_15; enable_17 <= enable_16; 
                enable_18 <= enable_17; enable_19 <= enable_18; enable_20 <= enable_19;
                enable_21 <= enable_20; 
                enable_22 <= enable_21; enable_23 <= enable_22; enable_24 <= enable_23; 
                enable_25 <= enable_24; enable_26 <= enable_25; enable_27 <= enable_26; 
                enable_28 <= enable_27; enable_29 <= enable_28; enable_30 <= enable_29;
                enable_31 <= enable_30; 
                enable_32 <= enable_31; enable_33 <= enable_32; enable_34 <= enable_33; 
                enable_35 <= enable_34;        
                
            end if ;
            
        end if ;

        if (rising_edge) then
            if (rst='1') then
                JPEG_bitstream(31) <= 0;JPEG_bitstream(30) <= 0;JPEG_bitstream(29) <= 0;JPEG_bitstream(28) <= 0;
                JPEG_bitstream(27) <= 0;JPEG_bitstream(26) <= 0;JPEG_bitstream(25) <= 0;JPEG_bitstream(24) <= 0;
                JPEG_bitstream(23) <= 0;JPEG_bitstream(22) <= 0;JPEG_bitstream(21) <= 0;JPEG_bitstream(20) <= 0;
                JPEG_bitstream(19) <= 0;JPEG_bitstream(18) <= 0;JPEG_bitstream(17) <= 0;JPEG_bitstream(16) <= 0;

                JPEG_bitstream(15) <= 0;JPEG_bitstream(14) <= 0;JPEG_bitstream(13) <= 0;JPEG_bitstream(12) <= 0;
                JPEG_bitstream(11) <= 0;JPEG_bitstream(10) <= 0;JPEG_bitstream(9) <= 0;JPEG_bitstream(8) <= 0;
                JPEG_bitstream(7) <= 0;JPEG_bitstream(6) <= 0;JPEG_bitstream(5) <= 0;JPEG_bitstream(4) <= 0;
                JPEG_bitstream(3) <= 0;JPEG_bitstream(2) <= 0;JPEG_bitstream(1) <= 0;JPEG_bitstream(0) <= 0;
            elsif ((br_7 and rollover_6)='1') then
                JPEG_bitstream(31) <= jpeg_6(31);JPEG_bitstream(30) <= jpeg_6[30];JPEG_bitstream[29] <= jpeg_6[29];JPEG_bitstream[28] <= jpeg_6[28];
                JPEG_bitstream(27) <= jpeg_6(27);JPEG_bitstream(26) <= jpeg_6[26];JPEG_bitstream[25] <= jpeg_6[25];JPEG_bitstream[24] <= jpeg_6[24];
                JPEG_bitstream(23) <= jpeg_6(23);JPEG_bitstream(22) <= jpeg_6[22];JPEG_bitstream[21] <= jpeg_6[21];JPEG_bitstream[20] <= jpeg_6[20];
                JPEG_bitstream(19) <= jpeg_6(19);JPEG_bitstream(18) <= jpeg_6[18];JPEG_bitstream[17] <= jpeg_6[17];JPEG_bitstream[16] <= jpeg_6[16];

                JPEG_bitstream(15) <= jpeg_6(15);JPEG_bitstream(14) <= jpeg_6[14];JPEG_bitstream[13] <= jpeg_6[13];JPEG_bitstream[12] <= jpeg_6[12];
                JPEG_bitstream(11) <= jpeg_6(11);JPEG_bitstream(10) <= jpeg_6[10];JPEG_bitstream[9] <= jpeg_6[9];JPEG_bitstream[8] <= jpeg_6[8];
                JPEG_bitstream(7) <= jpeg_6(7);JPEG_bitstream(6) <= jpeg_6[6];JPEG_bitstream[5] <= jpeg_6[5];JPEG_bitstream[4] <= jpeg_6[4];
                JPEG_bitstream(3) <= jpeg_6(3);JPEG_bitstream(2) <= jpeg_6[2];JPEG_bitstream[1] <= jpeg_6[1];JPEG_bitstream[0] <= jpeg_6[0];
            elsif ((br_6 && static_orc_6 <=0)='1') then
                JPEG_bitstream[31] <= jpeg_6[31];
            elsif ((br_6 && static_orc_6 <=1)='1') then
                    
                JPEG_bitstream[30] <= jpeg_6[30];
            elsif ((br_6 && static_orc_6 <=2)='1') then
                    
                JPEG_bitstream[29] <= jpeg_6[29];
            elsif ((br_6 && static_orc_6 <=3)='1') then
                
                JPEG_bitstream[28] <= jpeg_6[28];
            elsif ((br_6 && static_orc_6 <=4)='1') then
                 
                JPEG_bitstream[27] <= jpeg_6[27];
            elsif ((br_6 && static_orc_6 <=5)='1') then
                
                JPEG_bitstream[26] <= jpeg_6[26];
            elsif ((br_6 && static_orc_6 <=6)='1') then
                
                JPEG_bitstream[25] <= jpeg_6[25];
            elsif ((br_6 && static_orc_6 <=7)='1') then
                
                JPEG_bitstream[24] <= jpeg_6[24];
            elsif ((br_6 && static_orc_6 <=8)='1') then
                
                JPEG_bitstream[23] <= jpeg_6[23];
            elsif ((br_6 && static_orc_6 <=9)='1') then
                
                JPEG_bitstream[22] <= jpeg_6[22];
            elsif ((br_6 && static_orc_6 <=10)='1') then
                
                JPEG_bitstream[21] <= jpeg_6[21];
            elsif ((br_6 && static_orc_6 <=11)='1') then
                
                JPEG_bitstream[20] <= jpeg_6[20];
            elsif ((br_6 && static_orc_6 <=12)='1') then
                
                JPEG_bitstream[19] <= jpeg_6[19];
            elsif ((br_6 && static_orc_6 <=13)='1') then
                
                JPEG_bitstream[18] <= jpeg_6[18];
            elsif ((br_6 && static_orc_6 <=14)='1') then
                
                JPEG_bitstream[17] <= jpeg_6[17];
            elsif ((br_6 && static_orc_6 <=15)='1') then
                
                JPEG_bitstream[16] <= jpeg_6[16];
            elsif ((br_6 && static_orc_6 <=16)='1') then
                
                JPEG_bitstream[15] <= jpeg_6[15];
            elsif ((br_6 && static_orc_6 <=17)='1') then
                
                JPEG_bitstream[14] <= jpeg_6[14];
            elsif ((br_6 && static_orc_6 <=18)='1') then
                 
                JPEG_bitstream[13] <= jpeg_6[13];
            elsif ((br_6 && static_orc_6 <=19)='1') then
                
                JPEG_bitstream[12] <= jpeg_6[12];
            elsif ((br_6 && static_orc_6 <=20)='1') then
                
                JPEG_bitstream[11] <= jpeg_6[11];
            elsif ((br_6 && static_orc_6 <=21)='1') then
                
                JPEG_bitstream[10] <= jpeg_6[10];
            elsif ((br_6 && static_orc_6 <=22)='1') then
                
                JPEG_bitstream[9] <= jpeg_6[9];
            elsif ((br_6 && static_orc_6 <=23)='1') then
                
                JPEG_bitstream[8] <= jpeg_6[8];
            elsif ((br_6 && static_orc_6 <=24)='1') then
                
                JPEG_bitstream[7] <= jpeg_6[7];
            elsif ((br_6 && static_orc_6 <=25)='1') then
                
                JPEG_bitstream[6] <= jpeg_6[6];
            elsif ((br_6 && static_orc_6 <=26)='1') then
                
                JPEG_bitstream[5] <= jpeg_6[5];
            elsif ((br_6 && static_orc_6 <=27)='1') then
                
                JPEG_bitstream[4] <= jpeg_6[4];
            elsif ((br_6 && static_orc_6 <=28)='1') then
                
                JPEG_bitstream[3] <= jpeg_6[3];
            elsif ((br_6 && static_orc_6 <=29)='1') then
                
                JPEG_bitstream[2] <= jpeg_6[2];
            elsif ((br_6 && static_orc_6 <=30)='1') then
                
                JPEG_bitstream[1] <= jpeg_6[1];
            elsif ((br_6 && static_orc_6 <=31)='1') then
                
                JPEG_bitstream[0] <= jpeg_6[0];
            
            end if ;
        end if ;

        if (rising_edge(clk)) then
            if (rst='1') then
                jpeg_6 <= 0;
            elsif (br_5 or br_6) then
                jpeg_6(31) <= jpeg_ro_5(31) when (rollover_5 & static_orc_5 > 0) else jpeg_5(31);
                
                jpeg_6(0) <= jpeg_5(0);
                    

                
            end if ;
        end if ;    
    end if ;
end fifo_out_arch ; -- fifo_out_arch


