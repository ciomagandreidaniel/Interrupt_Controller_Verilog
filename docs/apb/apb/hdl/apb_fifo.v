//
// Sample APB register code
// Write to and read from synchronous fall-through FIFO
// 256 deep, 8 bits wide 
// Adress offset from psel:
//   0x00 : Write goes into fifo, 
//          Read comes out of fifo
//   0x04 : Read Fifo status signals 
//          Write bit 0 set = clear 
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
// Flaws:
//  The code as-is will fail if used with pready low. 
//

module apb_fifo (
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
   output            ff_write,
   output            ff_read,
   output reg        ff_clear,
   input       [7:0] ff_rdata,
   input             ff_full,
   input             ff_empty,
   input       [8:0] ff_level
  
);

wire apb_write = psel & penable & pwrite;
wire apb_read  = psel & ~pwrite;

   assign pready  = 1'b1;
   assign pslverr = 1'b0; 
   
   // Fifo write pulse must come whilst apb_wdata is present 
   // (Thus not after cycle has finished)
   assign ff_write = psel & penable & pwrite & (paddr==4'h0);

   // Fifo read pulse must come on last cycle 
   // That makes FIFO finishes at the same time as the read cycle
   // and thus the status read on the next APB read is correct
   assign ff_read = psel & penable & ~pwrite & (paddr==4'h0);
   
   always @(posedge pclk or negedge reset_n)
   begin
      if (!reset_n)
      begin
         ff_clear <= 1'b0;
         prdata   <= 32'h0;
      end // reset
      else if (enable)
      begin         
         ff_clear <= 1'b0;
         
         if (apb_write)
         begin
            case (paddr)
            // 4'h0 :  Write to FIFO, not registers
            4'h4 :  ff_clear <= pwdata[0]; 
            endcase
         end // write
         
         if (apb_read)
         begin
            case (paddr)
            4'h0 :  prdata  <= {24'h0,ff_rdata};
            4'h4 :  prdata  <= { 15'h0, ff_level, 6'h0,ff_full,ff_empty};
            endcase
         end // read
         else
            prdata <= 32'h0;
      end // clocked
   end // always 
   
endmodule
