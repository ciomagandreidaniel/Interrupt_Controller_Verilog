//
// Sample APB register code
// Write set and write clear registers
// Adress offset from psel:
//   0x00 : 32 bit read & write set  register
//     If write data bit is 1 : set corresponding register bit
//     If write data bit is 0 : coresponding register bit remain unchanged
//
//   0x04 : 32 bit read & write clear register
//     If write data bit is 1 : clear corresponding register bit
//     If write data bit is 0 : coresponding register bit remain unchanged
//
//
// Freeware September 2015, Fen Logic Ltd.
// This code is free and is delivered 'as is'.
// It comes without any warranty, to the extent permitted by applicable law.
// There are no restrictions to any use or re-use of this code
// in any form or shape. It would be nice if you keep my company name
// in the source or modified source code but even that is not
// required as I can't check it anyway.
// But the code comes with no warranties or guarantees whatsoever.
//
//
//

module apb_wrtsetclr (
   // system
   input             reset_n,
   input             enable,  // clock gating 

   // APB
   input             pclk,            
   input      [ 2:0] paddr,   // ls 2 bits are unused 
   input             pwrite,
   input             psel,
   input             penable,
   input      [31:0] pwdata,
   output reg [31:0] prdata,
   output            pready,
   output            pslverr,

   // Interface
   output reg [31:0] control32
);

wire apb_write = psel & penable & pwrite;
wire apb_read  = psel & ~pwrite;

   assign pready  = 1'b1;
   assign pslverr = 1'b0;
   
   always @(posedge pclk or negedge reset_n)
   begin
      if (!reset_n)
      begin
         control32 <= 32'h0;
         prdata    <= 32'h0;
      end // reset
      else if (enable)
      begin
         
         if (apb_write)
         begin
            case (paddr)
            3'h0 : control32 <= control32 | pwdata;
            3'h4 : control32 <= control32 & ~pwdata;
            endcase
         end // write
         
         if (apb_read)
         begin
            case (paddr)
            3'h0 : prdata <= control32;
            3'h4 : prdata <= control32; 
            endcase
         end // read
         else
            prdata <= 32'h0; // so we can OR all busses
      end // clocked
   end // always 
   
endmodule
