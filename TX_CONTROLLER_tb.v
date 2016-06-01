`timescale 1ns/1ns

module TX_CONTROLLER_tb();

// Reg and wire declaration
reg reset_n;
reg CLK_50M;
reg send_en;
reg [7:0] Din;
wire Dout;
wire busy;

TX_CONTROLLER  T0(.reset_n(reset_n), 
                  .CLK_50M(CLK_50M), 
				  .send_en(send_en),
				  .Din(Din), 
				  .Dout(Dout), 
				  .busy(busy));				 	 

// Generate clock and reset
initial
	begin
		CLK_50M          = 1'b0;
		reset_n          = 1'b0;
		send_en          = 1'b0;
		Din              = 8'b10101100; // TODO: Change this to examine different input sequence
		#100 reset_n     = 1'b1;
		#200 send_en     = 1'b1;
		#500 send_en     = 1'b0;		
	end

always
	#10 CLK_50M = !CLK_50M;
	
endmodule 


