//checking the rising edge pulse detector

module interrupt_controller(

//APB Interface
input               pclk_i         ,
input               penable_i      ,
input               psel_i         ,
input               pwrite_i       ,
input      [31:0]   paddr_i       ,
input      [31:0]   pwdata_i       ,
output reg [31:0]   prdata_o       ,
output              pready_o       ,
output              pslverr_o      ,


//interrupt controller
             
input               rst_n_i        ,
input               enable_o       ,
input      [3:0]    irq_request_i  ,
output              interrupt_o
);





wire apb_write = psel_i & penable_i & pwrite_i;
wire apb_read  = psel_i & ~pwrite_i;

//status
//--------------------------------------------------------------
reg status_0;
reg status_1;
reg status_2;
reg status_3;

wire [3:0] status; // address 1
//--------------------------------------------------------------

//clear
//--------------------------------------------------------------
reg [3:0] clear ; // address 2
//--------------------------------------------------------------

//mask
//--------------------------------------------------------------
reg mask_0;
reg mask_1;
reg mask_2;
reg mask_3;

wire [3:0] mask; // address 1
//--------------------------------------------------------------




//--------------------------------------------------------------
// Status Register
//--------------------------------------------------------------

//status_0 
always @(posedge pclk_i or negedge rst_n_i)
begin
 if(~rst_n_i) 
  begin
   status_0      <= 1'b0;
  end
  else if(enable_o)
  begin
   if(clear[0])
    begin
     status_0 <= 1'b0;
    end	
    else if(irq_request_i[0])
    begin
     status_0 <= 1'b1;
    end
   end   
end

//status_1 
always @(posedge pclk_i or negedge rst_n_i)
begin
 if(~rst_n_i) 
  begin
   status_1      <= 1'b0;
  end
  else if(enable_o)
  begin
   if(clear[1])
    begin
     status_1 <= 1'b0;
    end	
    else if(irq_request_i[1])
    begin
     status_1 <= 1'b1;
    end
   end   
end

//status_2 
always @(posedge pclk_i or negedge rst_n_i)
begin
 if(~rst_n_i) 
  begin
   status_2      <= 1'b0;
  end
  else if(enable_o)
  begin
   if(clear[2])
    begin
     status_2 <= 1'b0;
    end	
    else if(irq_request_i[2])
    begin
     status_2 <= 1'b1;
    end
   end   
end

//status_3 
always @(posedge pclk_i or negedge rst_n_i)
begin
 if(~rst_n_i) 
  begin
   status_3      <= 1'b0;
  end
  else if(enable_o)
  begin
   if(clear[3])
    begin
     status_3 <= 1'b0;
    end	
    else if(irq_request_i[3])
    begin
     status_3 <= 1'b1;
    end
   end   
end

assign status = {status_3,status_2,status_1,status_0};

//--------------------------------------------------------------



//--------------------------------------------------------------
// Clear Register
//--------------------------------------------------------------

always @(posedge pclk_i or negedge rst_n_i)
begin
 if(~rst_n_i)
  clear <= {4{1'b0}};
 else if (enable)
  begin
   if(apb_write & (paddr_i == 'd2))
    begin
	 clear <= pwdata_i[3:0];
	end
   else
     clear <= {4{1'b0}};
  end
end

//--------------------------------------------------------------

//--------------------------------------------------------------
// Mask Register
//--------------------------------------------------------------

always @(posedge pclk_i or negedge rst_n_i)



assign mask = {mask_3,mask_2,mask_1,mask_0}; 

//--------------------------------------------------------------

 assign  interrupt_o      = 1'b0;//|(mask & status);
 
 assign pready  = 1'b1;
 assign pslverr = 1'b0;


endmodule