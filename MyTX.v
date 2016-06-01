module MyTX(SW,KEY,CLOCK_50,IRDA_TXD);
	input [8:0] SW;
	input [0:0] KEY;
	input CLOCK_50;
	//output [0:0] LEDR;
	output IRDA_TXD;
	wire safe_enable;
	wire enable_activated;
	wire dout;
	wire busy;
	wire clk_38k;
	//assign LEDR[0] = dout;
	Synchroniser sync (.clk(CLOCK_50),.signal(KEY[0]),.synchronized_signal(safe_enable));
	DetectFallEdge dfe (.clock(CLOCK_50),.btn_sync(safe_enable),.fallingedgedetected(enable_activated));
	TX_CONTROLLER txctrl (.reset_n(SW[8]),.CLK_50M(CLOCK_50),.send_en(enable_activated),.Din(SW[7:0]),.Dout(dout),.busy(busy));
	CLK_38K_GEN clkgen (.CLK_50M(CLOCK_50), .reset_n(SW[8]), .CLK_38K(clk_38k));
	assign IRDA_TXD = dout & clk_38k;
endmodule
module DetectFallEdge(clock,btn_sync,fallingedgedetected);
	input clock,btn_sync;
	output fallingedgedetected;
	reg new_btn_sync;
	always@(posedge clock) begin
		new_btn_sync <= btn_sync;
	end
	assign fallingedgedetected = (new_btn_sync == 1'b1 && btn_sync == 1'b0) ? 1'b1 : 1'b0;
endmodule
module Synchroniser(input clk,input signal,output reg synchronized_signal);
	reg meta;

	always @(posedge clk) begin
		meta <= signal;
		synchronized_signal <= meta;
	end
endmodule
