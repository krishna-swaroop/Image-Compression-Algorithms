// JPEG Encoder Block
/* Made by D. Krishna Swaroop, 2017A3PS0315P as part of Study oriented Project in 6th Semester
   BITS Pilani. */

/* This module converts the incoming Cr data.
The incoming data is unsigned 8 bits, so the data is in the range of 0-255
Unlike a typical DCT, the data is not subtracted by 128 to center it around 0.
It is only required for the first row, and instead of subtracting 128 from each
pixel value, a total value can be subtracted at the end of the first row/column multiply,
involving the 8 pixel values and the 8 DCT matrix values.
For the other 7 rows of the DCT matrix, the values in each row add up to 0,
so it is not necessary to subtract 128 from each Y, Cb, and Cr pixel value.
Then the Discrete Cosine Transform is performed by multiplying the 8x8 pixel block values
by the 8x8 DCT matrix. */


`timescale 1ns / 100ps

module cr_dct(clk, rst, enable, data_in,
Z11_final, Z12_final, Z13_final, Z14_final, Z15_final, Z16_final, Z17_final, Z18_final,
Z21_final, Z22_final, Z23_final, Z24_final, Z25_final, Z26_final, Z27_final, Z28_final,
Z31_final, Z32_final, Z33_final, Z34_final, Z35_final, Z36_final, Z37_final, Z38_final,
Z41_final, Z42_final, Z43_final, Z44_final, Z45_final, Z46_final, Z47_final, Z48_final,
Z51_final, Z52_final, Z53_final, Z54_final, Z55_final, Z56_final, Z57_final, Z58_final,
Z61_final, Z62_final, Z63_final, Z64_final, Z65_final, Z66_final, Z67_final, Z68_final,
Z71_final, Z72_final, Z73_final, Z74_final, Z75_final, Z76_final, Z77_final, Z78_final,
Z81_final, Z82_final, Z83_final, Z84_final, Z85_final, Z86_final, Z87_final, Z88_final, 
output_enable);
// Defining IO
input		clk; //clock
input		rst; //reset
input		enable;
input	[7:0]	data_in;
output  [10:0]  Z11_final, Z12_final, Z13_final, Z14_final;
output  [10:0]  Z15_final, Z16_final, Z17_final, Z18_final;
output  [10:0]  Z21_final, Z22_final, Z23_final, Z24_final;
output  [10:0]  Z25_final, Z26_final, Z27_final, Z28_final;
output  [10:0]  Z31_final, Z32_final, Z33_final, Z34_final;
output  [10:0]  Z35_final, Z36_final, Z37_final, Z38_final;
output  [10:0]  Z41_final, Z42_final, Z43_final, Z44_final;
output  [10:0]  Z45_final, Z46_final, Z47_final, Z48_final;
output  [10:0]  Z51_final, Z52_final, Z53_final, Z54_final;
output  [10:0]  Z55_final, Z56_final, Z57_final, Z58_final;
output  [10:0]  Z61_final, Z62_final, Z63_final, Z64_final;
output  [10:0]  Z65_final, Z66_final, Z67_final, Z68_final;
output  [10:0]  Z71_final, Z72_final, Z73_final, Z74_final;
output  [10:0]  Z75_final, Z76_final, Z77_final, Z78_final;
output  [10:0]  Z81_final, Z82_final, Z83_final, Z84_final;
output  [10:0]  Z85_final, Z86_final, Z87_final, Z88_final;
output	output_enable;


integer T1, T21, T22, T23, T24, T25, T26, T27, T28, T31, T32, T33, T34, T52; 
integer Ti1, Ti21, Ti22, Ti23, Ti24, Ti25, Ti26, Ti27, Ti28, Ti31, Ti32, Ti33, Ti34, Ti52; 

reg [24:0] Cr_temp_11;
reg [24:0] Cr11, Cr21, Cr31, Cr41, Cr51, Cr61, Cr71, Cr81, Cr11_final;
reg [31:0] Cr_temp_21, Cr_temp_31, Cr_temp_41, Cr_temp_51;
reg [31:0] Cr_temp_61, Cr_temp_71, Cr_temp_81;
reg [31:0] Z_temp_11, Z_temp_12, Z_temp_13, Z_temp_14;
reg [31:0] Z_temp_15, Z_temp_16, Z_temp_17, Z_temp_18;
reg [31:0] Z_temp_21, Z_temp_22, Z_temp_23, Z_temp_24;
reg [31:0] Z_temp_25, Z_temp_26, Z_temp_27, Z_temp_28;
reg [31:0] Z_temp_31, Z_temp_32, Z_temp_33, Z_temp_34;
reg [31:0] Z_temp_35, Z_temp_36, Z_temp_37, Z_temp_38;
reg [31:0] Z_temp_41, Z_temp_42, Z_temp_43, Z_temp_44;
reg [31:0] Z_temp_45, Z_temp_46, Z_temp_47, Z_temp_48;
reg [31:0] Z_temp_51, Z_temp_52, Z_temp_53, Z_temp_54;
reg [31:0] Z_temp_55, Z_temp_56, Z_temp_57, Z_temp_58;
reg [31:0] Z_temp_61, Z_temp_62, Z_temp_63, Z_temp_64;
reg [31:0] Z_temp_65, Z_temp_66, Z_temp_67, Z_temp_68;
reg [31:0] Z_temp_71, Z_temp_72, Z_temp_73, Z_temp_74;
reg [31:0] Z_temp_75, Z_temp_76, Z_temp_77, Z_temp_78;
reg [31:0] Z_temp_81, Z_temp_82, Z_temp_83, Z_temp_84;
reg [31:0] Z_temp_85, Z_temp_86, Z_temp_87, Z_temp_88;
reg [24:0] Z11, Z12, Z13, Z14, Z15, Z16, Z17, Z18;
reg [24:0] Z21, Z22, Z23, Z24, Z25, Z26, Z27, Z28;
reg [24:0] Z31, Z32, Z33, Z34, Z35, Z36, Z37, Z38;
reg [24:0] Z41, Z42, Z43, Z44, Z45, Z46, Z47, Z48;
reg [24:0] Z51, Z52, Z53, Z54, Z55, Z56, Z57, Z58;
reg [24:0] Z61, Z62, Z63, Z64, Z65, Z66, Z67, Z68;
reg [24:0] Z71, Z72, Z73, Z74, Z75, Z76, Z77, Z78;
reg [24:0] Z81, Z82, Z83, Z84, Z85, Z86, Z87, Z88;
reg [31:0]  Cr11_final_2, Cr21_final_2, Cr11_final_3, Cr11_final_4, Cr31_final_2, Cr41_final_2;
reg [31:0]  Cr51_final_2, Cr61_final_2, Cr71_final_2, Cr81_final_2;
reg [10:0]  Cr11_final_1, Cr21_final_1, Cr31_final_1, Cr41_final_1;
reg [10:0]  Cr51_final_1, Cr61_final_1, Cr71_final_1, Cr81_final_1;
reg [24:0] Cr21_final, Cr31_final, Cr41_final, Cr51_final;
reg [24:0] Cr61_final, Cr71_final, Cr81_final;
reg [24:0] Cr21_final_prev, Cr21_final_diff;
reg [24:0] Cr31_final_prev, Cr31_final_diff;
reg [24:0] Cr41_final_prev, Cr41_final_diff;
reg [24:0] Cr51_final_prev, Cr51_final_diff;
reg [24:0] Cr61_final_prev, Cr61_final_diff;
reg [24:0] Cr71_final_prev, Cr71_final_diff;
reg [24:0] Cr81_final_prev, Cr81_final_diff;
reg [10:0] Z11_final, Z12_final, Z13_final, Z14_final;
reg [10:0] Z15_final, Z16_final, Z17_final, Z18_final;
reg [10:0] Z21_final, Z22_final, Z23_final, Z24_final;
reg [10:0] Z25_final, Z26_final, Z27_final, Z28_final;
reg [10:0] Z31_final, Z32_final, Z33_final, Z34_final;
reg [10:0] Z35_final, Z36_final, Z37_final, Z38_final;
reg [10:0] Z41_final, Z42_final, Z43_final, Z44_final;
reg [10:0] Z45_final, Z46_final, Z47_final, Z48_final;
reg [10:0] Z51_final, Z52_final, Z53_final, Z54_final;
reg [10:0] Z55_final, Z56_final, Z57_final, Z58_final;
reg [10:0] Z61_final, Z62_final, Z63_final, Z64_final;
reg [10:0] Z65_final, Z66_final, Z67_final, Z68_final;
reg [10:0] Z71_final, Z72_final, Z73_final, Z74_final;
reg [10:0] Z75_final, Z76_final, Z77_final, Z78_final;
reg [10:0] Z81_final, Z82_final, Z83_final, Z84_final;
reg [10:0] Z85_final, Z86_final, Z87_final, Z88_final;
reg [2:0] count;
reg	[2:0] count_of, count_of_copy;
reg	count_1, count_3, count_4, count_5, count_6, count_7, count_8, enable_1, output_enable;
reg count_9, count_10;
reg [7:0] data_1;
integer Cr2_mul_input, Cr3_mul_input, Cr4_mul_input, Cr5_mul_input;
integer Cr6_mul_input, Cr7_mul_input, Cr8_mul_input;	
integer Ti2_mul_input, Ti3_mul_input, Ti4_mul_input, Ti5_mul_input;
integer Ti6_mul_input, Ti7_mul_input, Ti8_mul_input;

// DCT matrix entries
always @(posedge clk)		
begin 
	T1 = 5793; // .3536
	T21 = 8035; // .4904
	T22 = 6811; // .4157
	T23 = 4551; // .2778
	T24 = 1598; // .0975
	T25 = -1598; // -.0975
	T26 = -4551; // -.2778
	T27 = -6811; // -.4157
	T28 = -8035; // -.4904
	T31 = 7568; // .4619
	T32 = 3135; // .1913
	T33 = -3135; // -.1913
	T34 = -7568; // -.4619
	T52 = -5793; // -.3536
end 

// The inverse DCT matrix entries  
always @(posedge clk)		
begin 
	Ti1 = 5793; // .3536
	Ti21 = 8035; // .4904
	Ti22 = 6811; // .4157
	Ti23 = 4551; // .2778
	Ti24 = 1598; // .0975
	Ti25 = -1598; // -.0975
	Ti26 = -4551; // -.2778
	Ti27 = -6811; // -.4157
	Ti28 = -8035; // -.4904
	Ti31 = 7568; // .4619
	Ti32 = 3135; // .1913
	Ti33 = -3135; // -.1913
	Ti34 = -7568; // -.4619
	Ti52 = -5793; // -.3536
end 

always @(posedge clk)
begin
	if (rst) begin
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
		end
	else if (enable_1 & count_8) begin
		Z_temp_11 <= Cr11_final_4 * Ti1; Z_temp_12 <= Cr11_final_4 * Ti2_mul_input;
		Z_temp_13 <= Cr11_final_4 * Ti3_mul_input; Z_temp_14 <= Cr11_final_4 * Ti4_mul_input;
		Z_temp_15 <= Cr11_final_4 * Ti5_mul_input; Z_temp_16 <= Cr11_final_4 * Ti6_mul_input;
		Z_temp_17 <= Cr11_final_4 * Ti7_mul_input; Z_temp_18 <= Cr11_final_4 * Ti8_mul_input;
		Z_temp_21 <= Cr21_final_2 * Ti1; Z_temp_22 <= Cr21_final_2 * Ti2_mul_input;
		Z_temp_23 <= Cr21_final_2 * Ti3_mul_input; Z_temp_24 <= Cr21_final_2 * Ti4_mul_input;
		Z_temp_25 <= Cr21_final_2 * Ti5_mul_input; Z_temp_26 <= Cr21_final_2 * Ti6_mul_input;
		Z_temp_27 <= Cr21_final_2 * Ti7_mul_input; Z_temp_28 <= Cr21_final_2 * Ti8_mul_input;
		Z_temp_31 <= Cr31_final_2 * Ti1; Z_temp_32 <= Cr31_final_2 * Ti2_mul_input;
		Z_temp_33 <= Cr31_final_2 * Ti3_mul_input; Z_temp_34 <= Cr31_final_2 * Ti4_mul_input;
		Z_temp_35 <= Cr31_final_2 * Ti5_mul_input; Z_temp_36 <= Cr31_final_2 * Ti6_mul_input;
		Z_temp_37 <= Cr31_final_2 * Ti7_mul_input; Z_temp_38 <= Cr31_final_2 * Ti8_mul_input;
		Z_temp_41 <= Cr41_final_2 * Ti1; Z_temp_42 <= Cr41_final_2 * Ti2_mul_input;
		Z_temp_43 <= Cr41_final_2 * Ti3_mul_input; Z_temp_44 <= Cr41_final_2 * Ti4_mul_input;
		Z_temp_45 <= Cr41_final_2 * Ti5_mul_input; Z_temp_46 <= Cr41_final_2 * Ti6_mul_input;
		Z_temp_47 <= Cr41_final_2 * Ti7_mul_input; Z_temp_48 <= Cr41_final_2 * Ti8_mul_input;
		Z_temp_51 <= Cr51_final_2 * Ti1; Z_temp_52 <= Cr51_final_2 * Ti2_mul_input;
		Z_temp_53 <= Cr51_final_2 * Ti3_mul_input; Z_temp_54 <= Cr51_final_2 * Ti4_mul_input;
		Z_temp_55 <= Cr51_final_2 * Ti5_mul_input; Z_temp_56 <= Cr51_final_2 * Ti6_mul_input;
		Z_temp_57 <= Cr51_final_2 * Ti7_mul_input; Z_temp_58 <= Cr51_final_2 * Ti8_mul_input;
		Z_temp_61 <= Cr61_final_2 * Ti1; Z_temp_62 <= Cr61_final_2 * Ti2_mul_input;
		Z_temp_63 <= Cr61_final_2 * Ti3_mul_input; Z_temp_64 <= Cr61_final_2 * Ti4_mul_input;
		Z_temp_65 <= Cr61_final_2 * Ti5_mul_input; Z_temp_66 <= Cr61_final_2 * Ti6_mul_input;
		Z_temp_67 <= Cr61_final_2 * Ti7_mul_input; Z_temp_68 <= Cr61_final_2 * Ti8_mul_input;
		Z_temp_71 <= Cr71_final_2 * Ti1; Z_temp_72 <= Cr71_final_2 * Ti2_mul_input;
		Z_temp_73 <= Cr71_final_2 * Ti3_mul_input; Z_temp_74 <= Cr71_final_2 * Ti4_mul_input;
		Z_temp_75 <= Cr71_final_2 * Ti5_mul_input; Z_temp_76 <= Cr71_final_2 * Ti6_mul_input;
		Z_temp_77 <= Cr71_final_2 * Ti7_mul_input; Z_temp_78 <= Cr71_final_2 * Ti8_mul_input;
		Z_temp_81 <= Cr81_final_2 * Ti1; Z_temp_82 <= Cr81_final_2 * Ti2_mul_input;
		Z_temp_83 <= Cr81_final_2 * Ti3_mul_input; Z_temp_84 <= Cr81_final_2 * Ti4_mul_input;
		Z_temp_85 <= Cr81_final_2 * Ti5_mul_input; Z_temp_86 <= Cr81_final_2 * Ti6_mul_input;
		Z_temp_87 <= Cr81_final_2 * Ti7_mul_input; Z_temp_88 <= Cr81_final_2 * Ti8_mul_input;
		end
end

always @(posedge clk)
begin
	if (rst) begin
		Z11 <= 0; Z12 <= 0; Z13 <= 0; Z14 <= 0; Z15 <= 0; Z16 <= 0; Z17 <= 0; Z18 <= 0;
		Z21 <= 0; Z22 <= 0; Z23 <= 0; Z24 <= 0; Z25 <= 0; Z26 <= 0; Z27 <= 0; Z28 <= 0;
		Z31 <= 0; Z32 <= 0; Z33 <= 0; Z34 <= 0; Z35 <= 0; Z36 <= 0; Z37 <= 0; Z38 <= 0;
		Z41 <= 0; Z42 <= 0; Z43 <= 0; Z44 <= 0; Z45 <= 0; Z46 <= 0; Z47 <= 0; Z48 <= 0;
		Z51 <= 0; Z52 <= 0; Z53 <= 0; Z54 <= 0; Z55 <= 0; Z56 <= 0; Z57 <= 0; Z58 <= 0;
		Z61 <= 0; Z62 <= 0; Z63 <= 0; Z64 <= 0; Z65 <= 0; Z66 <= 0; Z67 <= 0; Z68 <= 0;
		Z71 <= 0; Z72 <= 0; Z73 <= 0; Z74 <= 0; Z75 <= 0; Z76 <= 0; Z77 <= 0; Z78 <= 0;
		Z81 <= 0; Z82 <= 0; Z83 <= 0; Z84 <= 0; Z85 <= 0; Z86 <= 0; Z87 <= 0; Z88 <= 0;
		end
	else if (count_8 & count_of == 1) begin
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
		end
	else if (enable & count_9) begin
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
		Z85 <= Z_temp_85 + Z85; Z86 <= Z_temp_86 + Z86; Z87 <= Z_temp_87 + Z87; Z88 <= Z_temp_88 + Z88;
		end	
end

always @(posedge clk)
begin
	if (rst) begin
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
		end
	else if (count_10 & count_of == 0) begin
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
		end
end

// output_enable signals the next block, the quantizer, that the input data is ready
always @(posedge clk)
begin
	if (rst) 
 		output_enable <= 0;
	else if (!enable_1)
		output_enable <= 0;
	else if (count_10 == 0 | count_of)
		output_enable <= 0;
	else if (count_10 & count_of == 0)
		output_enable <= 1;
end
always @(posedge clk)
begin
	if (rst)
		Cr_temp_11 <= 0;
	else if (enable)
		Cr_temp_11 <= data_in * T1; 
end  

always @(posedge clk)
begin
	if (rst)
		Cr11 <= 0;
	else if (count == 1 & enable == 1)
		Cr11 <= Cr_temp_11;
	else if (enable)
		Cr11 <= Cr_temp_11 + Cr11;
end

always @(posedge clk)
begin
	if (rst) begin
		Cr_temp_21 <= 0;
		Cr_temp_31 <= 0;
		Cr_temp_41 <= 0;
		Cr_temp_51 <= 0;
		Cr_temp_61 <= 0;
		Cr_temp_71 <= 0;
		Cr_temp_81 <= 0;
		end
	else if (!enable_1) begin
		Cr_temp_21 <= 0;
		Cr_temp_31 <= 0;
		Cr_temp_41 <= 0;
		Cr_temp_51 <= 0;
		Cr_temp_61 <= 0;
		Cr_temp_71 <= 0;
		Cr_temp_81 <= 0;
		end
	else if (enable_1) begin
		Cr_temp_21 <= data_1 * Cr2_mul_input; 
		Cr_temp_31 <= data_1 * Cr3_mul_input; 
		Cr_temp_41 <= data_1 * Cr4_mul_input; 
		Cr_temp_51 <= data_1 * Cr5_mul_input; 
		Cr_temp_61 <= data_1 * Cr6_mul_input; 
		Cr_temp_71 <= data_1 * Cr7_mul_input; 
		Cr_temp_81 <= data_1 * Cr8_mul_input; 
		end
end

always @(posedge clk)
begin
	if (rst) begin
		Cr21 <= 0;
		Cr31 <= 0;
		Cr41 <= 0;
		Cr51 <= 0;
		Cr61 <= 0;
		Cr71 <= 0;
		Cr81 <= 0;
		end
	else if (!enable_1) begin
		Cr21 <= 0;
		Cr31 <= 0;
		Cr41 <= 0;
		Cr51 <= 0;
		Cr61 <= 0;
		Cr71 <= 0;
		Cr81 <= 0;
		end
	else if (enable_1) begin
		Cr21 <= Cr_temp_21 + Cr21;
		Cr31 <= Cr_temp_31 + Cr31;
		Cr41 <= Cr_temp_41 + Cr41;
		Cr51 <= Cr_temp_51 + Cr51;
		Cr61 <= Cr_temp_61 + Cr61;
		Cr71 <= Cr_temp_71 + Cr71;
		Cr81 <= Cr_temp_81 + Cr81;
		end
end 

always @(posedge clk)
begin
	if (rst) begin
 		count <= 0; count_3 <= 0; count_4 <= 0; count_5 <= 0;
 		count_6 <= 0; count_7 <= 0; count_8 <= 0; count_9 <= 0;
 		count_10 <= 0;
		end
	else if (!enable) begin
		count <= 0; count_3 <= 0; count_4 <= 0; count_5 <= 0;
 		count_6 <= 0; count_7 <= 0; count_8 <= 0; count_9 <= 0;
 		count_10 <= 0;
		end
	else if (enable) begin
		count <= count + 1; count_3 <= count_1; count_4 <= count_3;
		count_5 <= count_4; count_6 <= count_5; count_7 <= count_6;
		count_8 <= count_7; count_9 <= count_8; count_10 <= count_9;
		end
end

always @(posedge clk)
begin
	if (rst) begin
		count_1 <= 0;
		end
	else if (count != 7 | !enable) begin
		count_1 <= 0;
		end
	else if (count == 7) begin
		count_1 <= 1;
		end
end

always @(posedge clk)
begin
	if (rst) begin
 		count_of <= 0;
 		count_of_copy <= 0;
 		end
	else if (!enable) begin
		count_of <= 0;
		count_of_copy <= 0;
		end
	else if (count_1 == 1) begin
		count_of <= count_of + 1;
		count_of_copy <= count_of_copy + 1;
		end
end

always @(posedge clk)
begin
	if (rst) begin
 		Cr11_final <= 0;
		end
	else if (count_3 & enable_1) begin
		Cr11_final <= Cr11 - 25'd5932032;  
		/* The Cr values weren't centered on 0 before doing the DCT	
		 128 needs to be subtracted from each Cb value before, or in this
		 case, 362 is subtracted from the total, because this is the 
		 total obtained by subtracting 128 from each element 
		 and then multiplying by the weight
		 assigned by the DCT matrix : 128*8*5793 = 5932032
		 This is only needed for the first row, the values in the rest of
		 the rows add up to 0 */
		end
end


always @(posedge clk)
begin
	if (rst) begin
 		Cr21_final <= 0; Cr21_final_prev <= 0;
 		Cr31_final <= 0; Cr31_final_prev <= 0;
 		Cr41_final <= 0; Cr41_final_prev <= 0;
 		Cr51_final <= 0; Cr51_final_prev <= 0;
 		Cr61_final <= 0; Cr61_final_prev <= 0;
 		Cr71_final <= 0; Cr71_final_prev <= 0;
 		Cr81_final <= 0; Cr81_final_prev <= 0;
		end
	else if (!enable_1) begin
		Cr21_final <= 0; Cr21_final_prev <= 0;
 		Cr31_final <= 0; Cr31_final_prev <= 0;
 		Cr41_final <= 0; Cr41_final_prev <= 0;
 		Cr51_final <= 0; Cr51_final_prev <= 0;
 		Cr61_final <= 0; Cr61_final_prev <= 0;
 		Cr71_final <= 0; Cr71_final_prev <= 0;
 		Cr81_final <= 0; Cr81_final_prev <= 0;
		end
	else if (count_4 & enable_1) begin
		Cr21_final <= Cr21; Cr21_final_prev <= Cr21_final;
		Cr31_final <= Cr31; Cr31_final_prev <= Cr31_final;
		Cr41_final <= Cr41; Cr41_final_prev <= Cr41_final;
		Cr51_final <= Cr51; Cr51_final_prev <= Cr51_final;
		Cr61_final <= Cr61; Cr61_final_prev <= Cr61_final;
		Cr71_final <= Cr71; Cr71_final_prev <= Cr71_final;
		Cr81_final <= Cr81; Cr81_final_prev <= Cr81_final;
		end
end

always @(posedge clk)
begin
	if (rst) begin
 		Cr21_final_diff <= 0; Cr31_final_diff <= 0;
 		Cr41_final_diff <= 0; Cr51_final_diff <= 0;
 		Cr61_final_diff <= 0; Cr71_final_diff <= 0;
 		Cr81_final_diff <= 0;	
		end
	else if (count_5 & enable_1) begin 
		Cr21_final_diff <= Cr21_final - Cr21_final_prev;	
		Cr31_final_diff <= Cr31_final - Cr31_final_prev;	
		Cr41_final_diff <= Cr41_final - Cr41_final_prev;	
		Cr51_final_diff <= Cr51_final - Cr51_final_prev;	
		Cr61_final_diff <= Cr61_final - Cr61_final_prev;	
		Cr71_final_diff <= Cr71_final - Cr71_final_prev;	
		Cr81_final_diff <= Cr81_final - Cr81_final_prev;		
		end
end

always @(posedge clk)
begin
	case (count)
	3'b000:		Cr2_mul_input <= T21;
	3'b001:		Cr2_mul_input <= T22;
	3'b010:		Cr2_mul_input <= T23;
	3'b011:		Cr2_mul_input <= T24;
	3'b100:		Cr2_mul_input <= T25;
	3'b101:		Cr2_mul_input <= T26;
	3'b110:		Cr2_mul_input <= T27;
	3'b111:		Cr2_mul_input <= T28;
	endcase
end

always @(posedge clk)
begin
	case (count)
	3'b000:		Cr3_mul_input <= T31;
	3'b001:		Cr3_mul_input <= T32;
	3'b010:		Cr3_mul_input <= T33;
	3'b011:		Cr3_mul_input <= T34;
	3'b100:		Cr3_mul_input <= T34;
	3'b101:		Cr3_mul_input <= T33;
	3'b110:		Cr3_mul_input <= T32;
	3'b111:		Cr3_mul_input <= T31;
	endcase
end

always @(posedge clk)
begin
	case (count)
	3'b000:		Cr4_mul_input <= T22;
	3'b001:		Cr4_mul_input <= T25;
	3'b010:		Cr4_mul_input <= T28;
	3'b011:		Cr4_mul_input <= T26;
	3'b100:		Cr4_mul_input <= T23;
	3'b101:		Cr4_mul_input <= T21;
	3'b110:		Cr4_mul_input <= T24;
	3'b111:		Cr4_mul_input <= T27;
	endcase
end

always @(posedge clk)
begin
	case (count)
	3'b000:		Cr5_mul_input <= T1;
	3'b001:		Cr5_mul_input <= T52;
	3'b010:		Cr5_mul_input <= T52;
	3'b011:		Cr5_mul_input <= T1;
	3'b100:		Cr5_mul_input <= T1;
	3'b101:		Cr5_mul_input <= T52;
	3'b110:		Cr5_mul_input <= T52;
	3'b111:		Cr5_mul_input <= T1;
	endcase
end

always @(posedge clk)
begin
	case (count)
	3'b000:		Cr6_mul_input <= T23;
	3'b001:		Cr6_mul_input <= T28;
	3'b010:		Cr6_mul_input <= T24;
	3'b011:		Cr6_mul_input <= T22;
	3'b100:		Cr6_mul_input <= T27;
	3'b101:		Cr6_mul_input <= T25;
	3'b110:		Cr6_mul_input <= T21;
	3'b111:		Cr6_mul_input <= T26;
	endcase
end

always @(posedge clk)
begin
	case (count)
	3'b000:		Cr7_mul_input <= T32;
	3'b001:		Cr7_mul_input <= T34;
	3'b010:		Cr7_mul_input <= T31;
	3'b011:		Cr7_mul_input <= T33;
	3'b100:		Cr7_mul_input <= T33;
	3'b101:		Cr7_mul_input <= T31;
	3'b110:		Cr7_mul_input <= T34;
	3'b111:		Cr7_mul_input <= T32;
	endcase
end

always @(posedge clk)
begin
	case (count)
	3'b000:		Cr8_mul_input <= T24;
	3'b001:		Cr8_mul_input <= T26;
	3'b010:		Cr8_mul_input <= T22;
	3'b011:		Cr8_mul_input <= T28;
	3'b100:		Cr8_mul_input <= T21;
	3'b101:		Cr8_mul_input <= T27;
	3'b110:		Cr8_mul_input <= T23;
	3'b111:		Cr8_mul_input <= T25;
	endcase
end

// Inverse DCT matrix entries
always @(posedge clk)
begin
	case (count_of_copy)
	3'b000:		Ti2_mul_input <= Ti28;
	3'b001:		Ti2_mul_input <= Ti21;
	3'b010:		Ti2_mul_input <= Ti22;
	3'b011:		Ti2_mul_input <= Ti23;
	3'b100:		Ti2_mul_input <= Ti24;
	3'b101:		Ti2_mul_input <= Ti25;
	3'b110:		Ti2_mul_input <= Ti26;
	3'b111:		Ti2_mul_input <= Ti27;
	endcase
end

always @(posedge clk)
begin
	case (count_of_copy)
	3'b000:		Ti3_mul_input <= Ti31;
	3'b001:		Ti3_mul_input <= Ti31;
	3'b010:		Ti3_mul_input <= Ti32;
	3'b011:		Ti3_mul_input <= Ti33;
	3'b100:		Ti3_mul_input <= Ti34;
	3'b101:		Ti3_mul_input <= Ti34;
	3'b110:		Ti3_mul_input <= Ti33;
	3'b111:		Ti3_mul_input <= Ti32;
	endcase
end

always @(posedge clk)
begin
	case (count_of_copy)
	3'b000:		Ti4_mul_input <= Ti27;
	3'b001:		Ti4_mul_input <= Ti22;
	3'b010:		Ti4_mul_input <= Ti25;
	3'b011:		Ti4_mul_input <= Ti28;
	3'b100:		Ti4_mul_input <= Ti26;
	3'b101:		Ti4_mul_input <= Ti23;
	3'b110:		Ti4_mul_input <= Ti21;
	3'b111:		Ti4_mul_input <= Ti24;
	endcase
end

always @(posedge clk)
begin
	case (count_of_copy)
	3'b000:		Ti5_mul_input <= Ti1;
	3'b001:		Ti5_mul_input <= Ti1;
	3'b010:		Ti5_mul_input <= Ti52;
	3'b011:		Ti5_mul_input <= Ti52;
	3'b100:		Ti5_mul_input <= Ti1;
	3'b101:		Ti5_mul_input <= Ti1;
	3'b110:		Ti5_mul_input <= Ti52;
	3'b111:		Ti5_mul_input <= Ti52;
	endcase
end

always @(posedge clk)
begin
	case (count_of_copy)
	3'b000:		Ti6_mul_input <= Ti26;
	3'b001:		Ti6_mul_input <= Ti23;
	3'b010:		Ti6_mul_input <= Ti28;
	3'b011:		Ti6_mul_input <= Ti24;
	3'b100:		Ti6_mul_input <= Ti22;
	3'b101:		Ti6_mul_input <= Ti27;
	3'b110:		Ti6_mul_input <= Ti25;
	3'b111:		Ti6_mul_input <= Ti21;
	endcase
end

always @(posedge clk)
begin
	case (count_of_copy)
	3'b000:		Ti7_mul_input <= Ti32;
	3'b001:		Ti7_mul_input <= Ti32;
	3'b010:		Ti7_mul_input <= Ti34;
	3'b011:		Ti7_mul_input <= Ti31;
	3'b100:		Ti7_mul_input <= Ti33;
	3'b101:		Ti7_mul_input <= Ti33;
	3'b110:		Ti7_mul_input <= Ti31;
	3'b111:		Ti7_mul_input <= Ti34;
	endcase
end

always @(posedge clk)
begin
	case (count_of_copy)
	3'b000:		Ti8_mul_input <= Ti25;
	3'b001:		Ti8_mul_input <= Ti24;
	3'b010:		Ti8_mul_input <= Ti26;
	3'b011:		Ti8_mul_input <= Ti22;
	3'b100:		Ti8_mul_input <= Ti28;
	3'b101:		Ti8_mul_input <= Ti21;
	3'b110:		Ti8_mul_input <= Ti27;
	3'b111:		Ti8_mul_input <= Ti23;
	endcase
end

// Rounding stage
always @(posedge clk)
begin
	if (rst) begin
 		data_1 <= 0;
 		Cr11_final_1 <= 0; Cr21_final_1 <= 0; Cr31_final_1 <= 0; Cr41_final_1 <= 0;
		Cr51_final_1 <= 0; Cr61_final_1 <= 0; Cr71_final_1 <= 0; Cr81_final_1 <= 0;
		Cr11_final_2 <= 0; Cr21_final_2 <= 0; Cr31_final_2 <= 0; Cr41_final_2 <= 0;
		Cr51_final_2 <= 0; Cr61_final_2 <= 0; Cr71_final_2 <= 0; Cr81_final_2 <= 0;
		Cr11_final_3 <= 0; Cr11_final_4 <= 0;
		end
	else if (enable) begin
		data_1 <= data_in;  
		Cr11_final_1 <= Cr11_final[13] ? Cr11_final[24:14] + 1 : Cr11_final[24:14];
		Cr11_final_2[31:11] <= Cr11_final_1[10] ? 21'b111111111111111111111 : 21'b000000000000000000000;
		Cr11_final_2[10:0] <= Cr11_final_1;
		// Need to sign extend Cb11_final_1 and the other registers to store a negative 
		// number as a twos complement number.  If you don't sign extend, then a negative number
		// will be stored incorrectly as a positive number.  For example, -215 would be stored
		// as 1833 without sign extending
		Cr11_final_3 <= Cr11_final_2;
		Cr11_final_4 <= Cr11_final_3;
		Cr21_final_1 <= Cr21_final_diff[13] ? Cr21_final_diff[24:14] + 1 : Cr21_final_diff[24:14];
		Cr21_final_2[31:11] <= Cr21_final_1[10] ? 21'b111111111111111111111 : 21'b000000000000000000000;
		Cr21_final_2[10:0] <= Cr21_final_1;
		Cr31_final_1 <= Cr31_final_diff[13] ? Cr31_final_diff[24:14] + 1 : Cr31_final_diff[24:14];
		Cr31_final_2[31:11] <= Cr31_final_1[10] ? 21'b111111111111111111111 : 21'b000000000000000000000;
		Cr31_final_2[10:0] <= Cr31_final_1;
		Cr41_final_1 <= Cr41_final_diff[13] ? Cr41_final_diff[24:14] + 1 : Cr41_final_diff[24:14];
		Cr41_final_2[31:11] <= Cr41_final_1[10] ? 21'b111111111111111111111 : 21'b000000000000000000000;
		Cr41_final_2[10:0] <= Cr41_final_1;
		Cr51_final_1 <= Cr51_final_diff[13] ? Cr51_final_diff[24:14] + 1 : Cr51_final_diff[24:14];
		Cr51_final_2[31:11] <= Cr51_final_1[10] ? 21'b111111111111111111111 : 21'b000000000000000000000;
		Cr51_final_2[10:0] <= Cr51_final_1;
		Cr61_final_1 <= Cr61_final_diff[13] ? Cr61_final_diff[24:14] + 1 : Cr61_final_diff[24:14];
		Cr61_final_2[31:11] <= Cr61_final_1[10] ? 21'b111111111111111111111 : 21'b000000000000000000000;
		Cr61_final_2[10:0] <= Cr61_final_1;
		Cr71_final_1 <= Cr71_final_diff[13] ? Cr71_final_diff[24:14] + 1 : Cr71_final_diff[24:14];
		Cr71_final_2[31:11] <= Cr71_final_1[10] ? 21'b111111111111111111111 : 21'b000000000000000000000;
		Cr71_final_2[10:0] <= Cr71_final_1;
		Cr81_final_1 <= Cr81_final_diff[13] ? Cr81_final_diff[24:14] + 1 : Cr81_final_diff[24:14];
		Cr81_final_2[31:11] <= Cr81_final_1[10] ? 21'b111111111111111111111 : 21'b000000000000000000000;
		Cr81_final_2[10:0] <= Cr81_final_1;
		// The bit in place 13 is the fraction part, for rounding purposes
		// if it is 1, then you need to add 1 to the bits in 22-14, 
		// if bit 13 is 0, then the bits in 22-14 won't change
		end
end

always @(posedge clk)
begin
	if (rst) begin
 		enable_1 <= 0; 
		end
	else begin
		enable_1 <= enable;
		end
end

endmodule
