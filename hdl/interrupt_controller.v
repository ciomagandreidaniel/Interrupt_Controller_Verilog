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
// Wave forms example
//                  __    __    __    __    __    __    __    __
//        pclk_o___|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  
//                        _____
//  irq_wires[0]_________|     |_______________________________
//                              ________________
//     status[0]_______________|                |______________
//                 ____________________________________________
//       mask[0]__|                                            
//                                   ___________
//   interrupt_o____________________|           |______________
//                                         _____
//      clear[0]__________________________|     |______________
//-----------------------------------------------------------------------------------------------------
// Updates     :
// 26.07.2020    (CAD): Initial
// 28.07.2020    (CAD): Update 1
// 02.08.2020    (CAD): Update 2 
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

//for interrupt_o signal to set 0 after clear pulse
reg reg_interrupt;
wire wire_interrupt;

//apb command signals
wire apb_write = psel_i & penable_i & pwrite_i;
wire apb_read  = psel_i & ~pwrite_i;


//status register
//--------------------------------------------------------------
reg [3:0] status; // address 0x01
//--------------------------------------------------------------

//clear register
//--------------------------------------------------------------
reg [3:0] clear ; // address 0x02
//--------------------------------------------------------------

//mask register
//--------------------------------------------------------------
reg [3:0] mask; // address 0x03
//--------------------------------------------------------------


//priority threshold register
//--------------------------------------------------------------
reg [2:0] priority_threshold; // address 0x04
//--------------------------------------------------------------




//interrupt request priority registers
//--------------------------------------------------------------
reg [2:0] irq0_reg;// address 0x05
reg [2:0] irq1_reg;// address 0x06                                        
reg [2:0] irq2_reg;// address 0x07
reg [2:0] irq3_reg;// address 0x08
//--------------------------------------------------------------

//interrupt request wires 
//--------------------------------------------------------------
wire [3:0]  irq_wires;//interrupt requests that have a set 
                      //priority below the priority threshold
//-------------------------------------------------------------- 

//--------------------------------------------------------------
// Priority Threshold Register
//--------------------------------------------------------------

always @(posedge pclk_i or negedge rst_n_i)
begin
 if (~rst_n_i) priority_threshold <= 3'b100; else
 if (enable_o) begin if (apb_write & (paddr_i == 'h4))
               priority_threshold <= pwdata_i[2:0];
               end 
end

//--------------------------------------------------------------


//--------------------------------------------------------------
// Interrupt Request wires
//--------------------------------------------------------------

assign irq_wires[0] = irq_trigger_i[0] & (irq0_reg <= priority_threshold);
assign irq_wires[1] = irq_trigger_i[1] & (irq1_reg <= priority_threshold);
assign irq_wires[2] = irq_trigger_i[2] & (irq2_reg <= priority_threshold);
assign irq_wires[3] = irq_trigger_i[3] & (irq3_reg <= priority_threshold);

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
 status <= (clear != 0) ? (status & (~clear)) : (status | irq_wires);

 end
end



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
   if(apb_write & (paddr_i == 'h2))
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
 if(apb_write & (paddr_i == 'h3))
      mask <= pwdata_i [3:0];
 end
end

//--------------------------------------------------------------

//--------------------------------------------------------------
// Interrupt Request Priority Registers
//--------------------------------------------------------------

//irq0_reg
always @(posedge pclk_i or negedge rst_n_i)
begin
if(~rst_n_i) 
 irq0_reg <= 3'b001;
else if(enable_o)
 begin
  if(apb_write & (paddr_i == 'h5))
   irq0_reg <= pwdata_i[2:0];
 end
end

//irq1_reg
always @(posedge pclk_i or negedge rst_n_i)
begin
if(~rst_n_i) 
 irq1_reg <= 3'b001;
else if(enable_o)
 begin
  if(apb_write & (paddr_i == 'h6))
   irq1_reg <= pwdata_i[2:0];
 end
end

//irq2_reg
always @(posedge pclk_i or negedge rst_n_i)
begin
if(~rst_n_i) 
 irq2_reg <= 3'b001;
else if(enable_o)
 begin
  if(apb_write & (paddr_i == 'h7))
   irq2_reg <= pwdata_i[2:0];
 end
end

//irq3_reg
always @(posedge pclk_i or negedge rst_n_i)
begin
if(~rst_n_i) 
 irq3_reg <= 3'b001;
else if(enable_o)
 begin
  if(apb_write & (paddr_i == 'h8))
   irq3_reg <= pwdata_i[2:0];
 end
end

//--------------------------------------------------------------

//--------------------------------------------------------------
// prdata_o (read function)
//--------------------------------------------------------------

always @(posedge pclk_i or negedge rst_n_i)
begin
 if(~rst_n_i)
  prdata_o <= {32{1'b0}};
 else if (enable_o)
  begin
        if(apb_read & (paddr_i == 'h1))
          prdata_o [3:0] <= status;             //read status register
   else if(apb_read & (paddr_i == 'h2))
          prdata_o [3:0] <= clear;              //read clear register
   else if(apb_read & (paddr_i == 'h3))
          prdata_o [3:0] <= mask;               //read mask register
   else if(apb_read & (paddr_i == 'h4))
          prdata_o [2:0] <= priority_threshold; //read priority threshold register
   else if(apb_read & (paddr_i == 'h5))
          prdata_o [2:0] <= irq0_reg;           //read interrupt request 0 register
   else if(apb_read & (paddr_i == 'h6))
          prdata_o [2:0] <= irq1_reg;           //read interrupt request 1 register
   else if(apb_read & (paddr_i == 'h7))
          prdata_o [2:0] <= irq2_reg;           //read interrupt request 2 register
   else if(apb_read & (paddr_i == 'h8))
          prdata_o [2:0] <= irq3_reg;           //read interrupt request 3 register
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
 
 assign pready_o  = 1'b1;// no need to extend the APB transfer
 assign pslverr_o = 1'b0;// APB peripherials are not required to support the 
                         // PSLVERR pin, so it is tied LOW
 
endmodule //interrupt_controller