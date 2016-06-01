`timescale 1ns/1ns

module RX_CONTROLLER_tb();

// Reg and wire declaration
reg reset_n;
reg CLK_50M;
reg send_en;
reg [7:0] Din;
wire Dout;
wire busy;
//
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
		Din              = 8'b11111111; // TODO: Change this to examine different input patterns
		#100 reset_n     = 1'b1;
		#200 send_en     = 1'b1;
		#500 send_en     = 1'b0;
		#20000000    Din = 8'b1111_0000;
		#200 reset_n     = 1'b0;
		#500 reset_n     = 1'b1;
		#400 send_en     = 1'b1;
		#700 send_en     = 1'b0;
	end

always
	#10 CLK_50M = !CLK_50M;
wire [6:0] h0,h1;
wire [7:0] rx_Dout;
wire rx_data_ready;				  
RX_CONTROLLER  R0(.reset_n(reset_n),
                  .CLK_50M(CLK_50M),
				  .Din(~Dout),
				  .Dout(rx_Dout),
				  .ready(rx_data_ready));	
HEX_DISPLAY hx (.value(rx_Dout),.enable(rx_data_ready),.display0(h0),.display1(h1));

	
endmodule 

module HEX_DISPLAY(input [7:0] value,input enable ,output [6:0] display0,display1);
	SSeg sseg0 (value[7:4],1'b0,enable,display0);
	SSeg sseg1 (value[3:0],1'b0,enable,display1);
endmodule

module SSeg(input [3:0] bin, input neg, input enable, output reg [6:0] segs);
	always @(*)
		if (enable) begin
			if (neg) segs = 7'b011_1111;
			else begin
				case (bin)
					0: segs = 7'b100_0000;
					1: segs = 7'b111_1001;
					2: segs = 7'b010_0100;
					3: segs = 7'b011_0000;
					4: segs = 7'b001_1001;
					5: segs = 7'b001_0010;
					6: segs = 7'b000_0010;
					7: segs = 7'b111_1000;
					8: segs = 7'b000_0000;
					9: segs = 7'b001_1000;
					10: segs = 7'b000_1000;
					11: segs = 7'b000_0011;
					12: segs = 7'b100_0110;
					13: segs = 7'b010_0001;
					14: segs = 7'b000_0110;
					15: segs = 7'b000_1110;
				endcase
			end
		end
		else segs = 7'b111_1111;
endmodule