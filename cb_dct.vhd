--JPEG Encoder Block
-- D. Krishna Swaroop 2017A3PS0315P
-- Made as part of a Study Oriented Project in the 6th Semester


-- This block converts incoming Cb Data. The incoming bit stream should be unsigned 8-bits, which implies the data is in range of 0-255.
-- Unlike a typical DCT, the data is not subtracted by 128 to center it around 0.
-- It is only required for the first row, and instead of subtracting 128 from each
-- pixel value, a total value can be subtracted at the end of the first row/column multiply,
-- involving the 8 pixel values and the 8 DCT matrix values.
-- For the other 7 rows of the DCT matrix, the values in each row add up to 0,
-- so it is not necessary to subtract 128 from each Y, Cb, and Cr pixel value.
-- Then the Discrete Cosine Transform is performed by multiplying the 8x8 pixel block values
-- by the 8x8 DCT matrix.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- Entity description
entity cb_dct is port(
    clk           : in std_ulogic;
    rst           : in std_ulogic;
    enable        : in std_ulogic;
    data_in       : in std_ulogic_vector(7 downto 0);
    output_enable : out std_ulogic;
    Z11_final, Z12_final, Z13_final, Z14_final, Z15_final, Z16_final, Z17_final, Z18_final : out std_ulogic_vector(10 downto 0);
    Z21_final, Z22_final, Z23_final, Z24_final, Z25_final, Z26_final, Z27_final, Z28_final : out std_ulogic_vector(10 downto 0);
    Z31_final, Z32_final, Z33_final, Z34_final, Z35_final, Z36_final, Z37_final, Z38_final : out std_ulogic_vector(10 downto 0);
    Z41_final, Z42_final, Z43_final, Z44_final, Z45_final, Z46_final, Z47_final, Z48_final : out std_ulogic_vector(10 downto 0);
    Z51_final, Z52_final, Z53_final, Z54_final, Z55_final, Z56_final, Z57_final, Z58_final : out std_ulogic_vector(10 downto 0);
    Z61_final, Z62_final, Z63_final, Z64_final, Z65_final, Z66_final, Z67_final, Z68_final : out std_ulogic_vector(10 downto 0);
    Z71_final, Z72_final, Z73_final, Z74_final, Z75_final, Z76_final, Z77_final, Z78_final : out std_ulogic_vector(10 downto 0);
    Z81_final, Z82_final, Z83_final, Z84_final, Z85_final, Z86_final, Z87_final, Z88_final : out std_ulogic_vector(10 downto 0));
end entity cb_dct;

-- Architecture Description

architecture cb_dct_arch of cb_dct is
    
    -- DCT Matrix Entries
        variable T1  : integer:= 5793; -- .3536
        variable T21 : integer:= 8035; -- .4904
        variable T22 : integer:= 6811; -- .4157
        variable T23 : integer:= 4551; -- .2778
        variable T24 : integer:= 1598; -- .0975
        variable T25 : integer:= -1598; -- -.0975
        variable T26 : integer:= -4551; -- -.2778
        variable T27 : integer:= -6811; -- -.4157
        variable T28 : integer:= -8035; -- -.4904
        variable T31 : integer:= 7568; -- .4619
        variable T32 : integer:= 3135; -- .1913
        variable T33 : integer:= -3135; -- -.1913
        variable T34 : integer:= -7568; -- -.4619
        variable T52 : integer:= -5793; -- -.3536
        
        --iDCT Matrix Entries
        variable Ti1  : integer:= 5793; -- .3536
        variable Ti21 : integer:= 8035; -- .4904
        variable Ti22 : integer:= 6811; -- .4157
        variable Ti23 : integer:= 4551; -- .2778
        variable Ti24 : integer:= 1598; -- .0975
        variable Ti25 : integer:= -1598; -- -.0975
        variable Ti26 : integer:= -4551; -- -.2778
        variable Ti27 : integer:= -6811; -- -.4157
        variable Ti28 : integer:= -8035; -- -.4904
        variable Ti31 : integer:= 7568; -- .4619
        variable Ti32 : integer:= 3135; -- .1913
        variable Ti33 : integer:= -3135; -- -.1913
        variable Ti34 : integer:= -7568; -- -.4619
        variable Ti52 : integer:= -5793; -- -.3536
        
        --Signal descriptions
        
        signal Z_temp_11, Z_temp_12, Z_temp_13, Z_temp_14 : std_logic_vector(31 downto 0);
        signal Z_temp_15, Z_temp_16, Z_temp_17, Z_temp_18 : std_logic_vector(31 downto 0);
        signal Z_temp_21, Z_temp_22, Z_temp_23, Z_temp_24 : std_logic_vector(31 downto 0);
        signal Z_temp_25, Z_temp_26, Z_temp_27, Z_temp_28 : std_logic_vector(31 downto 0);
        signal Z_temp_31, Z_temp_32, Z_temp_33, Z_temp_34 : std_logic_vector(31 downto 0);
        signal Z_temp_35, Z_temp_36, Z_temp_37, Z_temp_38 : std_logic_vector(31 downto 0);
        signal Z_temp_41, Z_temp_46, Z_temp_43, Z_temp_44 : std_logic_vector(31 downto 0);
        signal Z_temp_45, Z_temp_46, Z_temp_47, Z_temp_48 : std_logic_vector(31 downto 0);
        signal Z_temp_51, Z_temp_52, Z_temp_53, Z_temp_54 : std_logic_vector(31 downto 0);
        signal Z_temp_55, Z_temp_56, Z_temp_57, Z_temp_58 : std_logic_vector(31 downto 0);
        signal Z_temp_61, Z_temp_62, Z_temp_63, Z_temp_64 : std_logic_vector(31 downto 0);
        signal Z_temp_65, Z_temp_66, Z_temp_67, Z_temp_68 : std_logic_vector(31 downto 0);
        signal Z_temp_71, Z_temp_72, Z_temp_73, Z_temp_74 : std_logic_vector(31 downto 0);
        signal Z_temp_75, Z_temp_76, Z_temp_77, Z_temp_78 : std_logic_vector(31 downto 0);
        signal Z_temp_81, Z_temp_82, Z_temp_83, Z_temp_84 : std_logic_vector(31 downto 0);
        signal Z_temp_85, Z_temp_86, Z_temp_87, Z_temp_88 : std_logic_vector(31 downto 0);
        

        signal Cb_temp11 : std_logic_vector(24 downto 0);
        signal Cb11, Cb21, Cb31, Cb41, Cb51, Cb61, Cb71, Cb81, Cb11_final                        : std_logic_vector(24 downto 0);
        signal Cb_temp_21, Cb_temp_31, Cb_temp_41, Cb_temp_51,Cb_temp_61, Cb_temp_71, Cb_temp_81 : std_logic_vector(31 downto 0);
        
        
        signal Z11, Z12, Z13, Z14, Z15, Z16, Z17, Z18 : std_logic_vector(24 downto 0);
        signal Z21, Z22, Z23, Z24, Z25, Z26, Z27, Z28 : std_logic_vector(24 downto 0);
        signal Z31, Z32, Z33, Z34, Z35, Z36, Z37, Z38 : std_logic_vector(24 downto 0);
        signal Z41, Z42, Z43, Z44, Z45, Z46, Z47, Z48 : std_logic_vector(24 downto 0);
        signal Z51, Z52, Z53, Z54, Z55, Z56, Z57, Z58 : std_logic_vector(24 downto 0);
        signal Z61, Z62, Z63, Z64, Z65, Z66, Z67, Z68 : std_logic_vector(24 downto 0);
        signal Z71, Z72, Z73, Z74, Z75, Z76, Z77, Z78 : std_logic_vector(24 downto 0);
        signal Z81, Z82, Z83, Z84, Z85, Z86, Z87, Z88 : std_logic_vector(24 downto 0);
        

        signal Cb11_final_2, Cb21_final_2, Cb11_final_3, Cb11_final_4, Cb31_final_2, Cb41_final_2 : std_logic_vector(31 downto 0);
        signal Cb51_final_2, Cb61_final_2, Cb71_final_2, Cb81_final_2                             : std_logic_vector(31 downto 0);
        
        signal Cb11_final_1, Cb21_final_1, Cb31_final_1, Cb41_final_1                             : std_logic_vector(10 downto 0);
        signal Cb51_final_1, Cb61_final_1, Cb71_final_1, Cb81_final_1                             : std_logic_vector(10 downto 0);
        
        signal Cb21_final, Cb31_final, Cb41_final, Cb51_final                                     : std_logic_vector(24 downto 0);
        signal Cb61_final, Cb71_final, Cb81_final                                                 : std_logic_vector(24 downto 0);

        signal Cb21_final_prev, Cb21_final_diff, Cb31_final_prev, Cb31_final_diff, Cb41_final_prev, Cb41_final_diff, Cb51_final_prev, Cb51_final_diff, Cb61_final_prev, Cb61_final_diff, Cb71_final_prev, Cb71_final_diff, Cb81_final_prev, Cb81_final_diff :std_logic_vector(24 downto 0);


        signal Z11_final, Z12_final, Z13_final, Z14_final: std_logic_vector(10 downto 0);
        signal Z15_final, Z16_final, Z17_final, Z18_final: std_logic_vector(10 downto 0);
        signal Z21_final, Z22_final, Z23_final, Z24_final: std_logic_vector(10 downto 0);
        signal Z25_final, Z26_final, Z27_final, Z28_final: std_logic_vector(10 downto 0);
        signal Z31_final, Z32_final, Z33_final, Z34_final: std_logic_vector(10 downto 0);
        signal Z35_final, Z36_final, Z37_final, Z38_final: std_logic_vector(10 downto 0);
        signal Z41_final, Z42_final, Z43_final, Z44_final: std_logic_vector(10 downto 0);
        signal Z45_final, Z46_final, Z47_final, Z48_final: std_logic_vector(10 downto 0);
        signal Z51_final, Z52_final, Z53_final, Z54_final: std_logic_vector(10 downto 0);
        signal Z55_final, Z56_final, Z57_final, Z58_final: std_logic_vector(10 downto 0);
        signal Z61_final, Z62_final, Z63_final, Z64_final: std_logic_vector(10 downto 0);
        signal Z65_final, Z66_final, Z67_final, Z68_final: std_logic_vector(10 downto 0);
        signal Z71_final, Z72_final, Z73_final, Z74_final: std_logic_vector(10 downto 0);
        signal Z75_final, Z76_final, Z77_final, Z78_final: std_logic_vector(10 downto 0);
        signal Z81_final, Z82_final, Z83_final, Z84_final: std_logic_vector(10 downto 0);
        signal Z85_final, Z86_final, Z87_final, Z88_final: std_logic_vector(10 downto 0);


        signal count, count_of, count_of_copy: std_logic_vector(2 downto 0);
        signal count_1, count_3, count_4, count_5, count_6, count_7, count_8, count_9, count_10, enable_1, output_enable : std_ulogic;

        signal data_1 : std_logic_vector(7 downto 0);

        variable Cb2_mul_input, Cb3_mul_input, Cb4_mul_input, Cb5_mul_input : integer;
        variable Cb6_mul_input, Cb7_mul_input, Cb8_mul_input                : integer;
        variable Ti2_mul_input, Ti3_mul_input, Ti4_mul_input, Ti5_mul_input : integer;
        variable Ti6_mul_input, Ti7_mul_input, Ti8_mul_input                : integer;




begin
    process_1: process(clk,rst,enable_1, count_8);
    begin
        if(rising_edge(clk)) then
                if(rst = '1') then
                        Z_temp_11 <= 0; Z_temp_12 <= 0; Z_temp_13 <= 0; Z_temp_14 <= 0;
                        Z_temp_15 <= 0; Z_temp_16 <= 0; Z_temp_17 <= 0; Z_temp_18 <= 0;
                        Z_temp_21 <= 0; Z_temp_22 <= 0; Z_temp_23 <= 0; Z_temp_24 <= 0;
                        Z_temp_25 <= 0; Z_temp_26 <= 0; Z_temp_27 <= 0; Z_temp_28 <= 0;
                        Z_temp_31 <= 0; Z_temp_32 <= 0; Z_temp_33 <= 0; Z_temp_34 <= 0;
                        Z_temp_35 <= 0; Z_temp_36 <= 0; Z_temp_37 <= 0; Z_temp_38 <= 0;
                        Z_temp_41 <= 0; Z_temp_42 <= 0; Z_temp_43 <= 0; Z_temp_44 <= 0;
                        Z_temp_45 <= 0; Z_temp_46 <= 0; Z_temp_47 <= 0; Z_temp_48 <= 0;
                        Z_temp_51 <= 0; Z_temp_52 <= 0; Z_temp_53 <= 0; Z_temp_54 <= 0;
                        Z_temp_55 <= 0; Z_temp_56 <= 0; Z_temp_57 <= 0; Z_temp_58 <= 0;
                        Z_temp_61 <= 0; Z_temp_62 <= 0; Z_temp_63 <= 0; Z_temp_64 <= 0;
                        Z_temp_65 <= 0; Z_temp_66 <= 0; Z_temp_67 <= 0; Z_temp_68 <= 0;
                        Z_temp_71 <= 0; Z_temp_72 <= 0; Z_temp_73 <= 0; Z_temp_74 <= 0;
                        Z_temp_75 <= 0; Z_temp_76 <= 0; Z_temp_77 <= 0; Z_temp_78 <= 0;
                        Z_temp_81 <= 0; Z_temp_82 <= 0; Z_temp_83 <= 0; Z_temp_84 <= 0;
                        Z_temp_85 <= 0; Z_temp_86 <= 0; Z_temp_87 <= 0; Z_temp_88 <= 0;
                elsif(enable_1 and count_8) then
                        Z_temp_11 <= Cb11_final_4 * Ti1; Z_temp_12 <= Cb11_final_4 * Ti2_mul_input;
                        Z_temp_13 <= Cb11_final_4 * Ti3_mul_input; Z_temp_14 <= Cb11_final_4 * Ti4_mul_input;
                        Z_temp_15 <= Cb11_final_4 * Ti5_mul_input; Z_temp_16 <= Cb11_final_4 * Ti6_mul_input;
                        Z_temp_17 <= Cb11_final_4 * Ti7_mul_input; Z_temp_18 <= Cb11_final_4 * Ti8_mul_input;
                        Z_temp_21 <= Cb21_final_2 * Ti1; Z_temp_22 <= Cb21_final_2 * Ti2_mul_input;
                        Z_temp_23 <= Cb21_final_2 * Ti3_mul_input; Z_temp_24 <= Cb21_final_2 * Ti4_mul_input;
                        Z_temp_25 <= Cb21_final_2 * Ti5_mul_input; Z_temp_26 <= Cb21_final_2 * Ti6_mul_input;
                        Z_temp_27 <= Cb21_final_2 * Ti7_mul_input; Z_temp_28 <= Cb21_final_2 * Ti8_mul_input;
                        Z_temp_31 <= Cb31_final_2 * Ti1; Z_temp_32 <= Cb31_final_2 * Ti2_mul_input;
                        Z_temp_33 <= Cb31_final_2 * Ti3_mul_input; Z_temp_34 <= Cb31_final_2 * Ti4_mul_input;
                        Z_temp_35 <= Cb31_final_2 * Ti5_mul_input; Z_temp_36 <= Cb31_final_2 * Ti6_mul_input;
                        Z_temp_37 <= Cb31_final_2 * Ti7_mul_input; Z_temp_38 <= Cb31_final_2 * Ti8_mul_input;
                        Z_temp_41 <= Cb41_final_2 * Ti1; Z_temp_42 <= Cb41_final_2 * Ti2_mul_input;
                        Z_temp_43 <= Cb41_final_2 * Ti3_mul_input; Z_temp_44 <= Cb41_final_2 * Ti4_mul_input;
                        Z_temp_45 <= Cb41_final_2 * Ti5_mul_input; Z_temp_46 <= Cb41_final_2 * Ti6_mul_input;
                        Z_temp_47 <= Cb41_final_2 * Ti7_mul_input; Z_temp_48 <= Cb41_final_2 * Ti8_mul_input;
                        Z_temp_51 <= Cb51_final_2 * Ti1; Z_temp_52 <= Cb51_final_2 * Ti2_mul_input;
                        Z_temp_53 <= Cb51_final_2 * Ti3_mul_input; Z_temp_54 <= Cb51_final_2 * Ti4_mul_input;
                        Z_temp_55 <= Cb51_final_2 * Ti5_mul_input; Z_temp_56 <= Cb51_final_2 * Ti6_mul_input;
                        Z_temp_57 <= Cb51_final_2 * Ti7_mul_input; Z_temp_58 <= Cb51_final_2 * Ti8_mul_input;
                        Z_temp_61 <= Cb61_final_2 * Ti1; Z_temp_62 <= Cb61_final_2 * Ti2_mul_input;
                        Z_temp_63 <= Cb61_final_2 * Ti3_mul_input; Z_temp_64 <= Cb61_final_2 * Ti4_mul_input;
                        Z_temp_65 <= Cb61_final_2 * Ti5_mul_input; Z_temp_66 <= Cb61_final_2 * Ti6_mul_input;
                        Z_temp_67 <= Cb61_final_2 * Ti7_mul_input; Z_temp_68 <= Cb61_final_2 * Ti8_mul_input;
                        Z_temp_71 <= Cb71_final_2 * Ti1; Z_temp_72 <= Cb71_final_2 * Ti2_mul_input;
                        Z_temp_73 <= Cb71_final_2 * Ti3_mul_input; Z_temp_74 <= Cb71_final_2 * Ti4_mul_input;
                        Z_temp_75 <= Cb71_final_2 * Ti5_mul_input; Z_temp_76 <= Cb71_final_2 * Ti6_mul_input;
                        Z_temp_77 <= Cb71_final_2 * Ti7_mul_input; Z_temp_78 <= Cb71_final_2 * Ti8_mul_input;
                        Z_temp_81 <= Cb81_final_2 * Ti1; Z_temp_82 <= Cb81_final_2 * Ti2_mul_input;
                        Z_temp_83 <= Cb81_final_2 * Ti3_mul_input; Z_temp_84 <= Cb81_final_2 * Ti4_mul_input;
                        Z_temp_85 <= Cb81_final_2 * Ti5_mul_input; Z_temp_86 <= Cb81_final_2 * Ti6_mul_input;
                        Z_temp_87 <= Cb81_final_2 * Ti7_mul_input; Z_temp_88 <= Cb81_final_2 * Ti8_mul_input;
                end if
            
        end if
    end process process_1;    

        
        process_2:process(clk, rst, count_8, count_of, enable, count_9)
        begin
                if(rising_edge(clk)) then
                    if(rst = '1') then
                        Z11 <= 0; Z12 <= 0; Z13 <= 0; Z14 <= 0; Z15 <= 0; Z16 <= 0; Z17 <= 0; Z18 <= 0;
		                Z21 <= 0; Z22 <= 0; Z23 <= 0; Z24 <= 0; Z25 <= 0; Z26 <= 0; Z27 <= 0; Z28 <= 0;
		                Z31 <= 0; Z32 <= 0; Z33 <= 0; Z34 <= 0; Z35 <= 0; Z36 <= 0; Z37 <= 0; Z38 <= 0;
		                Z41 <= 0; Z42 <= 0; Z43 <= 0; Z44 <= 0; Z45 <= 0; Z46 <= 0; Z47 <= 0; Z48 <= 0;
		                Z51 <= 0; Z52 <= 0; Z53 <= 0; Z54 <= 0; Z55 <= 0; Z56 <= 0; Z57 <= 0; Z58 <= 0;
		                Z61 <= 0; Z62 <= 0; Z63 <= 0; Z64 <= 0; Z65 <= 0; Z66 <= 0; Z67 <= 0; Z68 <= 0;
		                Z71 <= 0; Z72 <= 0; Z73 <= 0; Z74 <= 0; Z75 <= 0; Z76 <= 0; Z77 <= 0; Z78 <= 0;
                        Z81 <= 0; Z82 <= 0; Z83 <= 0; Z84 <= 0; Z85 <= 0; Z86 <= 0; Z87 <= 0; Z88 <= 0;
                    elsif (count_8 = '1' and count_of = '1') then
                        Z11 <= 0; Z12 <= 0; Z13 <= 0; Z14 <= 0;
		                Z15 <= 0; Z16 <= 0; Z17 <= 0; Z18 <= 0;
		                Z21 <= 0; Z22 <= 0; Z23 <= 0; Z24 <= 0;
		                Z25 <= 0; Z26 <= 0; Z27 <= 0; Z28 <= 0;
		                Z31 <= 0; Z32 <= 0; Z33 <= 0; Z34 <= 0;
		                Z35 <= 0; Z36 <= 0; Z37 <= 0; Z38 <= 0;
		                Z41 <= 0; Z42 <= 0; Z43 <= 0; Z44 <= 0;
		                Z45 <= 0; Z46 <= 0; Z47 <= 0; Z48 <= 0;
		                Z51 <= 0; Z52 <= 0; Z53 <= 0; Z54 <= 0;
		                Z55 <= 0; Z56 <= 0; Z57 <= 0; Z58 <= 0;
		                Z61 <= 0; Z62 <= 0; Z63 <= 0; Z64 <= 0;
		                Z65 <= 0; Z66 <= 0; Z67 <= 0; Z68 <= 0;
		                Z71 <= 0; Z72 <= 0; Z73 <= 0; Z74 <= 0;
		                Z75 <= 0; Z76 <= 0; Z77 <= 0; Z78 <= 0;
		                Z81 <= 0; Z82 <= 0; Z83 <= 0; Z84 <= 0;
                        Z85 <= 0; Z86 <= 0; Z87 <= 0; Z88 <= 0;
                    elsif (enable = '1' and count_9 = '1') then
                        Z11 <= Z_temp_11 + Z11; Z12 <= Z_temp_12 + Z12; Z13 <= Z_temp_13 + Z13; Z14 <= Z_temp_14 + Z14;
		                Z15 <= Z_temp_15 + Z15; Z16 <= Z_temp_16 + Z16; Z17 <= Z_temp_17 + Z17; Z18 <= Z_temp_18 + Z18;
		                Z21 <= Z_temp_21 + Z21; Z22 <= Z_temp_22 + Z22; Z23 <= Z_temp_23 + Z23; Z24 <= Z_temp_24 + Z24;
		                Z25 <= Z_temp_25 + Z25; Z26 <= Z_temp_26 + Z26; Z27 <= Z_temp_27 + Z27; Z28 <= Z_temp_28 + Z28;
		                Z31 <= Z_temp_31 + Z31; Z32 <= Z_temp_32 + Z32; Z33 <= Z_temp_33 + Z33; Z34 <= Z_temp_34 + Z34;
		                Z35 <= Z_temp_35 + Z35; Z36 <= Z_temp_36 + Z36; Z37 <= Z_temp_37 + Z37; Z38 <= Z_temp_38 + Z38;
		                Z41 <= Z_temp_41 + Z41; Z42 <= Z_temp_42 + Z42; Z43 <= Z_temp_43 + Z43; Z44 <= Z_temp_44 + Z44;
		                Z45 <= Z_temp_45 + Z45; Z46 <= Z_temp_46 + Z46; Z47 <= Z_temp_47 + Z47; Z48 <= Z_temp_48 + Z48;
		                Z51 <= Z_temp_51 + Z51; Z52 <= Z_temp_52 + Z52; Z53 <= Z_temp_53 + Z53; Z54 <= Z_temp_54 + Z54;
		                Z55 <= Z_temp_55 + Z55; Z56 <= Z_temp_56 + Z56; Z57 <= Z_temp_57 + Z57; Z58 <= Z_temp_58 + Z58;
		                Z61 <= Z_temp_61 + Z61; Z62 <= Z_temp_62 + Z62; Z63 <= Z_temp_63 + Z63; Z64 <= Z_temp_64 + Z64;
		                Z65 <= Z_temp_65 + Z65; Z66 <= Z_temp_66 + Z66; Z67 <= Z_temp_67 + Z67; Z68 <= Z_temp_68 + Z68;
		                Z71 <= Z_temp_71 + Z71; Z72 <= Z_temp_72 + Z72; Z73 <= Z_temp_73 + Z73; Z74 <= Z_temp_74 + Z74;
		                Z75 <= Z_temp_75 + Z75; Z76 <= Z_temp_76 + Z76; Z77 <= Z_temp_77 + Z77; Z78 <= Z_temp_78 + Z78;
		                Z81 <= Z_temp_81 + Z81; Z82 <= Z_temp_82 + Z82; Z83 <= Z_temp_83 + Z83; Z84 <= Z_temp_84 + Z84;
		                Z85 <= Z_temp_85 + Z85; Z86 <= Z_temp_86 + Z86; Z87 <= Z_temp_87 + Z87; Z88 <= Z_temp_88 + Z88
                    end if
                end if
        end process process_2;
        
        process_3 : process(clk,rst,count_10,count_of)
        begin
            if(rising_edge(clk)) then
                if(rst) then
                    Z11_final <= 0; Z12_final <= 0; Z13_final <= 0; Z14_final <= 0;
		            Z15_final <= 0; Z16_final <= 0; Z17_final <= 0; Z18_final <= 0;
		            Z21_final <= 0; Z22_final <= 0; Z23_final <= 0; Z24_final <= 0;
		            Z25_final <= 0; Z26_final <= 0; Z27_final <= 0; Z28_final <= 0;
		            Z31_final <= 0; Z32_final <= 0; Z33_final <= 0; Z34_final <= 0;
		            Z35_final <= 0; Z36_final <= 0; Z37_final <= 0; Z38_final <= 0;
		            Z41_final <= 0; Z42_final <= 0; Z43_final <= 0; Z44_final <= 0;
		            Z45_final <= 0; Z46_final <= 0; Z47_final <= 0; Z48_final <= 0;
		            Z51_final <= 0; Z52_final <= 0; Z53_final <= 0; Z54_final <= 0;
		            Z55_final <= 0; Z56_final <= 0; Z57_final <= 0; Z58_final <= 0;
		            Z61_final <= 0; Z62_final <= 0; Z63_final <= 0; Z64_final <= 0;
		            Z65_final <= 0; Z66_final <= 0; Z67_final <= 0; Z68_final <= 0;
		            Z71_final <= 0; Z72_final <= 0; Z73_final <= 0; Z74_final <= 0;
		            Z75_final <= 0; Z76_final <= 0; Z77_final <= 0; Z78_final <= 0;
		            Z81_final <= 0; Z82_final <= 0; Z83_final <= 0; Z84_final <= 0;
		            Z85_final <= 0; Z86_final <= 0; Z87_final <= 0; Z88_final <= 0;
                elsif (count_10 = '0' and count_of = '0') then
                    Z11_final <= Z11[13] ? Z11[24:14] + 1 : Z11[24:14];
		            Z12_final <= Z12[13] ? Z12[24:14] + 1 : Z12[24:14];
		            Z13_final <= Z13[13] ? Z13[24:14] + 1 : Z13[24:14];
		            Z14_final <= Z14[13] ? Z14[24:14] + 1 : Z14[24:14];
		            Z15_final <= Z15[13] ? Z15[24:14] + 1 : Z15[24:14];
		            Z16_final <= Z16[13] ? Z16[24:14] + 1 : Z16[24:14];
		            Z17_final <= Z17[13] ? Z17[24:14] + 1 : Z17[24:14];
                    Z18_final <= Z18[13] ? Z18[24:14] + 1 : Z18[24:14]; 
                    Z21_final <= Z21[13] ? Z21[24:14] + 1 : Z21[24:14];
                    Z22_final <= Z22[13] ? Z22[24:14] + 1 : Z22[24:14];
                    Z23_final <= Z23[13] ? Z23[24:14] + 1 : Z23[24:14];
                    Z24_final <= Z24[13] ? Z24[24:14] + 1 : Z24[24:14];
                    Z25_final <= Z25[13] ? Z25[24:14] + 1 : Z25[24:14];
                    Z26_final <= Z26[13] ? Z26[24:14] + 1 : Z26[24:14];
                    Z27_final <= Z27[13] ? Z27[24:14] + 1 : Z27[24:14];
                    Z28_final <= Z28[13] ? Z28[24:14] + 1 : Z28[24:14]; 
                    Z31_final <= Z31[13] ? Z31[24:14] + 1 : Z31[24:14];
                    Z32_final <= Z32[13] ? Z32[24:14] + 1 : Z32[24:14];
                    Z33_final <= Z33[13] ? Z33[24:14] + 1 : Z33[24:14];
                    Z34_final <= Z34[13] ? Z34[24:14] + 1 : Z34[24:14];
                    Z35_final <= Z35[13] ? Z35[24:14] + 1 : Z35[24:14];
                    Z36_final <= Z36[13] ? Z36[24:14] + 1 : Z36[24:14];
                    Z37_final <= Z37[13] ? Z37[24:14] + 1 : Z37[24:14];
                    Z38_final <= Z38[13] ? Z38[24:14] + 1 : Z38[24:14]; 
                    Z41_final <= Z41[13] ? Z41[24:14] + 1 : Z41[24:14];
                    Z42_final <= Z42[13] ? Z42[24:14] + 1 : Z42[24:14];
                    Z43_final <= Z43[13] ? Z43[24:14] + 1 : Z43[24:14];
                    Z44_final <= Z44[13] ? Z44[24:14] + 1 : Z44[24:14];
                    Z45_final <= Z45[13] ? Z45[24:14] + 1 : Z45[24:14];
                    Z46_final <= Z46[13] ? Z46[24:14] + 1 : Z46[24:14];
                    Z47_final <= Z47[13] ? Z47[24:14] + 1 : Z47[24:14];
                    Z48_final <= Z48[13] ? Z48[24:14] + 1 : Z48[24:14]; 
                    Z51_final <= Z51[13] ? Z51[24:14] + 1 : Z51[24:14];
                    Z52_final <= Z52[13] ? Z52[24:14] + 1 : Z52[24:14];
                    Z53_final <= Z53[13] ? Z53[24:14] + 1 : Z53[24:14];
                    Z54_final <= Z54[13] ? Z54[24:14] + 1 : Z54[24:14];
                    Z55_final <= Z55[13] ? Z55[24:14] + 1 : Z55[24:14];
                    Z56_final <= Z56[13] ? Z56[24:14] + 1 : Z56[24:14];
                    Z57_final <= Z57[13] ? Z57[24:14] + 1 : Z57[24:14];
                    Z58_final <= Z58[13] ? Z58[24:14] + 1 : Z58[24:14]; 
                    Z61_final <= Z61[13] ? Z61[24:14] + 1 : Z61[24:14];
                    Z62_final <= Z62[13] ? Z62[24:14] + 1 : Z62[24:14];
                    Z63_final <= Z63[13] ? Z63[24:14] + 1 : Z63[24:14];
                    Z64_final <= Z64[13] ? Z64[24:14] + 1 : Z64[24:14];
                    Z65_final <= Z65[13] ? Z65[24:14] + 1 : Z65[24:14];
                    Z66_final <= Z66[13] ? Z66[24:14] + 1 : Z66[24:14];
                    Z67_final <= Z67[13] ? Z67[24:14] + 1 : Z67[24:14];
                    Z68_final <= Z68[13] ? Z68[24:14] + 1 : Z68[24:14]; 
                    Z71_final <= Z71[13] ? Z71[24:14] + 1 : Z71[24:14];
                    Z72_final <= Z72[13] ? Z72[24:14] + 1 : Z72[24:14];
                    Z73_final <= Z73[13] ? Z73[24:14] + 1 : Z73[24:14];
                    Z74_final <= Z74[13] ? Z74[24:14] + 1 : Z74[24:14];
                    Z75_final <= Z75[13] ? Z75[24:14] + 1 : Z75[24:14];
                    Z76_final <= Z76[13] ? Z76[24:14] + 1 : Z76[24:14];
                    Z77_final <= Z77[13] ? Z77[24:14] + 1 : Z77[24:14];
                    Z78_final <= Z78[13] ? Z78[24:14] + 1 : Z78[24:14]; 
                    Z81_final <= Z81[13] ? Z81[24:14] + 1 : Z81[24:14];
                    Z82_final <= Z82[13] ? Z82[24:14] + 1 : Z82[24:14];
                    Z83_final <= Z83[13] ? Z83[24:14] + 1 : Z83[24:14];
                    Z84_final <= Z84[13] ? Z84[24:14] + 1 : Z84[24:14];
                    Z85_final <= Z85[13] ? Z85[24:14] + 1 : Z85[24:14];
                    Z86_final <= Z86[13] ? Z86[24:14] + 1 : Z86[24:14];
                    Z87_final <= Z87[13] ? Z87[24:14] + 1 : Z87[24:14];
                    Z88_final <= Z88[13] ? Z88[24:14] + 1 : Z88[24:14];
                end if
            end if         
        end process process_3;
        

        -- The data is now ready to be quantised. So we have to take care of enable signals for the next block i.e; the quantiser

        process_4_enable_signal_determiner : process(clk, rst, enable_1, count_10, count_of)
        begin
            if (rising_edge(clk)) then
                if (rst = '1') then
                    output_enable <= 0;
                elsif (enable_1 = '0') then
                    output_enable <= 0;
                elsif (count_10 = '0' and count_of = '0') then
                    output_enable <= 1;
                end if ;
            end if ;
        end process process_4;
        
        
        --setting other parameters

        process_5 : process(clk, rst, count, enable)
        begin
            if (rising_edge(clk)) then
                if (rst = '1') then
                    Cb_temp_11 <= 0;
                elsif (enable = '1') then
                    Cb_temp_11 <= data_in * T1;
                end if ;
            end if ;
        end process process_5;

        process_6 : process(clk, rst, count, enable)
        begin
            if (rising_edge(clk)) then
                if (rst = '1') then
                    Cb11 <= 0;
                elsif (enable = '1' and count = '1') then
                    Cb11 <= Cb_temp_11;
                elsif (enable = '1') then
                    Cb11 <= Cb_temp_11 + Cb11;
                end if ;
            end if ;
        end process process_6;

        process_7 : process(clk, rst, count, enable_1)
        begin
            if (rising_edge(clk)) then
                if (rst = '1') then
                    Cb_temp_21 <= 0;
                    Cb_temp_31 <= 0;
                    Cb_temp_41 <= 0;
                    Cb_temp_51 <= 0;
                    Cb_temp_61 <= 0;
                    Cb_temp_71 <= 0;
                    Cb_temp_81 <= 0;
                elsif (enable_1 = '0') then
                    Cb_temp_21 <= 0;
                    Cb_temp_31 <= 0;
                    Cb_temp_41 <= 0;
                    Cb_temp_51 <= 0;
                    Cb_temp_61 <= 0;
                    Cb_temp_71 <= 0;
                    Cb_temp_81 <= 0;
                elsif (enable_1 = '1') then
                    Cb_temp_21 <= data_1 * Cb2_mul_input; 
                    Cb_temp_31 <= data_1 * Cb3_mul_input; 
                    Cb_temp_41 <= data_1 * Cb4_mul_input; 
                    Cb_temp_51 <= data_1 * Cb5_mul_input; 
                    Cb_temp_61 <= data_1 * Cb6_mul_input; 
                    Cb_temp_71 <= data_1 * Cb7_mul_input; 
                    Cb_temp_81 <= data_1 * Cb8_mul_input;        
                end if ;
            end if ;
        end process process_7;
        
        process_8 : process(clk, rst, count, enable_1)
        begin
            if (rising_edge(clk)) then
                if (rst = '1') then
                    Cb21 <= 0;
                    Cb31 <= 0;
                    Cb41 <= 0;
                    Cb51 <= 0;
                    Cb61 <= 0;
                    Cb71 <= 0;
                    Cb81 <= 0;    
                elsif (enable_1 = '0') then
                    Cb21 <= 0;
                    Cb31 <= 0;
                    Cb41 <= 0;
                    Cb51 <= 0;
                    Cb61 <= 0;
                    Cb71 <= 0;
                    Cb81 <= 0;
                elsif (enable_1 = '1') then
                    Cb21 <= Cb_temp_21 + Cb21;
                    Cb31 <= Cb_temp_31 + Cb31;
                    Cb41 <= Cb_temp_41 + Cb41;
                    Cb51 <= Cb_temp_51 + Cb51;
                    Cb61 <= Cb_temp_61 + Cb61;
                    Cb71 <= Cb_temp_71 + Cb71;
                    Cb81 <= Cb_temp_81 + Cb81;           
                end if ;
            end if ;
        end process process_8;

        process_9 : process(clk, rst, count, enable)
        begin
            if (rising_edge(clk)) then
                if (rst = '1') then
                    count <= 0; count_3 <= 0; count_4 <= 0; count_5 <= 0;
                    count_6 <= 0; count_7 <= 0; count_8 <= 0; count_9 <= 0;
                    count_10 <= 0;    
                elsif (enable = '0') then
                    count <= 0; count_3 <= 0; count_4 <= 0; count_5 <= 0;
                    count_6 <= 0; count_7 <= 0; count_8 <= 0; count_9 <= 0;
                    count_10 <= 0;
                elsif (enable_1 = '1') then
                    count <= count + 1; count_3 <= count_1; count_4 <= count_3;
                    count_5 <= count_4; count_6 <= count_5; count_7 <= count_6;
                    count_8 <= count_7; count_9 <= count_8; count_10 <= count_9;         
                end if ;
            end if ;
        end process process_9;
        

        process_10 : process(clk, rst, count, enable)
        begin
            if (rising_edge(clk)) then
                if (rst = '1') then
                    count_1 <= 0;    
                elsif (count != 7 or enable = '0') then
                    count_1 <= 0;
                elsif (count = 7) then
                    count_1 <= 1;         
                end if ;
            end if ;
        end process process_10;

        process_11 : process(clk, rst, count_1, enable)
        begin
            if (rising_edge(clk)) then
                if (rst = '1') then
                    count_of <= 0;    
                    count_of <= 0;
                elsif (enable = '0') then
                    count_of <= 0;    
                    count_of <= 0;
                elsif (count_1 = 1) then
                    count_of <= count_of + 1;
                    count_of_copy <= count_of_copy + 1;         
                end if ;
            end if ;
        end process process_11;
        
        process_12 : process(clk, rst, count_3, enable_1)
        begin
            if (rising_edge(clk)) then
                if (rst = '1') then
                    Cb11_final <= 0;
                elsif (enable_1 = '1' && count_3 = '1') then
                    Cb11_final <= Cb11 - 25'd5932032;            -- The Cb values weren't centered on 0 before the DCT was performed. Therefore 128 needs to be subtracted from each Cb value. But here we need to subtract 362 because this is the total obtained by subtracting 128 from each element.          
                end if ;
            end if ;
        end process process_12;

        process_13 : process(clk, rst, count_4, enable_1)
        begin
            if (rising_edge(clk)) then
                if (rst = '1') then
                    Cb21_final <= 0; Cb21_final_prev <= 0;
                    Cb31_final <= 0; Cb31_final_prev <= 0;
                    Cb41_final <= 0; Cb41_final_prev <= 0;
                    Cb51_final <= 0; Cb51_final_prev <= 0;
                    Cb61_final <= 0; Cb61_final_prev <= 0;
                    Cb71_final <= 0; Cb71_final_prev <= 0;
                    Cb81_final <= 0; Cb81_final_prev <= 0;
                    
                elsif (enable_1 = '0') then
                    Cb21_final <= 0; Cb21_final_prev <= 0;
                    Cb31_final <= 0; Cb31_final_prev <= 0;
                    Cb41_final <= 0; Cb41_final_prev <= 0;
                    Cb51_final <= 0; Cb51_final_prev <= 0;
                    Cb61_final <= 0; Cb61_final_prev <= 0;
                    Cb71_final <= 0; Cb71_final_prev <= 0;
                    Cb81_final <= 0; Cb81_final_prev <= 0;
                elsif (count_4 = '1' and enable_1 = '1') then
                    Cb21_final <= Cb21; Cb21_final_prev <= Cb21_final;
                    Cb31_final <= Cb31; Cb31_final_prev <= Cb31_final;
                    Cb41_final <= Cb41; Cb41_final_prev <= Cb41_final;
                    Cb51_final <= Cb51; Cb51_final_prev <= Cb51_final;
                    Cb61_final <= Cb61; Cb61_final_prev <= Cb61_final;
                    Cb71_final <= Cb71; Cb71_final_prev <= Cb71_final;
                    Cb81_final <= Cb81; Cb81_final_prev <= Cb81_final;
                end if ;
            end if ;
        end process process_13;

        process_14 : process(clk, rst, count_5, enable_1)
        begin
            if (rising_edge(clk)) then
                if (rst = '1') then
                    Cb21_final_diff <= 0; Cb31_final_diff <= 0;
                    Cb41_final_diff <= 0; Cb51_final_diff <= 0;
                    Cb61_final_diff <= 0; Cb71_final_diff <= 0;
                    Cb81_final_diff <= 0;
                    
                elsif (enable_1 = '1' and count_5 = '1') then
                    Cb21_final_diff <= Cb21_final - Cb21_final_prev;	
                    Cb31_final_diff <= Cb31_final - Cb31_final_prev;	
                    Cb41_final_diff <= Cb41_final - Cb41_final_prev;	
                    Cb51_final_diff <= Cb51_final - Cb51_final_prev;	
                    Cb61_final_diff <= Cb61_final - Cb61_final_prev;	
                    Cb71_final_diff <= Cb71_final - Cb71_final_prev;	
                    Cb81_final_diff <= Cb81_final - Cb81_final_prev;         
                end if ;
            end if ;
        end process process_14;

        process_15 : process(clk, count)
        begin
            case (count) is
            when 3'b000	=>	Cb2_mul_input <= T21;
            when 3'b001	=>	Cb2_mul_input <= T22;
            when 3'b010	=>	Cb2_mul_input <= T23;
            when 3'b011	=>	Cb2_mul_input <= T24;
            when 3'b100	=>	Cb2_mul_input <= T25;
            when 3'b101	=>	Cb2_mul_input <= T26;
            when 3'b110	=>	Cb2_mul_input <= T27;
            when 3'b111	=>	Cb2_mul_input <= T28;
            when others =>  Cb2_mul_input <= 0;
            end case;
        end process process_15;

        process_16 : process(clk, count)
        begin
            case (count) is
            when 3'b000 =>		Cb3_mul_input <= T31;
            when 3'b001 =>		Cb3_mul_input <= T32;
            when 3'b010 =>		Cb3_mul_input <= T33;
            when 3'b011 =>		Cb3_mul_input <= T34;
            when 3'b100 =>		Cb3_mul_input <= T34;
            when 3'b101 =>		Cb3_mul_input <= T33;
            when 3'b110 =>		Cb3_mul_input <= T32;
            when 3'b111 =>		Cb3_mul_input <= T31;
            when others =>      Cb3_mul_input <= 0; 
            end case;
        end process process_16;

        process_17 : process(clk, count)
        begin
            case (count) is
                when 3'b000 =>		Cb4_mul_input <= T22;
                when 3'b001 =>		Cb4_mul_input <= T25;
                when 3'b010 =>		Cb4_mul_input <= T28;
                when 3'b011 =>		Cb4_mul_input <= T26;
                when 3'b100 =>		Cb4_mul_input <= T23;
                when 3'b101 =>		Cb4_mul_input <= T21;
                when 3'b110 =>		Cb4_mul_input <= T24;
                when 3'b111 =>		Cb4_mul_input <= T27;
                when others =>      Cb4_mul_input <= 0; 
            end case;
        end process process_17;
        
        
        process_18 : process(clk, count)
        begin
            case (count) is
                when 3'b000 =>		Cb5_mul_input <= T1;
                when 3'b001 =>		Cb5_mul_input <= T52;
                when 3'b010 =>		Cb5_mul_input <= T52;
                when 3'b011 =>		Cb5_mul_input <= T1;
                when 3'b100 =>		Cb5_mul_input <= T1;
                when 3'b101 =>		Cb5_mul_input <= T52;
                when 3'b110 =>		Cb5_mul_input <= T52;
                when 3'b111 =>		Cb5_mul_input <= T1;
                when others =>      Cb5_mul_input <= 0; 
            end case;
        end process process_18;

        process_19 : process(clk, count)
        begin
            case (count) is
                when 3'b000 =>		Cb6_mul_input <= T23;
                when 3'b001 =>		Cb6_mul_input <= T28;
                when 3'b010 =>		Cb6_mul_input <= T24;
                when 3'b011 =>		Cb6_mul_input <= T22;
                when 3'b100 =>		Cb6_mul_input <= T27;
                when 3'b101 =>		Cb6_mul_input <= T25;
                when 3'b110 =>		Cb6_mul_input <= T21;
                when 3'b111 =>		Cb6_mul_input <= T26;
                when others =>      Cb6_mul_input <= 0; 
            end case;
        end process process_19;

        process_20 : process(clk, count)
        begin
            case (count) is
                when 3'b000 =>		Cb7_mul_input <= T32;
                when 3'b001 =>		Cb7_mul_input <= T34;
                when 3'b010 =>		Cb7_mul_input <= T31;
                when 3'b011 =>		Cb7_mul_input <= T33;
                when 3'b100 =>		Cb7_mul_input <= T33;
                when 3'b101 =>		Cb7_mul_input <= T31;
                when 3'b110 =>		Cb7_mul_input <= T34;
                when 3'b111 =>		Cb7_mul_input <= T32;
                when others =>      Cb7_mul_input <= 0; 
            end case;
        end process process_20;

        process_21 : process(clk, count)
        begin
            case (count) is
                when 3'b000 =>		Cb8_mul_input <= T24;
                when 3'b001 =>		Cb8_mul_input <= T26;
                when 3'b010 =>		Cb8_mul_input <= T22;
                when 3'b011 =>		Cb8_mul_input <= T28;
                when 3'b100 =>		Cb8_mul_input <= T21;
                when 3'b101 =>		Cb8_mul_input <= T27;
                when 3'b110 =>		Cb8_mul_input <= T23;
                when 3'b111 =>		Cb8_mul_input <= T25;
                when others =>      Cb7_mul_input <= 0; 
            end case;
        end process process_21;

        -- iDCT matrices entries



        process_22 : process(clk, count_of_copy)
        begin
            case (count_of_copy) is
                when 3'b000 =>		Ti2_mul_input <= Ti28;
                when 3'b001 =>		Ti2_mul_input <= Ti21;
                when 3'b010 =>		Ti2_mul_input <= Ti22;
                when 3'b011 =>		Ti2_mul_input <= Ti23;
                when 3'b100 =>		Ti2_mul_input <= Ti24;
                when 3'b101 =>		Ti2_mul_input <= Ti25;
                when 3'b110 =>		Ti2_mul_input <= Ti26;
                when 3'b111 =>		Ti2_mul_input <= Ti27;
                when others =>      Ti2_mul_input <= 0; 
            end case;
        end process process_22;


        process_23 : process(clk, count_of_copy)
        begin
            case (count_of_copy) is
                when 3'b000 =>		Ti3_mul_input <= Ti31;
                when 3'b001 =>		Ti3_mul_input <= Ti31;
                when 3'b010 =>		Ti3_mul_input <= Ti32;
                when 3'b011 =>		Ti3_mul_input <= Ti33;
                when 3'b100 =>		Ti3_mul_input <= Ti34;
                when 3'b101 =>		Ti3_mul_input <= Ti34;
                when 3'b110 =>		Ti3_mul_input <= Ti33;
                when 3'b111 =>		Ti3_mul_input <= Ti32;
                when others =>      Ti3_mul_input <= 0; 
            end case;
        end process process_23;


        process_24 : process(clk, count_of_copy)
        begin
            case (count_of_copy) is
                when 3'b000 =>		Ti4_mul_input <= Ti27;
                when 3'b001 =>		Ti4_mul_input <= Ti22;
                when 3'b010 =>		Ti4_mul_input <= Ti25;
                when 3'b011 =>		Ti4_mul_input <= Ti28;
                when 3'b100 =>		Ti4_mul_input <= Ti26;
                when 3'b101 =>		Ti4_mul_input <= Ti23;
                when 3'b110 =>		Ti4_mul_input <= Ti21;
                when 3'b111 =>		Ti4_mul_input <= Ti24;
                when others =>      Ti4_mul_input <= 0; 
            end case;
        end process process_24;

        process_25 : process(clk, count_of_copy)
        begin
            case (count_of_copy) is
                when 3'b000 =>		Ti5_mul_input <= Ti1;
                when 3'b001 =>		Ti5_mul_input <= Ti1;
                when 3'b010 =>		Ti5_mul_input <= Ti52;
                when 3'b011 =>		Ti5_mul_input <= Ti52;
                when 3'b100 =>		Ti5_mul_input <= Ti1;
                when 3'b101 =>		Ti5_mul_input <= Ti1;
                when 3'b110 =>		Ti5_mul_input <= Ti52;
                when 3'b111 =>		Ti5_mul_input <= Ti52;
                when others =>      Ti5_mul_input <= 0; 
            end case;
        end process process_25;

        process_26 : process(clk, count_of_copy)
        begin
            case (count_of_copy) is
                when 3'b000 =>		Ti6_mul_input <= Ti26;
                when 3'b001 =>		Ti6_mul_input <= Ti23;
                when 3'b010 =>		Ti6_mul_input <= Ti28;
                when 3'b011 =>		Ti6_mul_input <= Ti24;
                when 3'b100 =>		Ti6_mul_input <= Ti22;
                when 3'b101 =>		Ti6_mul_input <= Ti27;
                when 3'b110 =>		Ti6_mul_input <= Ti25;
                when 3'b111 =>		Ti6_mul_input <= Ti21;
                when others =>      Ti6_mul_input <= 0; 
            end case;
        end process process_26;

        process_27 : process(clk, count_of_copy)
        begin
            case (count_of_copy) is
                when 3'b000 =>		Ti7_mul_input <= Ti32;
                when 3'b001 =>		Ti7_mul_input <= Ti32;
                when 3'b010 =>		Ti7_mul_input <= Ti34;
                when 3'b011 =>		Ti7_mul_input <= Ti31;
                when 3'b100 =>		Ti7_mul_input <= Ti33;
                when 3'b101 =>		Ti7_mul_input <= Ti33;
                when 3'b110 =>		Ti7_mul_input <= Ti31;
                when 3'b111 =>		Ti7_mul_input <= Ti34;
                when others =>      Ti7_mul_input <= 0; 
            end case;
        end process process_27;

        process_28 : process(clk, count_of_copy)
        begin
            case (count_of_copy) is
                when 3'b000 =>		Ti8_mul_input <= Ti25;
                when 3'b001 =>		Ti8_mul_input <= Ti24;
                when 3'b010 =>		Ti8_mul_input <= Ti26;
                when 3'b011 =>		Ti8_mul_input <= Ti22;
                when 3'b100 =>		Ti8_mul_input <= Ti28;
                when 3'b101 =>		Ti8_mul_input <= Ti21;
                when 3'b110 =>		Ti8_mul_input <= Ti27;
                when 3'b111 =>		Ti8_mul_input <= Ti23
                when others =>      Ti8_mul_input <= 0; 
            end case;
        end process process_28;



        --Rounding off stage

        process_29 : process(clk,rst,enable)
        begin
            if (rising_edge(clk)) then
                if (rst ='1') then
                    data_1 <= 0;
                    Cb11_final_1 <= 0; Cb21_final_1 <= 0; Cb31_final_1 <= 0; Cb41_final_1 <= 0;
                    Cb51_final_1 <= 0; Cb61_final_1 <= 0; Cb71_final_1 <= 0; Cb81_final_1 <= 0;
                    Cb11_final_2 <= 0; Cb21_final_2 <= 0; Cb31_final_2 <= 0; Cb41_final_2 <= 0;
                    Cb51_final_2 <= 0; Cb61_final_2 <= 0; Cb71_final_2 <= 0; Cb81_final_2 <= 0;
                    Cb11_final_3 <= 0; Cb11_final_4 <= 0;
                elsif (enable ='1') then
                    data_1 <= data_in;  
                    Cb11_final_1 <= Cb11_final[13] ? Cb11_final[24:14] + 1 : Cb11_final[24:14];
                    Cb11_final_2[31:11] <= Cb11_final_1[10] ? 21'b111111111111111111111 : 21'b000000000000000000000;
                    Cb11_final_2[10:0] <= Cb11_final_1;
                    Cb11_final_3 <= Cb11_final_2;
                    Cb11_final_4 <= Cb11_final_3;
                    Cb21_final_1 <= Cb21_final_diff[13] ? Cb21_final_diff[24:14] + 1 : Cb21_final_diff[24:14];
                    Cb21_final_2[31:11] <= Cb21_final_1[10] ? 21'b111111111111111111111 : 21'b000000000000000000000;
                    Cb21_final_2[10:0] <= Cb21_final_1;
                    Cb31_final_1 <= Cb31_final_diff[13] ? Cb31_final_diff[24:14] + 1 : Cb31_final_diff[24:14];
                    Cb31_final_2[31:11] <= Cb31_final_1[10] ? 21'b111111111111111111111 : 21'b000000000000000000000;
                    Cb31_final_2[10:0] <= Cb31_final_1;
                    Cb41_final_1 <= Cb41_final_diff[13] ? Cb41_final_diff[24:14] + 1 : Cb41_final_diff[24:14];
                    Cb41_final_2[31:11] <= Cb41_final_1[10] ? 21'b111111111111111111111 : 21'b000000000000000000000;
                    Cb41_final_2[10:0] <= Cb41_final_1;
                    Cb51_final_1 <= Cb51_final_diff[13] ? Cb51_final_diff[24:14] + 1 : Cb51_final_diff[24:14];
                    Cb51_final_2[31:11] <= Cb51_final_1[10] ? 21'b111111111111111111111 : 21'b000000000000000000000;
                    Cb51_final_2[10:0] <= Cb51_final_1;
                    Cb61_final_1 <= Cb61_final_diff[13] ? Cb61_final_diff[24:14] + 1 : Cb61_final_diff[24:14];
                    Cb61_final_2[31:11] <= Cb61_final_1[10] ? 21'b111111111111111111111 : 21'b000000000000000000000;
                    Cb61_final_2[10:0] <= Cb61_final_1;
                    Cb71_final_1 <= Cb71_final_diff[13] ? Cb71_final_diff[24:14] + 1 : Cb71_final_diff[24:14];
                    Cb71_final_2[31:11] <= Cb71_final_1[10] ? 21'b111111111111111111111 : 21'b000000000000000000000;
                    Cb71_final_2[10:0] <= Cb71_final_1;
                    Cb81_final_1 <= Cb81_final_diff[13] ? Cb81_final_diff[24:14] + 1 : Cb81_final_diff[24:14];
                    Cb81_final_2[31:11] <= Cb81_final_1[10] ? 21'b111111111111111111111 : 21'b000000000000000000000;
                    Cb81_final_2[10:0] <= Cb81_final_1;
                end if ;
                
            end if ;
        end process process_29;
        
        process_30 : process(clk,rst)
        begin
            if (rising_edge(clk)) then
                if (rst ='1') then
                    enable_1 <= 0;
                else
                    enable_1 <= enable;    
                    
                end if ;
                
            end if ;
        end process process_30;


end cb_dct_arch;








        


        
       
        
                            

                            


            
        

