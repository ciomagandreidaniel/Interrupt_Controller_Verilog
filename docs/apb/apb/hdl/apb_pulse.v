//
// Sample APB register code
// Generate a 1 cycle high pulse
// Adress offset from psel:
//   0x00 : Generate pulse on write to address
//   0x04 : Generate pulse on write bit 0 set
//   0x08 : Generate pulse on read from address
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

module apb_pulse (
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
   output     [31:0] prdata,
   output            pready,
   output            pslverr,

   // Interface
   output reg       pulse_write,
   output reg       pulse_writebit,
   output reg       pulse_read
  
);

wire apb_write = psel & penable & pwrite;
wire apb_read  = psel & ~pwrite;

   assign pready  = 1'b1;
   assign pslverr = 1'b0;
   assign prdata  = 32'h0; // no actual data read implemented
   
   always @(posedge pclk or negedge reset_n)
   begin
      if (!reset_n)
      begin
         pulse_write    <= 1'b0;
         pulse_writebit <= 1'b0;
         pulse_read     <= 1'b0;
      end // reset
      else if (enable)
      begin
         
         pulse_write    <= 1'b0;
         pulse_writebit <= 1'b0;
         pulse_read     <= 1'b0;
          
         if (apb_write)
         begin
            case (paddr)
            4'h00 :  pulse_write <= 1'b1; 
            4'h04 :  pulse_writebit <= pwdata[0]; 
            endcase
         end // write
         
         if (apb_read)
         begin
            // Beware: apb_read id high for TWO cycles
            // Thus can't use it in the same way as apb_write
            case (paddr)
          //4'h00 :  pulse_write <= 1'b1; 
          //4'h04 :  pulse_writebit <= pwdata[0]; 
            4'h08 : pulse_read <= penable;
            endcase
         end // read
      end // clocked
   end // always 
   
endmodule
