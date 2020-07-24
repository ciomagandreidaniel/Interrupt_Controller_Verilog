//checking the rising edge pulse detector

module interrupt_controller(
input       pclk_i,
input       rst_n_i,
input       [3:0] irq_request_i,
output       interrupt_o
);


reg [3:0] status;




//status register
always @(posedge pclk_i or negedge rst_n_i)
begin
 if(~rst_n_i) 
  begin
   status      <= 4'b0000;
  end
 else 
  begin
    case (irq_request_i)
	 4'b0001 : begin status [0] <= 1'b1; end
	 4'b0010 : begin status [1] <= 1'b1; end
	 4'b0011 : begin status [0] <= 1'b1;
	                 status [1] <= 1'b1; end
	 4'b0100 : begin status [2] <= 1'b1; end
	 4'b0101 : begin status [0] <= 1'b1;
	                 status [2] <= 1'b1; end
	 4'b0110 : begin status [1] <= 1'b1;
	                 status [2] <= 1'b1; end
	 4'b0111 : begin status [0] <= 1'b1;
	                 status [1] <= 1'b1;
					 status [2] <= 1'b1; end
	 4'b1000 : begin status [3] <= 1'b1; end
	 4'b1001 : begin status [0] <= 1'b1;
	                 status [3] <= 1'b1; end
     4'b1010 : begin status [1] <= 1'b1;
                     status [3] <= 1'b1; end
	 4'b1011 : begin status [0] <= 1'b1;
	                 status [1] <= 1'b1;
					 status [3] <= 1'b1; end
	 4'b1100 : begin status [2] <= 1'b1;
	                 status [3] <= 1'b1; end
	 4'b1101 : begin status [0] <= 1'b1;
	                 status [2] <= 1'b1;
					 status [3] <= 1'b1; end
	 4'b1110 : begin status [1] <= 1'b1;
	                 status [2] <= 1'b1;
					 status [3] <= 1'b1; end
	 4'b1111 : begin status [0] <= 1'b1;
	                 status [1] <= 1'b1;
	                 status [2] <= 1'b1;
					 status [3] <= 1'b1; end
	endcase
  end
end

 assign  interrupt_o      = 1'b0;



endmodule