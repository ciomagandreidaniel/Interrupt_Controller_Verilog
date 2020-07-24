//
// Sample APB register code
// Standard read/write registers
// Adress offset from psel:
//   0x00 : 32 bit read of status32 port
//   0x04 : 32 bit read & write control32 port
//   0x08 : 16 bit status
//          and 16 bit read & write control16 port 
//   0x0C : 8 bit status8
//          and 8 bit read & write control8 port 
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

module apb_regs1 (
   // system
   input             reset_n,
   input             enable,  // clock gating 

   // APB
   input             pclk,            
   input      [ 3:0] paddr,   // ls 2 bits are unused 
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
          //4'h0 :  status32 read only 
            4'h4 : control32 <= pwdata;
            4'h8 : control16 <= pwdata[15:0];
            4'hC : control8  <= pwdata[7:0];
            endcase
         end // write
         
         if (apb_read)
         begin
            case (paddr)
            4'h0 : prdata <= status32;
            4'h4 : prdata <= control32; 
            4'h8 : prdata <= {status16,control16};
            4'hC : prdata <= {8'h0,status8,8'h0,control8};
            endcase
         end // read
         else
            prdata <= 32'h0; // so we can OR all busses
      end // clocked
   end // always 
   
endmodule
