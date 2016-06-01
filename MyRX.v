module MyRX(CLOCK_50, IRDA_RXD,SW,HEX0,HEX1);
	input CLOCK_50;
	input IRDA_RXD;
	input [8:8] SW;
	output [6:0] HEX0;
	output [6:0] HEX1;
	wire [7:0] Dout;
	wire Ready;
	RX_CONTROLLER rxcontrl (.reset_n(SW[8]),.CLK_50M(CLOCK_50),.Din(IRDA_RXD),.Dout(Dout),.ready(Ready));
	HEX_DISPLAY display (.value(Dout),.enable(Ready), .display0(HEX1),.display1(HEX0));
endmodule

module HEX_DISPLAY(input [7:0] value, input enable,output [6:0] display0,display1);
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