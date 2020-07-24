/*
 * 
 * Vericon version 4.3. Generated Tue Sep 15 10:22:19 2015
 * Auto generated testbench
 *
 */

module apb_wrtsetclr_test;

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
wire [ 31:0] control32;


reg flag;

   initial
   begin

   // system
      reset_n    = 1'b0;
      enable     = 1'b1;
      flag       = 1'b0;
      
      @(posedge pclk)
         #(CLK_PERIOD*5) ; 
      reset_n = 1'b1;
       #(CLK_PERIOD*5) ; 
       
       // write set
       apb_bus0.write(16'h0,32'hAAAA5555);
       apb_bus0.read(16'h0,32'hAAAA5555);
       apb_bus0.read(16'h4,32'hAAAA5555);

       // write Set some more
       apb_bus0.write(16'h0,32'h55550000);
       apb_bus0.read(16'h0,32'hFFFF5555);
       apb_bus0.read(16'h4,32'hFFFF5555);
       
       // write clear 
       apb_bus0.write(16'h4,32'h00005500);
       apb_bus0.read(16'h0,32'hFFFF0055);
       apb_bus0.read(16'h4,32'hFFFF0055);
       apb_bus0.delay(3);
       if (apb_bus0.errors==0)
          $display("apb_wrtsetclr test passed");
       else
          $display("apb_wrtsetclr test FAILED!");
		
		 #500 $stop;       
   end


apb_wrtsetclr
apb_wrtsetclr_0 (

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

   // Interface
      .control32(control32)
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
