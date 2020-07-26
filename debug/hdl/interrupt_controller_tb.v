

module interrupt_controller_tb(
output reg            pclk_o          ,
output reg            rst_n_o         ,
output reg            penable_o       ,
output reg            psel_o          ,
output reg            pwrite_o        ,
output reg [31:0]     paddr_o         ,
output reg [31:0]     pwdata_o        ,
output reg [3:0]      irq_trigger_o   , 
output reg            enable_o
);


initial begin

paddr_o       <= {32{1'b0}};
pwrite_o      <= 1'b0;
psel_o        <= 1'b0;
penable_o     <= 1'b0;
pwdata_o      <= {32{1'b0}};
irq_trigger_o <= {4{1'b0}};

@(posedge pclk_o);
@(posedge pclk_o);
@(posedge pclk_o);

apb_write('d3, 'd1);
@(posedge pclk_o);
irq_pulse(4'b0010);
@(posedge pclk_o);
irq_pulse(4'b0001);
@(posedge pclk_o);
apb_write('d2, 'b1111);
@(posedge pclk_o);
   

   
end

//--------------------------------------------------------------
// Interrupt requests pulses task
//--------------------------------------------------------------

task irq_pulse;
input [3:0] irq;

begin
irq_trigger_o <= irq;
@(posedge pclk_o);
irq_trigger_o <= {4{1'b0}};
end

endtask

//--------------------------------------------------------------

//--------------------------------------------------------------
// APB read task 
//--------------------------------------------------------------

task apb_read;


begin
paddr_o   <= 'd1;
pwrite_o  <= 1'b0;
psel_o    <= 1'b1;
@(posedge pclk_o);
penable_o <= 1'b1;
@(posedge pclk_o);
psel_o    <= 1'b0;
penable_o <= 1'b0;
end


endtask

//--------------------------------------------------------------


//--------------------------------------------------------------
// APB write task 
//--------------------------------------------------------------

task apb_write;

input [31:0] address;
input [31:0] data;

begin
paddr_o   <= address;
pwdata_o  <= data;
pwrite_o  <= 1'b1;
psel_o    <= 1'b1;
@(posedge pclk_o);
penable_o <= 1'b1;
@(posedge pclk_o);
psel_o    <= 1'b0;
penable_o <= 1'b0;
end

endtask

//--------------------------------------------------------------


//--------------------------------------------------------------
// Enable for clock gating
//--------------------------------------------------------------

initial begin
enable_o <= 1'b1;
end

//--------------------------------------------------------------


//--------------------------------------------------------------
// Clock generator
//--------------------------------------------------------------

initial begin
  pclk_o = 1'b0; 
  forever #5 pclk_o = ~pclk_o;
end

//--------------------------------------------------------------

//--------------------------------------------------------------
// Asynchronous reset generator
//--------------------------------------------------------------

initial begin
  rst_n_o <= 1'b1;  
  @(posedge pclk_o);
  rst_n_o <= 1'b0;
  @(posedge pclk_o);
  @(posedge pclk_o);
  rst_n_o <= 1'b1;  
  @(posedge pclk_o);
end

//--------------------------------------------------------------

endmodule //interrupt_controller_tb