/* Made by D. Krishna Swaroop, 2017A3PS0315P as part of Study oriented Project in 6th Semester
   BITS Pilani. */

// This is the top level module
`timescale 1ns / 100ps

module jpeg_top(clk, rst, end_of_file_signal, enable, data_in, JPEG_bitstream, 
data_ready, end_of_file_bitstream_count, eof_data_partial_ready);
//Defining IO
input		clk;
input		rst;
input		end_of_file_signal;
input		enable;
input	[23:0]	data_in;
output  [31:0]  JPEG_bitstream;
output		data_ready;
output	[4:0] end_of_file_bitstream_count;
output		eof_data_partial_ready;

wire [31:0] JPEG_FF;
wire data_ready_FF;
wire [4:0] orc_reg_in;
 

 fifo_out u19 (.clk(clk), .rst(rst), .enable(enable), .data_in(data_in), 
 .JPEG_bitstream(JPEG_FF), .data_ready(data_ready_FF), .orc_reg(orc_reg_in));
 
 ff_checker u20 (.clk(clk), .rst(rst), 
 .end_of_file_signal(end_of_file_signal), .JPEG_in(JPEG_FF), 
 .data_ready_in(data_ready_FF), .orc_reg_in(orc_reg_in),
 .JPEG_bitstream_1(JPEG_bitstream), 
 .data_ready_1(data_ready), .orc_reg(end_of_file_bitstream_count),
 .eof_data_partial_ready(eof_data_partial_ready));

endmodule
