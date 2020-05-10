# JPEG Encoder

This folder contains a hardware implementation of a JPEG Encoder developed as part of a Study Oriented Project in my 6th semester.

The top-level module takes in a 24-bit input of the image to be compressed and gives out a JPEG bitstream. The 24-bit sequence has pixel
data over 3 channels 8 bits each.

The RGB data is first converted to YCbCr format. This data is separately passed through DCT, quantization and huffman encoding modules
consecutively. yd_q_h, Cbd_q_h, Crd_q_h modules are upper level abstractions of these processes. The data is then passed through multiple
FIFOs to manipulate the data in accordance with the JPEG format.

The testbench code stimulates the entire circuit with a sample picture by putting pixel data bit by bit. A short MATLAB script
had to be prepared to convert the .tif file to a bitmap format and copy the pixel values.

The SOP_Report file is a semester report for the Study Oriented Project. This contains detailed explainations of each module
