/*
 * 
 * Vericon version 4.3. Generated Tue Sep 15 10:22:19 2015
 * Auto generated testbench
 *
 */

module apb_pulse_test;

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
wire pulse_write;
wire pulse_writebit;
wire pulse_read;

// testbench
reg fail;
integer i;

   initial
   begin

   // system
      reset_n    = 1'b0;
      enable     = 1'b1;
      fail = 0;
      
      @(posedge pclk)
         #(CLK_PERIOD*5) ; 
      reset_n = 1'b1;
       #(CLK_PERIOD*5) ; 
       
       // write set
       apb_bus0.write(16'h0,32'h0);
       // Write comes in 3 cycles, pulse at 4 
       for (i=0; i<3; i=i+1)
          @(posedge pclk);
       @(posedge pclk)
          if (pulse_write!==1'b1)
             fail = 1;
       @(posedge pclk)
          if (pulse_write!==1'b0)
             fail = 1;
              
       apb_bus0.write(16'h4,32'h1);
       // Write comes in 3 cycles, pulse at 4 
       for (i=0; i<3; i=i+1)
          @(posedge pclk);
       @(posedge pclk)
          if (pulse_writebit!==1'b1)
             fail = 1;
       @(posedge pclk)
          if (pulse_writebit!==1'b0)
             fail = 1;
       
       apb_bus0.write(16'h4,32'h0);
       for (i=0; i<3; i=i+1)
          @(posedge pclk);
       @(posedge pclk)
          if (pulse_writebit!==1'b0)
             fail = 1;
       
        apb_bus0.read(16'h8,32'hx);
       // Read comes in 3 cycles, pulse at 4 
       for (i=0; i<3; i=i+1)
          @(posedge pclk);
       @(posedge pclk)
          if (pulse_read!==1'b1)
             fail = 1;
       @(posedge pclk)
          if (pulse_read!==1'b0)
             fail = 1;
       
       if (fail==0)
          $display("apb_pulse test passed");
       else
          $display("apb_pulse test FAILED!");
		
		 #500 $stop;       
   end


apb_pulse
apb_pulse_0 (

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
      .pulse_write   (pulse_write   ),
      .pulse_writebit(pulse_writebit),
      .pulse_read    (pulse_read    )
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
