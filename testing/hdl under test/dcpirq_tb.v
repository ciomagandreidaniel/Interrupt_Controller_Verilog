module dcpirq_tb (
 output reg clk,
 output reg rst_n,
 output reg enable,
 output reg [3:0] irq_trigger
);

initial begin
irq_trigger <= 4'b0000;
@(posedge clk);
@(posedge clk);
@(posedge clk);
@(posedge clk);

irq_pulse(4'b1000);
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

initial begin
 enable = 1'b1;
end

task irq_pulse;
input [3:0] irq;

begin
irq_trigger <= irq;
@(posedge clk);
irq_trigger <= {4{1'b0}};
end

endtask

endmodule //dcpirq_tb