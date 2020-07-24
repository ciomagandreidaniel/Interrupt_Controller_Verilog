//
// Sample APB interrupt handling code
// Control 4 incoming interrupt requests
// Each request is a level interrupt 
// Adress offset from psel:
//   0x00 : 4 bit IRQ enable 1 bit per source
//   0x04 : Read : 4 interrupt pending (edge seen and enabled)
//                 4 interrupt edge seen status
//          Write: clear active
// clear bits and active bits occupy the same bit positions
// which is easier for the software.
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
//    irq_posedge is assumed to arrive synchronously
//

module apb_edgeirq (
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
   input      [ 3:0] irq_posedge
);

reg  [3:0] edge_detect;  // Needed to detect rising edge
reg  [3:0] irq_control;  // enable bit per IRQ input
reg  [3:0] irq_edgeseen; // Set if rising edge was seen 
wire [3:0] irq_pending;  // IRQs currently active (set & enabled)

wire apb_write = psel & penable & pwrite;
wire apb_read  = psel & ~pwrite;

   assign pready  = 1'b1;
   assign pslverr = 1'b0;
   
   assign irq_pending = irq_edgeseen & irq_control;
   assign irq = |irq_pending;
   
   always @(posedge pclk or negedge reset_n)
   begin : rr
      integer b;
      if (!reset_n)
      begin
         edge_detect  <= 4'h0;
         irq_edgeseen <= 4'h0;
         irq_control  <= 4'h0;
         prdata    <= 32'h0;
      end // reset
      else if (enable)
      begin
         
         edge_detect <= irq_posedge;
         
         for (b=0; b<4; b=b+1)
         begin
            // on an arrving rising edge always set detected
            if (~edge_detect[b] & irq_posedge[b])
               irq_edgeseen[b] <= 1'b1;
            else
            begin
               // If user wrises status register, clear when write bit is set 
               if (apb_write && (paddr==3'h4) && pwdata[b])
                  irq_edgeseen[b] <= 1'b0;
            end
         end
         
         if (apb_write)
         begin
            case (paddr)
            3'h0  : irq_control <= pwdata[3:0];
          // 3'h4  : Done above 
           endcase
         end // write
         
         // irq_posedge can be one pulse so is not worth reading back
         // return irq_edgeseen status instead
         if (apb_read)
         begin
            case (paddr)
            3'h0 : prdata <= {28'h0,irq_control};
            3'h4 : prdata <= {24'h0,irq_pending,irq_edgeseen};
            endcase
         end // read
         else
            prdata <= 32'h0; // so we can OR all busses
      end // clocked
   end // always 
   
endmodule
