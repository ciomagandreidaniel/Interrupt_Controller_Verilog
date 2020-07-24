//testing the pulse detector

module interrupt_controller_tb(
output reg clk,
output reg rst_n,
output reg [3:0]interrupt_request
);


initial begin
interrupt_request <= 1'b0;
@(posedge clk);
@(posedge clk);
@(posedge clk);
@(posedge clk);
@(posedge clk);
@(posedge clk);
@(posedge clk);
interrupt_request[0] <= 1'b1;
interrupt_request[3] <= 1'b1;
@(posedge clk);
interrupt_request[0] <= 1'b0;
interrupt_request[3] <= 1'b0;
@(posedge clk);
interrupt_request[1] <= 1'b1;
@(posedge clk);
interrupt_request[1] <= 1'b0;
@(posedge clk);
@(posedge clk);

end

initial begin
  clk = 1'b0; 
  forever #5 clk = ~clk;
end

initial begin
  rst_n <= 1'b1;  
  @(posedge clk);
  rst_n <= 1'b0;
  @(posedge clk);
  @(posedge clk);
  rst_n <= 1'b1;  
  @(posedge clk);
end

endmodule