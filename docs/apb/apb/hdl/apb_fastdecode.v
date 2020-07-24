//
// APB Decoder
// Splits an APB bus in equal address regions starting at address 0 
// regions are 1,2,4 etc K bytes 
// This code is 100% combinatorial and much smaller and faster then decode
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

module apb_fastdecode
#(parameter PORTS      = 2,  // Output ports
            MS_SLVADR  = 9,  // Sets size of region  
                             // 9=1K, 10=2K etc.
            TOP_DEFAULT = 0  // Highest bus is default (no errors)
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
   output    [MS_SLVADR:0] m_paddr,  
   output                 m_pwrite,
   output     [PORTS-1:0] m_psel,
   output                 m_penable,
   output          [31:0] m_pwdata,
   input   [PORTS*32-1:0] m_prdata,
   input      [PORTS-1:0] m_pready,
   input      [PORTS-1:0] m_pslverr
);

// How many address bits do we need?
localparam SELBITS = PORTS<=2    ? 1 :
                     PORTS<=4    ? 2 :
                     PORTS<=8    ? 3 :
                     PORTS<=16   ? 4 : 
                     PORTS<=32   ? 5 :
                     PORTS<=64   ? 6 :
                     PORTS<=128  ? 7 :
                     0 ; // this should hopefully raise an error in synthesis

 

wire select_error;    
wire [SELBITS-1:0] pre_select_bits,select_bits;

   // A lot of signals pass-through
   assign m_paddr   = s_paddr[MS_SLVADR:0]; 
   assign m_pwrite  = s_pwrite;
   assign m_penable = s_penable;
   assign m_pwdata  = s_pwdata;
   
   // These bits define the port
   assign pre_select_bits = s_paddr[MS_SLVADR+1 +: SELBITS];
   
   // If too big we have an error 
   assign select_error = pre_select_bits>=PORTS;
   
   // The final port bits: the original ones
   // or on error and top-port-is-default, map on top port
   assign select_bits  = TOP_DEFAULT & select_error ? PORTS-1 :  pre_select_bits;
  
   // The sel bit of the right port is set
   // None is set if error and NOT top_is_default
   assign m_psel    = ~TOP_DEFAULT & select_error ? {PORTS{1'b0}} : s_psel<<select_bits;
   assign s_prdata  = m_prdata[select_bits*32 +: 32];
   
   // Return ready from port or ready on error
   assign s_pready  = m_pready[select_bits]  | (~TOP_DEFAULT & select_error);
   assign s_pslverr = m_pslverr[select_bits] | (~TOP_DEFAULT & select_error);

endmodule