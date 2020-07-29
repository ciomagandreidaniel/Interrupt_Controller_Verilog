module dcpirq(
input clk,
input rst_n,
input enable,
input [3:0] irq_trigger,
output reg  int_output,
output reg [1:0] irq_address
);

//TESTING!!!	
//--------------------------------------------------------------
// Priority
//--------------------------------------------------------------

reg [2:0] irq_reg_0;
reg [2:0] irq_reg_1;
reg [2:0] irq_reg_2;
reg [2:0] irq_reg_3;

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
  irq_reg_0 <= 3'b000;
 end
else if(enable)
 begin
   if(irq_trigger[0])
    irq_reg_0[0] <= 1'b1;
   if(ack_irq) 
    irq_reg_0[1] <= 1'b1;
   if(irq_reg_0[1] & (~irq_reg_0[0]))
    irq_reg_0[2] <= 1'b1;
 end
end

//irq_reg_1

always @(posedge clk or negedge rst_n)
begin 
if(~rst_n)
 begin
  irq_reg_1 <= 3'b000;
 end
else if(enable)
 begin
   if(irq_trigger[1])
    irq_reg_1[0] <= 1'b1;
   if(irq_reg_0[2]) 
    irq_reg_1[1] <= 1'b1;
   if(irq_reg_1[1] & (~irq_reg_1[0]))
    irq_reg_1[2] <= 1'b1;	
 end
end

//irq_reg_2

always @(posedge clk or negedge rst_n)
begin 
if(~rst_n)
 begin
  irq_reg_2 <= 3'b000;
 end
else if(enable)
 begin
   if(irq_trigger[2])
    irq_reg_2[0] <= 1'b1;
   if(irq_reg_1[2]) 
    irq_reg_2[1] <= 1'b1;
   if(irq_reg_2[1] & (~irq_reg_2[0]))
    irq_reg_2[2] <= 1'b1;
 end
end


//irq_reg_3

always @(posedge clk or negedge rst_n)
begin 
if(~rst_n)
 begin
  irq_reg_3 <= 3'b000;
 end
else if(enable)
 begin
   if(irq_trigger[3])
    irq_reg_3[0] <= 1'b1;
   if(irq_reg_2[2]) 
    irq_reg_3[1] <= 1'b1;
   if(irq_reg_3[1] & (~irq_reg_3[0]))
    irq_reg_3[2] <= 1'b1;
 end
end

assign irq_line = irq_reg_0[0] | irq_reg_1[0] | irq_reg_2[0] | irq_reg_3[0];


assign ack_irq = irq_line;

assign irq_out_0 = irq_reg_0[0] &  irq_reg_0[1];
assign irq_out_1 = irq_reg_1[0] &  irq_reg_1[1];
assign irq_out_2 = irq_reg_2[0] &  irq_reg_2[1];
assign irq_out_3 = irq_reg_3[0] &  irq_reg_3[1];

					
always @(posedge clk or negedge rst_n)
begin
 if(~rst_n)
   int_output = 1'b0;
 else if(enable)
   int_output <=  irq_out_0 | irq_out_1 | irq_out_2 | irq_out_3;
end 

//irq_address
always @(posedge clk or negedge rst_n)
begin
 if(~rst_n) irq_address <= 2'b00;
 else if (enable)
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



endmodule //dcpirq