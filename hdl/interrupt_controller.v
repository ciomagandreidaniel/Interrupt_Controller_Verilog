//checking the rising edge pulse detector

module interrupt_controller(
input       pclk_i,
input       rst_n_i,
input [3:0] irq_request_i,
output      interrupt_o
);

reg [3:0] status

always @(posedge pclk_i or negedge rst_n_i)
begin
 if(~rst_n_i) 
  begin
   status      <= {4{1'b0}};
  end
 else
  begin
    status[0]  <= irq_request_i[0];
  end
end

assign interrupt_o = status[0] &    

