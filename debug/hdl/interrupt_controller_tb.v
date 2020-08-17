//-----------------------------------------------------------------------------------------------------
// S.C EASYIC DESIGN S.R.L
// Project     : Interrupt Controller with APB Interface
// Module      : interrupt_controller_tb
// Author      : Ciomag Andrei Daniel(CAD)
// Date        : 26.07.2020
//-----------------------------------------------------------------------------------------------------
// Description : This module has the role of generating control signals for checking and debugging the
// interrupt_controller module.  
//-----------------------------------------------------------------------------------------------------
// Updates     :
// 26.07.2020    (CAD): Initial
// 03.08.2020    (CAD): Update 2 
//-----------------------------------------------------------------------------------------------------

module interrupt_controller_tb(
input                 interrupt_i     ,
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


//--------------------------------------------------------------
// Random Transaction Generator Task
//--------------------------------------------------------------

task tr_gen;

input [3:0] irq_p;
input [3:0] mask;
input [2:0] pth;
input [2:0] ir0;
input [2:0] ir1;
input [2:0] ir2;
input [2:0] ir3;


begin
apb_write('d2, 'b1111);        // clear status register
apb_write('d4, pth);           // write to priority threschold register
apb_write('d5, ir0);           // write to irq0_reg
apb_write('d6, ir1);           // write to irq1_reg
apb_write('d7, ir2);           // write to irq2_reg
apb_write('d8, ir3);           // write to irq3_reg
apb_write('d3,mask);           // write to mask register
@(posedge pclk_o);
irq_pulse(irq_p);
@(posedge pclk_o);
end

endtask

//--------------------------------------------------------------
// Initiate Testing
//--------------------------------------------------------------

initial begin

apb_init;
irq_trigger_o <= {4{1'b0}};

@(posedge pclk_o);
@(posedge pclk_o);
@(posedge pclk_o);
//enable_o <= 1'b0;
tr_gen('b1001, 'b0001, 'd2, 'd1,'d2,'d3,'d4);

@(posedge pclk_o);
apb_read('d3);
apb_read('d1);
apb_read('d6);
@(posedge pclk_o);
@(posedge pclk_o);
//tr_gen('b1110, 'b0100);
@(posedge pclk_o);
@(posedge pclk_o);
   
end

//--------------------------------------------------------------


//--------------------------------------------------------------
// Interrupt requests pulses task
//--------------------------------------------------------------

task irq_pulse;
input [3:0] irq;

begin
$display ("%g Interrupt request pulses: %b", $time, irq);
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

input [31:0] address;

begin
$display ("%g APB read from %d address", $time, address);
paddr_o   <= address;
pwrite_o  <= 1'b0;
psel_o    <= 1'b1;
@(posedge pclk_o);
penable_o <= 1'b1;
@(posedge pclk_o);
psel_o    <= 1'b0;
penable_o <= 1'b0;
@(posedge pclk_o);
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
$display ("%g APB write %d to %d address", $time, data[7:0], address);
paddr_o   <= address;
pwdata_o  <= data;
pwrite_o  <= 1'b1;
psel_o    <= 1'b1;
@(posedge pclk_o);
penable_o <= 1'b1;
@(posedge pclk_o);
psel_o    <= 1'b0;
penable_o <= 1'b0;
@(posedge pclk_o);
end

endtask

//--------------------------------------------------------------

//--------------------------------------------------------------
// Initiate APB task
//--------------------------------------------------------------

task apb_init;

begin
$display ("%g Initiate APB", $time);
paddr_o       <= {32{1'b0}};
pwrite_o      <= 1'b0;
psel_o        <= 1'b0;
penable_o     <= 1'b0;
pwdata_o      <= {32{1'b0}};
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