//
// Synchronous FIFO
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
// Read and Write are ignored when empty/full
// The fifo level is registered
// The full, empty flags can be registered or not
//
// Known issues:
//    artithmetic is not size compliant (pntr <= pntr + {{(L2D-1){1'b0}},1'b1};)
//    Storage contents is not cleared
//    relying on synthesis tool to remove unused logic
//

module sync_fifo
#(parameter WIDTH    = 8, // width in bits
            L2D      = 4, // Log 2 Depth, 4=16 deep
            REGFLAGS = 1  // Full, empty are registered
)
(
   input                   clk,     // system clock                 
   input                   reset_n, // A-synchronous low reset/clear
   input                   enable,  // clock gating                 
   input                   clear,   // Synchronous clear            
                                                                    
   input                   write,   // write FIFO                   
   input       [WIDTH-1:0] wdata,   // write data                   
   input                   read,    // read FIFO                    
   output      [WIDTH-1:0] rdata,   // read data                    
                                                                    
   output reg              empty,   // FIFO is empty                
   output reg              full,    // FIFO is full                 
   output reg      [L2D:0] level    // Fill level                   
);

localparam DEPTH = (1<<L2D);

reg  [WIDTH-1:0] memory [0:DEPTH-1];
reg    [L2D-1:0] rd_pntr,wt_pntr;
reg              full_r,empty_r;

wire l_read,l_write;

   // prevent disastrous reads & writes
   assign l_read  = read  & !empty;
   assign l_write = write & !full;


   always @(posedge clk or negedge reset_n)
   begin
      if (!reset_n)
      begin
         rd_pntr <= {L2D{1'b0}};
         wt_pntr <= {L2D{1'b0}};
         level   <= {L2D{1'b0}};
         full_r  <= 1'b0;
         empty_r <= 1'b1;
      end
      else if (enable)
      begin
         if (clear)
         begin
           rd_pntr <= {L2D{1'b0}};
           wt_pntr <= {L2D{1'b0}};
           level   <= {L2D{1'b0}};
           full_r  <= 1'b0;
           empty_r <= 1'b1;
         end
         else
         begin
           case ({l_read,l_write})
           2'b01 : // Write, no read
             begin
                wt_pntr <= wt_pntr + 1;
                level   <= level + 1;
                full_r  <= (level==DEPTH-1);
                empty_r <= 1'b0;
             end

           2'b10 : // Read, no write
              begin
                 rd_pntr <= rd_pntr + 1;
                 level   <= level - 1;
                 full_r  <= 1'b0;
                 empty_r <= (level==1);
              end

           2'b11 : // Read & Write
              begin
                wt_pntr <= wt_pntr + 1;
                rd_pntr <= rd_pntr + 1;
              end
           endcase
        end

`ifdef ASSERT_ON
         // Catch fatal operational errors
         if (write && !l_write)
         begin
            $display("%m,@%0t: write to full FIFO",$time);
            #1 $stop;
         end

         if (read && !l_read)
         begin
            $display("%m,@%0t: read from empty FIFO",$time);
            #1 $stop;
         end
`endif

      end
   end

   // Write to fifo
   always @(posedge clk)
   begin
      if (enable & l_write)
         memory[wt_pntr] <= wdata;
   end

   // Read from fifo:
   assign rdata = memory[rd_pntr];

   // empty and full flags depend on parameter
   // registered or not
   always @( * )
   begin
      if (REGFLAGS==0)
      begin
         full  = (level==DEPTH);
         empty = (level==0);
      end
      else
      begin
        full  = full_r;
        empty = empty_r;
      end
   end


endmodule