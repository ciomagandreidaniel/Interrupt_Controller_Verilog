//
// APB Decoder
// splits an APB bus in equal address regions each with a psel 
// TOP_DEFAULT makes that all un mapped accesses end up in highet port
// This code is 100% combinatorial
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
//

module apb_decode
#(parameter PORTS      = 3,     // Output ports
            BOTREGION  = 1024,  // Address first port 
            REGION     = 3072,  // address locations/port             
            TOP_DEFAULT   = 0   // All unadressed accesses go to top p_sel bus 
 )
(
   // APB input (slave)           
   input      [31:0] s_paddr,   // ls 2 bits are unused 
   input             s_pwrite,
   input             s_psel,
   input             s_penable,
   input      [31:0] s_pwdata,
   output     [31:0] s_prdata,
   output            s_pready,
   output            s_pslverr,
   
   // APB output (master)
   output          [31:0] m_paddr,   // ls 2 bits always 0 
   output                 m_pwrite,
   output reg [PORTS-1:0] m_psel,
   output                 m_penable,
   output          [31:0] m_pwdata,
   input   [PORTS*32-1:0] m_prdata,
   input      [PORTS-1:0] m_pready,
   input      [PORTS-1:0] m_pslverr
);

localparam BOT    = BOTREGION,              // inclusive
           TOP    = BOTREGION+REGION*PORTS; // exclusive

// How many address bits do we need?
localparam SELBITS = PORTS<=2    ? 1 :
                     PORTS<=4    ? 2 :
                     PORTS<=8    ? 3 :
                     PORTS<=16   ? 4 : 
                     PORTS<=32   ? 5 :
                     PORTS<=64   ? 6 :
                     0 ; // this should hopefully raise an error in synthesis

wire               select_error;    
reg  [SELBITS-1:0] select_bits;  // Index bits 

   // A lot of signals pass-through
   assign m_paddr   = s_paddr; 
   assign m_pwrite  = s_pwrite;
   assign m_penable = s_penable;
   assign m_pwdata  = s_pwdata;
   
   // Address map split up
   always @( * )
   begin : dec
      integer adrs_loop;
      select_bits = 0; 
      for (adrs_loop=BOT+REGION; adrs_loop<TOP; adrs_loop=adrs_loop+REGION)
      begin
         // #1; // Used only to debug loop 
         if (s_paddr>=adrs_loop)
            select_bits = select_bits + 1;
      end
   end

   assign select_error = !(s_paddr>=BOT && s_paddr<TOP);
   
   always @( * )
   begin
      if (select_error)
      begin
         if (TOP_DEFAULT)
            m_psel = s_psel<<(PORTS-1);
         else
            m_psel = {PORTS{1'b0}};         
      end
      else
         m_psel = s_psel<<select_bits;      
   end
    
   //
   // return signals
   //
   
   // return data 
   assign s_prdata  = m_prdata[select_bits*32 +: 32];
   
   // return error  from port or local error  
   assign s_pslverr = (m_pslverr[select_bits] | (select_error & ~TOP_DEFAULT));
   
   // return ready  from port or on local error  
   assign s_pready  = (m_pready[select_bits] | (select_error & ~TOP_DEFAULT));

/*
   // Alternative is to make all return signals zero if this 
   // module is not selected. That way you can OR all busses
   // together at a higher level
   // But that works only if all modules stick to that rule!!
   
wire for_me = p_sel & p_enable;
   assign s_prdata  = for_me ? m_prdata[select_bits*32 +: 32] : 32'h0;
   assign s_pslverr = for_me & (m_pslverr[select_bits] | (select_error & ~TOP_DEFAULT));
   assign s_pready  = for_me & (m_pready[select_bits] | (select_error & ~TOP_DEFAULT));
*/  


endmodule