/*
 * 
 * Vericon version 4.3. Generated Tue Sep 15 15:32:42 2015
 * Auto generated testbench
 *
 */

module apb_fifo_test;

`define DATA_REG 16'h0
`define STAT_REG 16'h4
`define SR_EMPTY 32'h00000001
`define SR_FULL  32'h00000002


localparam CLK_PERIOD=100;

   // system
reg          reset_n;
reg          enable; // clock gating 

   // APB
wire         pclk;
wire [ 15:0] paddr; // ls 2 bits are unused 
wire         pwrite;
wire         psel;
wire         penable;
wire [ 31:0] pwdata;
wire [ 31:0] prdata;
wire         pready;
wire         pslverr;

   // Interface
wire         ff_write;
wire         ff_read;
wire         ff_clear;
wire [  7:0] ff_rdata;
wire         ff_full;
wire         ff_empty;
wire [  8:0] ff_level;

// testbench
integer i;

   initial
   begin

   // system
      reset_n    = 1'b0;
      enable     = 1'b1;
      
      @(posedge pclk)
         #(CLK_PERIOD*5) ; 
      reset_n = 1'b1;
       #(CLK_PERIOD*5) ; 
       
      // After reset check status reg is correct: only empty bit set
      apb_bus0.read(`STAT_REG,`SR_EMPTY);            
      apb_bus0.write(`DATA_REG,32'h00000044); // write byte 
      apb_bus0.read(`STAT_REG, 32'h00000100); // level = 1, not empty, Not full
      apb_bus0.read(`DATA_REG, 32'h00000044);  // read byte        
      apb_bus0.read(`STAT_REG,`SR_EMPTY);  
      #(CLK_PERIOD*25) ; 
      // Check filling up
      for (i=0; i<255; i=i+1)
      begin
         apb_bus0.write(`DATA_REG,i); // write byte 
         apb_bus0.read(`STAT_REG, (i+1)<<8); // level, not empty, Not full
      end
      apb_bus0.write(`DATA_REG,0); // write byte 
      apb_bus0.read(`STAT_REG,(256<<8)|`SR_FULL); // level=256, Full
      
      // Check if clear works 
      apb_bus0.write(`STAT_REG,0); // should fail
      apb_bus0.read(`STAT_REG,(256<<8)|`SR_FULL); // level=256, Full
      apb_bus0.write(`STAT_REG,0); // should work 
      apb_bus0.read(`STAT_REG,`SR_EMPTY); // level=256, Full
                
      if (apb_bus0.errors==0)
         $display("apb_fifo test passed");
      else
         $display("apb_fifo test FAILED!");
      
      #500 $stop;       
   end


apb_fifo
apb_fifo_0 (

   // system
      .reset_n  (reset_n),
      .enable   (enable),    // clock gating 

   // APB
      .pclk     (pclk),
      .paddr    (paddr[3:0]), // ls 2 bits are unused 
      .pwrite   (pwrite),
      .psel     (psel),
      .penable  (penable),
      .pwdata   (pwdata),
      .prdata   (prdata),
      .pready   (pready),
      .pslverr  (pslverr),

   // Interface
      .ff_write(ff_write),
      .ff_read (ff_read),
      .ff_clear(ff_clear),
      .ff_rdata(ff_rdata),
      .ff_full (ff_full),
      .ff_empty(ff_empty),
      .ff_level(ff_level) 
   );



sync_fifo
   #(
      .WI      (8) ,
      .L2D     (8),
      .REGFLAGS(0)
   ) // parameters
sync_fifo_256x8 (
      .clk     (pclk),
      .reset_n (reset_n),
      .enable  (enable),
      .clear   (ff_clear),

      .wdata  (pwdata[7:0]), // APB bus direct to FIFO
      .write  (ff_write),
      
      .rdata  (ff_rdata),
      .read   (ff_read),

      .full   (ff_full),
      .empty  (ff_empty),
      .level  (ff_level)
   );

   
apb_bus 
#(.CLKPER(CLK_PERIOD)
 )
apb_bus0 (
   // APB
      .pclk     (pclk),
      .paddr    (paddr),     // ls 2 bits are unused 
      .pwrite   (pwrite),
      .psel     (psel),
      .penable  (penable),
      .pwdata   (pwdata),
      .prdata   (prdata),
      .pready   (pready),
      .pslverr  (pslverr)
      ); 
   


endmodule
