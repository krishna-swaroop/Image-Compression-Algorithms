// JPEG Encoder Block
/* Made by D. Krishna Swaroop, 2017A3PS0315P as part of Study oriented Project in 6th Semester
   BITS Pilani. */

`timescale 1ns / 100ps

module sync_fifo_32 (clk, rst, read_req, write_data, write_enable, 
read_data, fifo_empty, rdata_valid);
//defining IO
input	clk;
input	rst;
input	read_req;
input [31:0] write_data;
input write_enable;
output [31:0] read_data;     
output  fifo_empty;          // important signal as reading empty fifo is not preferable
output	rdata_valid;        //bitstream validator
   
reg [4:0] read_ptr;
reg [4:0] write_ptr;
reg [31:0] mem [0:15];
reg [31:0] read_data;
reg rdata_valid;
wire [3:0] write_addr = write_ptr[3:0];
wire [3:0] read_addr = read_ptr[3:0];	
wire read_enable = read_req && (~fifo_empty);
assign fifo_empty = (read_ptr == write_ptr);


always @(posedge clk)
  begin
   if (rst)
      write_ptr <= {(5){1'b0}};
   else if (write_enable)
      write_ptr <= write_ptr + {{4{1'b0}},1'b1};
  end

always @(posedge clk)
begin
   if (rst)
      rdata_valid <= 1'b0;
   else if (read_enable)
      rdata_valid <= 1'b1;
   else
   	  rdata_valid <= 1'b0;  
end
  
always @(posedge clk)
 begin
   if (rst)
      read_ptr <= {(5){1'b0}};
   else if (read_enable)
      read_ptr <= read_ptr + {{4{1'b0}},1'b1};
end

// Mem write
always @(posedge clk)
  begin
   if (write_enable)
     mem[write_addr] <= write_data;
  end
// Mem Read
always @(posedge clk)
  begin
   if (read_enable)
      read_data <= mem[read_addr];
  end
  
endmodule
