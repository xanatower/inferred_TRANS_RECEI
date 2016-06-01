`timescale 1ns/1ns

module My_TX_tb();

// MyTX (SW,KEY,CLOCK_50,IRDA_TXD);
// Reg and wire declaration
reg [8:0] SW;
reg [0:0] KEY;
//reg reset_n;
//reg CLK_50M;
reg CLOCK_50;
//reg send_en;
//reg [7:0] Din;
//wire Dout;
//wire busy;
wire IRDA_TXD;
MyTX tx (.SW(SW),.KEY(KEY),.CLOCK_50(CLOCK_50),.IRDA_TXD(IRDA_TXD));
//TX_CONTROLLER  T0(.reset_n(reset_n), 
  //                .CLK_50M(CLK_50M), 
	//			  .send_en(send_en),
		//		  .Din(Din), 
			//	  .Dout(Dout), 
				//  .busy(busy));				 	 

// Generate clock and reset
initial
	begin
		CLOCK_50         = 1'b0;
		//CLK_50M          = 1'b0;
		//reset_n          = 1'b0;
		SW[8]            = 1'b0;
		KEY[0]           = 1'b0;
		//send_en          = 1'b0;
		SW[7:0]          = 8'b10101100;
		//Din              = 8'b10101100; // TODO: Change this to examine different input sequence
		#100 SW[8] = 1'b1;
		#200 KEY[0] = 1'b1;
		#500 KEY[0] = 1'b0;
		//#100 reset_n     = 1'b1;
		//#200 send_en     = 1'b1;
		//#500 send_en     = 1'b0;		
	end

always
	#10 CLOCK_50 = !CLOCK_50;
	
endmodule 


