/*
 * 
 * Vericon version 4.3. Generated Tue Sep 15 10:22:19 2015
 * Auto generated testbench
 *
 */

module apb_regs_test;

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
reg  [ 31:0] status32;
reg  [ 15:0] status16;
reg  [  7:0] status8;
wire [ 31:0] control32;
wire [ 15:0] control16;
wire [  7:0] control8;


   initial
   begin

   // system
      reset_n    = 1'b0;
      enable     = 1'b1;

   // Interface
      status32   = 32'h9c4e9a31;
      status16   = 16'h7832;
      status8    = 16'h2a;
      
      @(posedge pclk)
         #(CLK_PERIOD*5) ; 
      reset_n = 1'b1;
       #(CLK_PERIOD*5) ; 
       apb_bus0.read(16'h00,32'h9c4e9a31);
       apb_bus0.read(16'h04,32'h7832);
       apb_bus0.read(16'h08,32'h2a);
       apb_bus0.read(16'h14,32'h1234); // reset value 
       
       apb_bus0.write(16'h10,32'h11223344);
       apb_bus0.write(16'h14,32'hAABB);
       apb_bus0.write(16'h18,32'hDD);
       apb_bus0.read(16'h10,32'h11223344);
       apb_bus0.read(16'h14,32'hxxxxAABB);
       apb_bus0.read(16'h18,32'hxxxxxxDD);
       apb_bus0.read(16'h1C,32'h00216948); // Expect "Hi!" (Reverse endian)
       apb_bus0.delay(3);
       if (apb_bus0.errors==0)
          $display("apb_regs test passed");
       else
          $display("apb_regs test FAILED!");
		 #500 $stop;       
   end


apb_regs
apb_regs_0 (

   // system
      .reset_n  (reset_n),
      .enable   (enable),    // clock gating 

   // APB
      .pclk     (pclk),
      .paddr    (paddr[4:0]),     // ls 2 bits are unused 
      .pwrite   (pwrite),
      .psel     (psel),
      .penable  (penable),
      .pwdata   (pwdata),
      .prdata   (prdata),
      .pready   (pready),
      .pslverr  (pslverr),

   // Interface
      .status32 (status32),
      .status16 (status16),
      .status8  (status8),
      .control32(control32),
      .control16(control16),
      .control8 (control8) 
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
