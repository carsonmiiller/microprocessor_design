/*
   CS/ECE 552, Spring '22
   Homework #3, Problem #2
  
   This module creates a wrapper around the 8x16b register file, to do
   do the bypassing logic for RF bypassing.
*/
module regFile_bypass (
                       // Outputs
                       read1Data, read2Data, err,
                       // Inputs
                       clk, rst, read1RegSel, read2RegSel, writeRegSel, writeData, writeEn
                       );
   input        clk, rst;
   input [2:0]  read1RegSel;
   input [2:0]  read2RegSel;
   input [2:0]  writeRegSel;
   input [15:0] writeData;
   input        writeEn;

   output [15:0] read1Data;
   output [15:0] read2Data;
   output        err;

   wire [15:0] read1Data_nbp;
   wire [15:0] read2Data_nbp;
   regFile regFile(
      .clk(clk),
      .rst(rst),
      .read1RegSel(read1RegSel),
      .read2RegSel(read2RegSel),
      .writeRegSel(writeRegSel),
      .writeData(writeData),
      .writeEn(writeEn),
      .read1Data(read1Data_nbp),
      .read2Data(read2Data_nbp),
      .err(err)
   );

   // if either read register is same as write register,
   // and write is enabled, pass write data through to
   // read data
   assign read1Data = ((read1RegSel == writeRegSel) & writeEn) ? writeData : read1Data_nbp;
   assign read2Data = ((read2RegSel == writeRegSel) & writeEn) ? writeData : read2Data_nbp;

endmodule
