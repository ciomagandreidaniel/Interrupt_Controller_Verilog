module dcpirq(
input clk,
input rst_n,
input enable,
input [3:0] irq_trigger,
output      int_output,
output reg [1:0] irq_address
);

//TESTING!!!	
//--------------------------------------------------------------
// Priority
//--------------------------------------------------------------

reg [4:0] irq_reg_0;
reg [4:0] irq_reg_1;
reg [4:0] irq_reg_2;
reg [4:0] irq_reg_3;

wire        ack_irq;
wire       irq_line;

wire irq_out_0;
wire irq_out_1;
wire irq_out_2;
wire irq_out_3;


//irq_reg_0

always @(posedge clk or negedge rst_n)
begin 
if(~rst_n)
 begin
  irq_reg_0 <= 5'b00000;
 end
else if(enable)
 begin
   if(irq_trigger[0])
    irq_reg_0[0] <= 1'b1;
   if(ack_irq) 
    irq_reg_0[3] <= 1'b1;
   if(irq_reg_0[3] & (~irq_reg_0[0]))
    irq_reg_0[4] <= 1'b1;
 end
end

//irq_reg_1

always @(posedge clk or negedge rst_n)
begin 
if(~rst_n)
 begin
  irq_reg_1 <= 5'b00100;
 end
else if(enable)
 begin
   if(irq_trigger[1])
    irq_reg_1[0] <= 1'b1;
   if(irq_reg_0[4]) 
    irq_reg_1[3] <= 1'b1;
   if(irq_reg_1[3] & (~irq_reg_1[0]))
    irq_reg_1[4] <= 1'b1;	
 end
end

//irq_reg_2

always @(posedge clk or negedge rst_n)
begin 
if(~rst_n)
 begin
  irq_reg_2 <= 5'b00010;
 end
else if(enable)
 begin
   if(irq_trigger[2])
    irq_reg_2[0] <= 1'b1;
   if(irq_reg_1[4]) 
    irq_reg_2[3] <= 1'b1;
   if(irq_reg_2[3] & (~irq_reg_2[0]))
    irq_reg_2[4] <= 1'b1;
 end
end


//irq_reg_3

always @(posedge clk or negedge rst_n)
begin 
if(~rst_n)
 begin
  irq_reg_3 <= 5'b00110;
 end
else if(enable)
 begin
   if(irq_trigger[3])
    irq_reg_3[0] <= 1'b1;
   if(irq_reg_2[4]) 
    irq_reg_3[3] <= 1'b1;
   if(irq_reg_3[3] & (~irq_reg_3[0]))
    irq_reg_3[4] <= 1'b1;
 end
end

assign irq_line = irq_reg_0[0] | irq_reg_1[0] | irq_reg_2[0] | irq_reg_3[0];


assign ack_irq = irq_line;

assign irq_out_0 = irq_reg_0[0] &  irq_reg_0[3];
assign irq_out_1 = irq_reg_1[0] &  irq_reg_1[3];
assign irq_out_2 = irq_reg_2[0] &  irq_reg_2[3];
assign irq_out_3 = irq_reg_3[0] &  irq_reg_3[3];

assign int_output =  irq_out_0 | irq_out_1 | irq_out_2 | irq_out_3; 
					

//irq_address
always @(posedge clk or negedge rst_n)
begin
 if(~rst_n) irq_address <= 2'b00;
 else if (enable)
  begin
   if(irq_reg_0[3] & irq_reg_0[0])
       irq_address <= 2'b00;
   else if(irq_reg_1[3] & irq_reg_1[0])
       irq_address <= 2'b01;
   else if(irq_reg_2[3] & irq_reg_2[0])
       irq_address <= 2'b10;
   else if(irq_reg_3[3] & irq_reg_3[0])
       irq_address <= 2'b11;
  end
end



endmodule //dcpirq