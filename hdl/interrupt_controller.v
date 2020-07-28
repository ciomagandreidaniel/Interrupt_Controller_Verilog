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
reg status_0;
reg status_1;
reg status_2;
reg status_3;

wire [3:0] status; // address 1
//--------------------------------------------------------------

//clear
//--------------------------------------------------------------
reg [3:0] clear ; // address 2
//--------------------------------------------------------------

//mask
//--------------------------------------------------------------
reg mask_0;
reg mask_1;
reg mask_2;
reg mask_3;

wire [3:0] mask; // address 3
//--------------------------------------------------------------




//--------------------------------------------------------------
// Status Register
//--------------------------------------------------------------

//status_0 
always @(posedge pclk_i or negedge rst_n_i)
begin
 if(~rst_n_i) 
  begin
   status_0      <= 1'b0;
  end
  else if(enable_o)
  begin
   if(clear[0])
    begin
     status_0 <= 1'b0;
    end	
    else if(irq_trigger_i[0])
    begin
     status_0 <= 1'b1;
    end
   end   
end

//status_1 
always @(posedge pclk_i or negedge rst_n_i)
begin
 if(~rst_n_i) 
  begin
   status_1      <= 1'b0;
  end
  else if(enable_o)
  begin
   if(clear[1])
    begin
     status_1 <= 1'b0;
    end	
    else if(irq_trigger_i[1])
    begin
     status_1 <= 1'b1;
    end
   end   
end

//status_2 
always @(posedge pclk_i or negedge rst_n_i)
begin
 if(~rst_n_i) 
  begin
   status_2      <= 1'b0;
  end
  else if(enable_o)
  begin
   if(clear[2])
    begin
     status_2 <= 1'b0;
    end	
    else if(irq_trigger_i[2])
    begin
     status_2 <= 1'b1;
    end
   end   
end

//status_3 
always @(posedge pclk_i or negedge rst_n_i)
begin
 if(~rst_n_i) 
  begin
   status_3      <= 1'b0;
  end
  else if(enable_o)
  begin
   if(clear[3])
    begin
     status_3 <= 1'b0;
    end	
    else if(irq_trigger_i[3])
    begin
     status_3 <= 1'b1;
    end
   end   
end

assign status = {status_3,status_2,status_1,status_0};

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

//mask_0
always @(posedge pclk_i or negedge rst_n_i)
begin
 if(~rst_n_i) 
  mask_0 <= 1'b0;
 else if(enable_o)
 begin
 if(apb_write & (paddr_i == 'd3))
      mask_0 <= pwdata_i [0];
 end
end

//mask_1
always @(posedge pclk_i or negedge rst_n_i)
begin
 if(~rst_n_i) 
  mask_1 <= 1'b0;
 else if(enable_o)
 begin
 if(apb_write & (paddr_i == 'd3))
      mask_1 <= pwdata_i [1];
 end
end

//mask_2
always @(posedge pclk_i or negedge rst_n_i)
begin
 if(~rst_n_i) 
  mask_2 <= 1'b0;
 else if(enable_o)
 begin
 if(apb_write & (paddr_i == 'd3))
      mask_2 <= pwdata_i [2];
 end
end

//mask_3
always @(posedge pclk_i or negedge rst_n_i)
begin
 if(~rst_n_i) 
  mask_3 <= 1'b0;
 else if(enable_o)
 begin
 if(apb_write & (paddr_i == 'd3))
      mask_3 <= pwdata_i [3];
 end
end

assign mask = {mask_3,mask_2,mask_1,mask_0}; 

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
   else if((apb_read & (paddr_i == 'd2))
   prdata_o [4:0] <= clear;
   else if((apb_read & (paddr_i == 'd3))
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