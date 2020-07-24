/*
 * 
 * Vericon version 4.3. Generated Thu Sep 17 09:28:21 2015
 * Auto generated testbench
 *
 */

module apb_decode_test;

localparam CLK_PERIOD=100;

localparam PORTS     = 4; // Output ports
localparam BOTREGION = 1024; // Address lowest port 
localparam REGION    = 3072; // Address locations/port 
localparam TOP_DEFAULT  = 0; // If set top port gets all unmachted accesses
                             // (And testbench gives two error you should ignore....)
                            
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
wire         [31:0] m_paddr; // ls 2 bits always 0 
wire                m_pwrite;
wire [PORTS-1:0] m_psel;
wire                m_penable;
wire        [ 31:0] m_pwdata;
reg       [31:0] m_prdata [0:PORTS-1];
reg  [PORTS-1:0] m_pready;
reg  [PORTS-1:0] m_pslverr;

   assign paddr[31:16] = 16'h0; 

integer a,adrs;
time    now,later;


   initial
   begin 
      
      if (TOP_DEFAULT)
         $display("Testbench gives two errors you should ignore");
         
      m_pready   = {PORTS{1'b1}};
      m_pslverr  = 'b0;
      a = 0;
      for (adrs=BOTREGION; adrs<BOTREGION+PORTS*REGION; adrs=adrs+REGION)
      begin
         m_prdata[a]  = a+1;
         a = a + 1;
      end
      @(posedge pclk)
         #(CLK_PERIOD*5) ;  
         

      for (adrs=0; adrs<1024*16; adrs=adrs+1024)
      begin
         apb_bus0.write(adrs,32'h11223344);
         if (TOP_DEFAULT)
            a = 4;
         else  
            a = 0;
         if (adrs>=1024 && adrs<4096)
            a = 1;
          if (adrs>=4096 && adrs<7168)
            a = 2;
          if (adrs>=7168 && adrs<10240)
            a = 3;
          if (adrs>=10240 && adrs<13312)
            a = 4;
         apb_bus0.read(adrs,a); 
         if (a==0 && !pslverr)
         begin
            $display("%m@%0t: Slave error missing",$time);
            #1 $stop;
         end
      end
      // Check top addresses 
      for (adrs=1020; adrs<1024*16; adrs=adrs+1024)
      begin
         apb_bus0.write(adrs,32'h11223344);
         if (TOP_DEFAULT)
            a = 4;
         else  
            a = 0;
         if (adrs>=1024 && adrs<4096)
            a = 1;
          if (adrs>=4096 && adrs<7168)
            a = 2;
          if (adrs>=7168 && adrs<10240)
            a = 3;
          if (adrs>=10240 && adrs<13312)
            a = 4;
         apb_bus0.read(adrs,a); 
         if (a==0 && !pslverr)
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
         adrs = 1024 + a*3072;
         apb_bus0.write(adrs,32'h11223344);
         apb_bus0.delay(3);
         // check how long that took
         later = $time;
         if (later-now < CLK_PERIOD*50)
         begin
            $display("%m@%0t: pready %d did not seem to work",$time,a);
            #1 $stop;
         end
      end
            
      if (apb_bus0.errors==0 || (TOP_DEFAULT && apb_bus0.errors==2))
         $display("apb_decode test passed");
      else
         $display("apb_decode test failed");
         
      #500 $stop;
      
   end


apb_decode
   #(
      .PORTS     (PORTS)   ,  // Output ports
      .BOTREGION (BOTREGION),  
      .REGION    (REGION),    
      .TOP_DEFAULT  (TOP_DEFAULT)   // All unadressed accesses go to top p_sel bus 
   ) // parameters
apb_decode_0 (
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
      .m_prdata ( {m_prdata[3],
                   m_prdata[2],
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
