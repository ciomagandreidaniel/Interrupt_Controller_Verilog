
module interrupt_controller_test;

wire pclk;
wire rst_n;
wire enable;
wire penable;
wire psel;
wire pwrite;
wire [31:0] paddr;
wire [31:0] pwdata;
wire [31:0] prdata;
wire pready;
wire pslverr;

wire [3:0] irq_trigger;
wire   interrupt;



interrupt_controller
 i_interrupt_controller(
  .pclk_i(pclk),
  .penable_i(penable),
  .psel_i(psel),
  .pwrite_i(pwrite),
  .paddr_i(paddr),
  .pwdata_i(pwdata),
  .prdata_o(prdata),
  .pready_o(pready),
  .pslverr_o(pslverr),
  .rst_n_i(rst_n),
  .enable_o(enable),
  .irq_trigger_i(irq_trigger),
  .interrupt_o(interrupt)
);



interrupt_controller_tb
 i_interrupt_controller_tb(
  .pclk_o(pclk),
  .rst_n_o(rst_n),
  .penable_o(penable),
  .psel_o (psel),
  .pwrite_o(pwrite),
  .paddr_o(paddr),
  .pwdata_o(pwdata),
  .irq_trigger_o(irq_trigger),
  .enable_o(enable)
);

endmodule