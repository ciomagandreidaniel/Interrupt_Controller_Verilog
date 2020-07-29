module interrupt_controller_v2(

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
output reg          interrupt_o    ,
output reg [1:0]    irq_address
);


//apb command signals
wire apb_write = psel_i & penable_i & pwrite_i;
wire apb_read  = psel_i & ~pwrite_i;

//priority threshold
reg [2:0] priority_threshold; //0x09

//interrupt request registers
reg [2:0] irq_reg_0;
reg [2:0] irq_reg_1;
reg [2:0] irq_reg_2;
reg [2:0] irq_reg_3;

//interrupt acknowledge
wire        ack_irq;

//interrupt request line
wire       irq_line;

//interrupt request output lines
wire irq_out_0;
wire irq_out_1;
wire irq_out_2;
wire irq_out_3;



//--------------------------------------------------------------
// irq_reg_0
//--------------------------------------------------------------

always @(posedge pclk_i or negedge rst_n_i)
begin 
if(~rst_n_i)
 begin
  irq_reg_0 <= 3'b000;
 end
else if(enable_o)
 begin
   if(irq_trigger_i[0])
    irq_reg_0[0] <= 1'b1;
   if(ack_irq) 
    irq_reg_0[1] <= 1'b1;
   if(irq_reg_0[1] & (~irq_reg_0[0]))
    irq_reg_0[2] <= 1'b1;
 end
end

//--------------------------------------------------------------

//--------------------------------------------------------------
// irq_reg_1
//--------------------------------------------------------------

always @(posedge pclk_i or negedge rst_n_i)
begin 
if(~rst_n_i)
 begin
  irq_reg_1 <= 3'b000;
 end
else if(enable_o)
 begin
   if(irq_trigger_i[1])
    irq_reg_1[0] <= 1'b1;
   if(irq_reg_0[2]) 
    irq_reg_1[1] <= 1'b1;
   if(irq_reg_1[1] & (~irq_reg_1[0]))
    irq_reg_1[2] <= 1'b1;	
 end
end

 
//--------------------------------------------------------------

//--------------------------------------------------------------
// irq_reg_2
//--------------------------------------------------------------

always @(posedge pclk_i or negedge rst_n_i)
begin 
if(~rst_n_i)
 begin
  irq_reg_2 <= 3'b000;
 end
else if(enable_o)
 begin
   if(irq_trigger_i[2])
    irq_reg_2[0] <= 1'b1;
   if(irq_reg_1[2]) 
    irq_reg_2[1] <= 1'b1;
   if(irq_reg_2[1] & (~irq_reg_2[0]))
    irq_reg_2[2] <= 1'b1;	
 end
end

 
//--------------------------------------------------------------

//--------------------------------------------------------------
// irq_reg_3
//--------------------------------------------------------------

always @(posedge pclk_i or negedge rst_n_i)
begin 
if(~rst_n_i)
 begin
  irq_reg_3 <= 3'b000;
 end
else if(enable_o)
 begin
   if(irq_trigger_i[3])
    irq_reg_3[0] <= 1'b1;
   if(irq_reg_2[2]) 
    irq_reg_3[1] <= 1'b1;
   if(irq_reg_3[1] & (~irq_reg_3[0]))
    irq_reg_3[2] <= 1'b1;	
 end
end

 
//--------------------------------------------------------------

//--------------------------------------------------------------
// ack_irq
//--------------------------------------------------------------

assign ack_irq = irq_line;

//--------------------------------------------------------------

//--------------------------------------------------------------
// irq_line
//--------------------------------------------------------------

assign irq_line = irq_reg_0[0] | irq_reg_1[0] | irq_reg_2[0] | irq_reg_3[0];

//--------------------------------------------------------------

//--------------------------------------------------------------
// interrupt_o
//--------------------------------------------------------------

assign irq_out_0 = irq_reg_0[0] &  irq_reg_0[1];
assign irq_out_1 = irq_reg_1[0] &  irq_reg_1[1];
assign irq_out_2 = irq_reg_2[0] &  irq_reg_2[1];
assign irq_out_3 = irq_reg_3[0] &  irq_reg_3[1];

					
always @(posedge pclk_i or negedge rst_n_i)
begin
 if(~rst_n_i)
   interrupt_o = 1'b0;
 else if(enable_o)
   interrupt_o <=  ((priority_threshold >= 'd1) & irq_out_0) | 
                   ((priority_threshold >= 'd2) & irq_out_1) | 
				   ((priority_threshold >= 'd3) & irq_out_2) | 
				   ((priority_threshold >= 'd4) & irq_out_3) ;
end 

//--------------------------------------------------------------

//--------------------------------------------------------------
// irq_address
//--------------------------------------------------------------

always @(posedge pclk_i or negedge rst_n_i)
begin
 if(~rst_n_i) irq_address <= 2'b00;
 else if (enable_o)
  begin
   if(irq_reg_0[1] & irq_reg_0[0])
       irq_address <= 2'b00;
   else if(irq_reg_1[1] & irq_reg_1[0])
       irq_address <= 2'b01;
   else if(irq_reg_2[1] & irq_reg_2[0])
       irq_address <= 2'b10;
   else if(irq_reg_3[1] & irq_reg_3[0])
       irq_address <= 2'b11;
  end
end

//--------------------------------------------------------------

//--------------------------------------------------------------
// priority_threshold
//--------------------------------------------------------------

always @(posedge pclk_i or negedge rst_n_i)
begin
 if(~rst_n_i) priority_threshold <= 3'b100;
 else if (enable_o)
 begin
  if(apb_write & (paddr_i == 'd9))
     priority_threshold <= pwdata_i[3:0];
 end
             
end

//--------------------------------------------------------------

 assign pready_o  = 1'b1;
 assign pslverr_o = 1'b0;


endmodule //interrupt_controller_v2