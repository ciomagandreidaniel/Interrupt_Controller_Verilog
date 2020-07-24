
module interrupt_controller_test;

wire clk;
wire rst_n;
wire [3:0]irq_request;
wire interrupt;

interrupt_controller
 i_interrupt_controller(
  .pclk_i(clk),
  .rst_n_i(rst_n),
  .irq_request_i(irq_request),
  .interrupt_o(interrupt)
);

interrupt_controller_tb
 i_interrupt_controller_tb(
  .clk(clk),
  .rst_n(rst_n),
  .interrupt_request(irq_request)
);

endmodule