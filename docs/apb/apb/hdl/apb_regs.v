//
// Sample APB register code
// Standard read/write registers
// Adress offset from psel:
//   0x00 : 32 bit read of status32 port
//   0x04 : 16 bit read of status16 port
//   0x08 :  8 bit read of status8  port
//   0x0C : unused memory location
//   0x10 : 32 bit read & write control32 port
//   0x14 : 16 bit read & write control16 port
//   0x18 :  8 bit read & write control8  port
//   0x1C : Read internal constant
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

module apb_regs (
   // system
   input             reset_n,
   input             enable,  // clock gating 

   // APB
   input             pclk,            
   input      [ 4:0] paddr,   // ls 2 bits are unused 
   input             pwrite,
   input             psel,
   input             penable,
   input      [31:0] pwdata,
   output reg [31:0] prdata,
   output            pready,
   output            pslverr,

   // Interface
   input      [31:0] status32,
   input      [15:0] status16,
   input      [ 7:0] status8,
   output reg [31:0] control32,
   output reg [15:0] control16,
   output reg [ 7:0] control8
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
         control16 <= 16'h1234; // reset/initial value 
         control8  <=  8'h0;
         prdata    <= 32'h0;
      end // reset
      else if (enable)
      begin
         
         if (apb_write)
         begin
            case (paddr)
          //5'h00 :  status32 read only 
          //5'h04 :  status16 read only 
          //5'h08 :  status8  read only 
          //5'h0C :  Unused (gap)
            5'h10 : control32 <= pwdata;
            5'h14 : control16 <= pwdata[15:0];
            5'h18 : control8  <= pwdata[7:0];
          //5'h1C :  Identify  read only 
            endcase
         end // write
         
         if (apb_read)
         begin
            case (paddr)
            5'h00 : prdata <= status32;
            5'h04 : prdata <= {16'h0,status16};
            5'h08 : prdata <= {24'h0,status8};
          //5'h0C : unused (GAP)
            5'h10 : prdata <= control32; 
            5'h14 : prdata <= {16'h0,control16};
            5'h18 : prdata <= {24'h0,control8};
            5'h1C : prdata <= 32'h00216948; // "Hi!"
            endcase
         end // read
         else
            prdata <= 32'h0; // so we can OR all busses
      end // clocked
   end // always 
   
endmodule
