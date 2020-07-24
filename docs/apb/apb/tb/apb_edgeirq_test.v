/*
 * 
 * Vericon version 4.3. Generated Tue Sep 15 10:22:19 2015
 * Auto generated testbench
 *
 */

module apb_edgeirq_test;

`define ENBL_REG 16'h0
`define STAT_REG 16'h4

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

wire         irq;

   // Interface
reg  [ 3:0] irq_posedge;


integer i;

   initial
   begin

   // system
      reset_n    = 1'b0;
      enable     = 1'b1;

   // Interface
      irq_posedge   = 4'h0;
      
      @(posedge pclk)
         #(CLK_PERIOD*5) ; 
      reset_n = 1'b1;
      #(CLK_PERIOD*5) ; 
      
      // Check each input individually
      for (i=0; i<4; i=i+1)
      begin
         // Must be clear
         apb_bus0.read(`STAT_REG,32'h00);
         apb_bus0.delay(1); 
         if (irq!==0)
         begin
            $display("%m@%0t: IRQ high (A) error",$time);
            #1 $stop;
         end            
         // Pulse irq high 
         @(posedge pclk)  irq_posedge = 1<<i;
         @(posedge pclk)  irq_posedge = 0;
         // Edge detect needs cycle
         @(posedge pclk); 
         // Status must be set 
         apb_bus0.read(`STAT_REG,1<<i);
         // But IRQ must still be low 
         if (irq!==1'b0)
         begin
            $display("%m@%0t: IRQ high (B) error",$time);
            #1 $stop;
         end            
         // enable IRQ 
         apb_bus0.write(`ENBL_REG,1<<i);
         apb_bus0.delay(2);  // wait for write to complete 
         // IRQ must now be high 
         if (irq!==1'b1)
         begin
            $display("%m@%0t: IRQ low (A) error",$time);
            #1 $stop;
         end            
         // Pending bit and irq bit must be set 
         apb_bus0.read(`STAT_REG,32'h11<<i);
         apb_bus0.delay(2);  // wait for read to complete 
         // Clear by writing clear bit
         apb_bus0.write(`STAT_REG,1<<i);
         apb_bus0.delay(2);  // wait for write to complete 
         // Check IRQ must again be low 
         if (irq!==1'b0)
         begin
            $display("%m@%0t: IRQ high (C) error",$time);
            #1 $stop;
         end            
         // Status reg. must be clear
         apb_bus0.read(`STAT_REG,32'h00);
         // Back to initial state
         apb_bus0.write(`ENBL_REG,0);
      end
      
      // Quick check for all patterns
      apb_bus0.write(`ENBL_REG,32'hF);
      for (i=0; i<16; i=i+1)
      begin
         // Pulse interrupts high
         @(posedge pclk)  irq_posedge = i;
         @(posedge pclk)  irq_posedge = 0;
         // Edge detect needs cycle
          @(posedge pclk); 
         apb_bus0.read(`STAT_REG,{24'h0,i[3:0],i[3:0]});
         apb_bus0.write(`STAT_REG,i); // clear again 
         apb_bus0.delay(2);  
      end
         
      apb_bus0.delay(3);
      if (apb_bus0.errors==0)
         $display("apb_edgeirq test passed");
      else
         $display("apb_edgeirq test FAILED!");
		#500 $stop;       
   end


apb_edgeirq
apb_edgeirq_0 (
   // system
      .reset_n  (reset_n),
      .enable   (enable),    // clock gating 

   // APB
      .pclk     (pclk),
      .paddr    (paddr[2:0]),     // ls 2 bits are unused 
      .pwrite   (pwrite),
      .psel     (psel),
      .penable  (penable),
      .pwdata   (pwdata),
      .prdata   (prdata),
      .pready   (pready),
      .pslverr  (pslverr),
      
      .irq      (irq),

   // Interface
      .irq_posedge (irq_posedge)
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
