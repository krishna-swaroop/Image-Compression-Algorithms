--JPEG Encoder Block
-- D. Krishna Swaroop 2017A3PS0315P
-- Made as part of a Study Oriented Project in the 6th Semester.


-- This block combines the DCT, Quantizer and Huffman Modules for Cr data.


entity crd_q_h is port map(
    clk           : in std_logic;
    rst           : in std_logic;
    enable        : in std_logic;
    data_in       : in std_ulogic_vector(7 downto 0);
    JPEG_bitstream: out std_ulogic_vector(31 downto 0);
    data_ready    : out std_logic;
    cr_orc        : out std_ulogic_vector(4 downto 0);
    end_of_block_empty : out std_logic);
end crd_q_h;

--Architecture description

architecture crd_q_h_arch of crd_q_h is

    signal dct_enable, quantizer_enable : std_logic_vector(10 downto 0);
    
    signal Z11_final, Z12_final, Z13_final, Z14_final : std_logic_vector(10 downto 0);
    signal Z15_final, Z16_final, Z17_final, Z18_final : std_logic_vector(10 downto 0);
    signal Z21_final, Z22_final, Z23_final, Z24_final : std_logic_vector(10 downto 0);
    signal Z25_final, Z26_final, Z27_final, Z28_final : std_logic_vector(10 downto 0);
    signal Z31_final, Z32_final, Z33_final, Z34_final : std_logic_vector(10 downto 0);
    signal Z35_final, Z36_final, Z37_final, Z38_final : std_logic_vector(10 downto 0);
    signal Z41_final, Z42_final, Z43_final, Z44_final : std_logic_vector(10 downto 0);
    signal Z45_final, Z46_final, Z47_final, Z48_final : std_logic_vector(10 downto 0);
    signal Z51_final, Z52_final, Z53_final, Z54_final : std_logic_vector(10 downto 0);
    signal Z55_final, Z56_final, Z57_final, Z58_final : std_logic_vector(10 downto 0);
    signal Z61_final, Z62_final, Z63_final, Z64_final : std_logic_vector(10 downto 0);
    signal Z65_final, Z66_final, Z67_final, Z68_final : std_logic_vector(10 downto 0);
    signal Z71_final, Z72_final, Z73_final, Z74_final : std_logic_vector(10 downto 0);
    signal Z75_final, Z76_final, Z77_final, Z78_final : std_logic_vector(10 downto 0);
    signal Z81_final, Z82_final, Z83_final, Z84_final : std_logic_vector(10 downto 0);
    signal Z85_final, Z86_final, Z87_final, Z88_final : std_logic_vector(10 downto 0);
    
    signal Q11, Q12, Q13, Q14, Q15, Q16, Q17, Q18 : std_logic_vector(10 downto 0); 	
    signal Q21, Q22, Q23, Q24, Q25, Q26, Q27, Q28 : std_logic_vector(10 downto 0); 
    signal Q31, Q32, Q33, Q34, Q35, Q36, Q37, Q38 : std_logic_vector(10 downto 0); 
    signal Q41, Q42, Q43, Q44, Q45, Q46, Q47, Q48 : std_logic_vector(10 downto 0); 
    signal Q51, Q52, Q53, Q54, Q55, Q56, Q57, Q58 : std_logic_vector(10 downto 0); 
    signal Q61, Q62, Q63, Q64, Q65, Q66, Q67, Q68 : std_logic_vector(10 downto 0); 
    signal Q71, Q72, Q73, Q74, Q75, Q76, Q77, Q78 : std_logic_vector(10 downto 0); 
    signal Q81, Q82, Q83, Q84, Q85, Q86, Q87, Q88 : std_logic_vector(10 downto 0);

begin
    u8 : cr_dct port map(clk => clk,rst=>rst, data_in => data_in,Z11_final=>Z11_final, Z12_final=>Z12_final, 
	Z13_final=>Z13_final, Z14_final=>Z14_final, Z15_final=>Z15_final, Z16_final=>Z16_final, 
	Z17_final=>Z17_final, Z18_final=>Z18_final, Z21_final=>Z21_final, Z22_final=>Z22_final, 
	Z23_final=>Z23_final, Z24_final=>Z24_final, Z25_final=>Z25_final, Z26_final=>Z26_final, 
	Z27_final=>Z27_final, Z28_final=>Z28_final, Z31_final=>Z31_final, Z32_final=>Z32_final, 
	Z33_final=>Z33_final, Z34_final=>Z34_final, Z35_final=>Z35_final, Z36_final=>Z36_final, 
	Z37_final=>Z37_final, Z38_final=>Z38_final, Z41_final=>Z41_final, Z42_final=>Z42_final, 
	Z43_final=>Z43_final, Z44_final=>Z44_final, Z45_final=>Z45_final, Z46_final=>Z46_final, 
	Z47_final=>Z47_final, Z48_final=>Z48_final, Z51_final=>Z51_final, Z52_final=>Z52_final, 
	Z53_final=>Z53_final, Z54_final=>Z54_final, Z55_final=>Z55_final, Z56_final=>Z56_final, 
	Z57_final=>Z57_final, Z58_final=>Z58_final, Z61_final=>Z61_final, Z62_final=>Z62_final, 
	Z63_final=>Z63_final, Z64_final=>Z64_final, Z65_final=>Z65_final, Z66_final=>Z66_final, 
	Z67_final=>Z67_final, Z68_final=>Z68_final, Z71_final=>Z71_final, Z72_final=>Z72_final, 
	Z73_final=>Z73_final, Z74_final=>Z74_final, Z75_final=>Z75_final, Z76_final=>Z76_final, 
	Z77_final=>Z77_final, Z78_final=>Z78_final, Z81_final=>Z81_final, Z82_final=>Z82_final, 
	Z83_final=>Z83_final, Z84_final=>Z84_final, Z85_final=>Z85_final, Z86_final=>Z86_final, 
    Z87_final=>Z87_final, Z88_final=>Z88_final, output_enable=>dct_enable);

    u9 : cr_quantizer port map(clk=>clk,rst=>rst,enable=>dct_enable,
	Z11=>Z11_final, Z12=>Z12_final, Z13=>Z13_final, Z14=>Z14_final, 
	Z15=>Z15_final, Z16=>Z16_final, Z17=>Z17_final, Z18=>Z18_final, 
	Z21=>Z21_final, Z22=>Z22_final, Z23=>Z23_final, Z24=>Z24_final, 
	Z25=>Z25_final, Z26=>Z26_final, Z27=>Z27_final, Z28=>Z28_final,
	Z31=>Z31_final, Z32=>Z32_final, Z33=>Z33_final, Z34=>Z34_final, 
	Z35=>Z35_final, Z36=>Z36_final, Z37=>Z37_final, Z38=>Z38_final, 
	Z41=>Z41_final, Z42=>Z42_final, Z43=>Z43_final, Z44=>Z44_final, 
	Z45=>Z45_final, Z46=>Z46_final, Z47=>Z47_final, Z48=>Z48_final,
	Z51=>Z51_final, Z52=>Z52_final, Z53=>Z53_final, Z54=>Z54_final, 
	Z55=>Z55_final, Z56=>Z56_final, Z57=>Z57_final, Z58=>Z58_final, 
	Z61=>Z61_final, Z62=>Z62_final, Z63=>Z63_final, Z64=>Z64_final, 
	Z65=>Z65_final, Z66=>Z66_final, Z67=>Z67_final, Z68=>Z68_final,
	Z71=>Z71_final, Z72=>Z72_final, Z73=>Z73_final, Z74=>Z74_final, 
	Z75=>Z75_final, Z76=>Z76_final, Z77=>Z77_final, Z78=>Z78_final, 
	Z81=>Z81_final, Z82=>Z82_final, Z83=>Z83_final, Z84=>Z84_final, 
	Z85=>Z85_final, Z86=>Z86_final, Z87=>Z87_final, Z88=>Z88_final,
    
    Q11=>Q11, Q12=>Q12, Q13=>Q13, Q14=>Q14, Q15=>Q15, Q16=>Q16, Q17Q17, Q18=>Q18, 
	Q21=>Q21, Q22=>Q22, Q23=>Q23, Q24=>Q24, Q25=>Q25, Q26=>Q26, Q27Q27, Q28=>Q28,
	Q31=>Q31, Q32=>Q32, Q33=>Q33, Q34=>Q34, Q35=>Q35, Q36=>Q36, Q37Q37, Q38=>Q38, 
	Q41=>Q41, Q42=>Q42, Q43=>Q43, Q44=>Q44, Q45=>Q45, Q46=>Q46, Q47Q47, Q48=>Q48,
	Q51=>Q51, Q52=>Q52, Q53=>Q53, Q54=>Q54, Q55=>Q55, Q56=>Q56, Q57Q57, Q58=>Q58, 
	Q61=>Q61, Q62=>Q62, Q63=>Q63, Q64=>Q64, Q65=>Q65, Q66=>Q66, Q67Q67, Q68=>Q68,
	Q71=>Q71, Q72=>Q72, Q73=>Q73, Q74=>Q74, Q75=>Q75, Q76=>Q76, Q77Q77, Q78=>Q78, 
	Q81=>Q81, Q82=>Q82, Q83=>Q83, Q84=>Q84, Q85=>Q85, Q86=>Q86, Q87Q87, Q88=>Q88,
	out_enable=>quantizer_enable);

    u10 : cr_huff port map(
        clk=>clk, rst=>rst, enable=>quantizer_enable, 
	    Cb11=>Q11, Cb12=>Q21, Cb13=>Q31, Cb14=>Q41, Cb15=>Q51, Cb16=>Q61, Cb17=>Q71, Cb18=>Q81, 
	    Cb21=>Q12, Cb22=>Q22, Cb23=>Q32, Cb24=>Q42, Cb25=>Q52, Cb26=>Q62, Cb27=>Q72, Cb28=>Q82,
	    Cb31=>Q13, Cb32=>Q23, Cb33=>Q33, Cb34=>Q43, Cb35=>Q53, Cb36=>Q63, Cb37=>Q73, Cb38=>Q83, 
	    Cb41=>Q14, Cb42=>Q24, Cb43=>Q34, Cb44=>Q44, Cb45=>Q54, Cb46=>Q64, Cb47=>Q74, Cb48=>Q84,
	    Cb51=>Q15, Cb52=>Q25, Cb53=>Q35, Cb54=>Q45, Cb55=>Q55, Cb56=>Q65, Cb57=>Q75, Cb58=>Q85, 
	    Cb61=>Q16, Cb62=>Q26, Cb63=>Q36, Cb64=>Q46, Cb65=>Q56, Cb66=>Q66, Cb67=>Q76, Cb68=>Q86,
	    Cb71=>Q17, Cb72=>Q27, Cb73=>Q37, Cb74=>Q47, Cb75=>Q57, Cb76=>Q67, Cb77=>Q77, Cb78=>Q87, 
	    Cb81=>Q18, Cb82=>Q28, Cb83=>Q38, Cb84=>Q48, Cb85=>Q58, Cb86=>Q68, Cb87=>Q78, Cb88=>Q88,
	    JPEG_bitstream=>JPEG_bitstream, data_ready=>data_ready, output_reg_count=>cb_orc,
        end_of_block_empty=>end_of_block_empty);
        
    
    

end crd_q_h_arch ; -- cbd_q_h_arch
