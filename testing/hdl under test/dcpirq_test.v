module dcpirq_test;

wire clk;
wire rst_n;
wire enable;
wire [3:0] irq_trigger;
wire int_output;
wire [1:0] irq_address;

dcpirq 
 i_dcpirq(
  .clk(clk),
  .rst_n(rst_n),
  .enable(enable),
  .irq_trigger(irq_trigger),
  .int_output(int_output),
  .irq_address(irq_address)
 );
 
dcpirq_tb 
 i_dcpirq_tb(
  .clk(clk),
  .rst_n(rst_n),
  .enable(enable),
  .irq_trigger(irq_trigger)
 );

endmodule //dcpirq_test