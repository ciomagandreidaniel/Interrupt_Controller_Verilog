/*
 * 
 * Vericon version 4.3. Generated Thu Sep 17 09:28:21 2015
 * Auto generated testbench
 *
 */

module apb_fastdecode_test;

localparam CLK_PERIOD=100;

localparam PORTS        =  3; // Output ports
localparam MS_SLVADR    = 10; // MS Address bit of port, 10 = 2K regions 
localparam TOP_DEFAULT  =  1; // All unadressed accesses go to top p_sel bus 


   // APB input (slave)           
wire        [ 31:0] paddr; // ls 2 bits are unused 
wire                pwrite;
wire                psel;
wire                penable;
wire        [ 31:0] pwdata;
wire        [ 31:0] prdata;
wire                pready;
wire                pslverr;
   
   // APB output (master)
   // 2K regions need only 11 address bits
wire [MS_SLVADR:0] m_paddr; // ls 2 bits always 0 
wire             m_pwrite;
wire [PORTS-1:0] m_psel;
wire             m_penable;
wire     [ 31:0] m_pwdata;
reg       [31:0] m_prdata [0:PORTS-1];
reg  [PORTS-1:0] m_pready;
reg  [PORTS-1:0] m_pslverr;

   assign paddr[31:16] = 16'h0; 

integer a,adrs,mask;
time now,later;

   initial
   begin 
         
      m_pready   = {PORTS{1'b1}};
      m_pslverr  = 'b0;
      for (a=0; a<PORTS; a=a+1)
         m_prdata[a] = a; // port X returns data X 
      @(posedge pclk)
         #(CLK_PERIOD*5) ;  
         
      // Ports are multiple mapped 
      mask = ~(3*2048)-1;  
      for (adrs=0; adrs<1024*16; adrs=adrs+1024)
      begin
         apb_bus0.write(adrs,32'h11223344);
         a = (adrs>>11)&3;
         if (TOP_DEFAULT && a==3)
           a=2;
         
         apb_bus0.read(adrs,a); 
         if (a==3 && !pslverr)
         begin
            $display("%m@%0t: Slave error missing",$time);
            #1 $stop;
         end
      end
      // Check top addresses 
      for (adrs=1020; adrs<1024*16; adrs=adrs+1024)
      begin
         apb_bus0.write(adrs,32'h11223344);
         a = (adrs>>11)&3;
         if (TOP_DEFAULT && a==3)
           a=2;
         
         apb_bus0.read(adrs,a); 
         if (a==-1 && !pslverr)
         begin
            $display("%m@%0t: Slave error missing",$time);
            #1 $stop;
         end
      end
      apb_bus0.delay(3);

      // Check ready 
      for (a=0; a<4; a=a+1)
      begin
         // set low for 50 pclk cycles
         m_pready[a] <= 1'b0;
         m_pready[a] <= #(CLK_PERIOD*50) 1'b1;
         now  = $time;
         adrs = a*2048;
         apb_bus0.write(adrs,32'h11223344);
         apb_bus0.delay(3);
         // check how long that took
         // ports 0,1,2 should be slow
         // 3 is an error acecss and should be fast 
         // (unless TOP_DEFAULT is set)
         later = $time;
         if (later-now < CLK_PERIOD*50)
         begin
            if (a<3)
            begin
               $display("%m@%0t: pready %d did not seem to work",$time,a);
               #1 $stop;
            end
         end
      end
            
      if (apb_bus0.errors==0)
         $display("apb_fastdecode test passed");
      else
         $display("apb_fastdecode test failed");
 
      #500 $stop;
      
   end


apb_fastdecode

   #(
      .PORTS    (PORTS)   ,  // Output ports
      .MS_SLVADR (MS_SLVADR),   
      .TOP_DEFAULT  (TOP_DEFAULT)   // All unadressed accesses go to top p_sel bus 

   ) // parameters
apb_fastdecode_0 (
   // APB input (slave)           
      .s_paddr  (paddr),   // ls 2 bits are unused 
      .s_pwrite (pwrite),
      .s_psel   (psel),
      .s_penable(penable),
      .s_pwdata (pwdata),
      .s_prdata (prdata),
      .s_pready (pready),
      .s_pslverr(pslverr),
   
   // APB output (master)
      .m_paddr  (m_paddr),   // ls 2 bits always 0 
      .m_pwrite (m_pwrite),
      .m_psel   (m_psel),
      .m_penable(m_penable),
      .m_pwdata (m_pwdata),
      .m_prdata ( {m_prdata[2],
                   m_prdata[1],
                   m_prdata[0]}                   
                ),
      .m_pready (m_pready),
      .m_pslverr(m_pslverr) 
   );
   
apb_bus 
#(.CLKPER(CLK_PERIOD)
 )
apb_bus0 (
   // APB
      .pclk     (pclk),
      .paddr    (paddr[15:0]),     // ls 2 bits are unused 
      .pwrite   (pwrite),
      .psel     (psel),
      .penable  (penable),
      .pwdata   (pwdata),
      .prdata   (prdata),
      .pready   (pready),
      .pslverr  (pslverr)
      ); 
   

endmodule
