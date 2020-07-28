//-----------------------------------------------------------------------------------------------------
// S.C EASYIC DESIGN S.R.L
// Project     : Interrupt Controller with APB Interface
// Module      : interrupt_controller
// Author      : Ciomag Andrei Daniel(CAD)
// Date        : 26.07.2020
//-----------------------------------------------------------------------------------------------------
// Description : Interrupt Controller with APB Interface is a module that is used to combine 
// several sources of interrupt into one single line, allowing priority levels to the interrupt
// input lines. The controller registers are configured via the AMBA 3 APB Protocol. 
//-----------------------------------------------------------------------------------------------------
// Updates     :
// 26.07.2020    (CAD): Initial
// 28.07.2020    (CAD): Update 3 
//-----------------------------------------------------------------------------------------------------

module interrupt_controller(

//APB Interface
input               pclk_i         ,
input               penable_i      ,
input               psel_i         ,
input               pwrite_i       ,
input      [31:0]   paddr_i        ,
input      [31:0]   pwdata_i       ,
output reg [31:0]   prdata_o       ,
output              pready_o       ,
output              pslverr_o      ,



//system interface             
input               rst_n_i        ,
input               enable_o       ,

//interrupt controller
input      [3:0]    irq_trigger_i  ,
output              interrupt_o
);

//testing
reg reg_interrupt;
wire wire_interrupt;

//apb command signals
wire apb_write = psel_i & penable_i & pwrite_i;
wire apb_read  = psel_i & ~pwrite_i;


//status
//--------------------------------------------------------------
reg [3:0] status; // address 1
//--------------------------------------------------------------

//clear
//--------------------------------------------------------------
reg [3:0] clear ; // address 2
//--------------------------------------------------------------

//mask
//--------------------------------------------------------------
reg [3:0] mask; // address 3
//--------------------------------------------------------------




//--------------------------------------------------------------
// Status Register
//--------------------------------------------------------------

always @(posedge pclk_i or negedge rst_n_i)
begin
 if(~rst_n_i)
  status <= {4{1'b0}};
 else if(enable_o)
 begin
 
  case({clear[0],irq_trigger_i[0]})
  
   2'b01   : status[0] <= 1'b1;
   2'b10   : status[0] <= 1'b0;
   2'b11   : status[0] <= 1'b0;
   default : status[0] <= status[0];
  endcase
  
    case({clear[1],irq_trigger_i[1]})
  
   2'b01   : status[1] <= 1'b1;
   2'b10   : status[1] <= 1'b0;
   2'b11   : status[1] <= 1'b0;
   default : status[1] <= status[1];
  endcase
  
    case({clear[2],irq_trigger_i[2]})
  
   2'b01   : status[2] <= 1'b1;
   2'b10   : status[2] <= 1'b0;
   2'b11   : status[2] <= 1'b0;
   default : status[2] <= status[2];
  endcase
  
    case({clear[3],irq_trigger_i[3]})
  
   2'b01   : status[3] <= 1'b1;
   2'b10   : status[3] <= 1'b0;
   2'b11   : status[3] <= 1'b0;
   default : status[3] <= status[3];
  endcase
  
 end

end


//liviu 

/*
always @(posedge pclk_i or negedge rst_n_i)
begin
 if(~rst_n_i)
  status <= {4{1'b0}};
 else if(enable_o)
 begin
 status <= (clear != 0) ? (status & (~clear)) : (status | irq_trigger_i);

 end
end
*/


//--------------------------------------------------------------



//--------------------------------------------------------------
// Clear Register
//--------------------------------------------------------------

always @(posedge pclk_i or negedge rst_n_i)
begin
 if(~rst_n_i)
  clear <= {4{1'b0}};
 else if (enable_o)
  begin
   if(apb_write & (paddr_i == 'd2))
    begin
	 clear <= pwdata_i[3:0];
	end
   else
     clear <= {4{1'b0}};
  end
end

//--------------------------------------------------------------

//--------------------------------------------------------------
// Mask Register
//--------------------------------------------------------------


always @(posedge pclk_i or negedge rst_n_i)
begin
 if(~rst_n_i) 
  mask <= 1'b0;
 else if(enable_o)
 begin
 if(apb_write & (paddr_i == 'd3))
      mask <= pwdata_i [3:0];
 end
end

//--------------------------------------------------------------

//--------------------------------------------------------------
// prdata_o
//--------------------------------------------------------------

always @(posedge pclk_i or negedge rst_n_i)
begin
 if(~rst_n_i)
  prdata_o <= {32{1'b0}};
 else if (enable_o)
  begin
        if(apb_read & (paddr_i == 'd1))
   prdata_o [4:0] <= status;
   else if(apb_read & (paddr_i == 'd2))
   prdata_o [4:0] <= clear;
   else if(apb_read & (paddr_i == 'd3))
   prdata_o [4:0] <= mask;   
  end
end

//--------------------------------------------------------------

//--------------------------------------------------------------
// interrupt_o
//--------------------------------------------------------------

always @(posedge pclk_i or negedge rst_n_i)
begin
 if(~rst_n_i)
  reg_interrupt <= 1'b0;
 else if (enable_o)
  reg_interrupt      <= |(mask & status);
end

assign wire_interrupt = |(mask & status);

assign interrupt_o =  reg_interrupt &  wire_interrupt;

//--------------------------------------------------------------
 
 assign pready_o  = 1'b1;
 assign pslverr_o = 1'b0;


endmodule //interrupt_controller