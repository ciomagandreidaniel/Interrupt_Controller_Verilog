//
// Sample APB interrupt handling code
// Control 4 incoming interrupt requests
// Each request is a level interrupt 
// Adress offset from psel:
//   0x00 : 4 bit IRQ enable 1 bit per source
//   0x04 : Read : 4 interrupt pending (request and enabled)
//                 4 interrupt requests
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
// Notes:
//    irq_request is assumed to arrive synchronously
//

module apb_levirq (
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
   output            irq,

   // Interface
   input      [ 3:0] irq_request
);

reg  [3:0] irq_control; // enable bit per IRQ input
wire [3:0] irq_pending; // 

wire apb_write = psel & penable & pwrite;
wire apb_read  = psel & ~pwrite;

   assign pready  = 1'b1;
   assign pslverr = 1'b0;
   
   assign irq_pending = irq_request & irq_control;
   assign irq = |irq_pending;
   
   always @(posedge pclk or negedge reset_n)
   begin
      if (!reset_n)
      begin
         irq_control <= 4'h0;
         prdata    <= 32'h0;
      end // reset
      else if (enable)
      begin
         
         if (apb_write)
         begin
            case (paddr)
            3'h0  : irq_control <= pwdata[3:0];
          //3'h4  : status : read only
           endcase
         end // write
         
         if (apb_read)
         begin
            case (paddr)
            3'h0 : prdata <= {28'h0,irq_control};
            3'h4 : prdata <= {24'h0,irq_pending,irq_request};
            endcase
         end // read
         else
            prdata <= 32'h0; // so we can OR all busses
      end // clocked
   end // always 
   
endmodule
