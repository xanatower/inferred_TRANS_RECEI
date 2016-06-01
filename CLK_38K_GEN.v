module CLK_38K_GEN(input CLK_50M, input reset_n, output reg CLK_38K);
	localparam HALF_CYCLE_DURATION = 12500/19;
	localparam COUNTER_WIDTH = 10;
	reg [COUNTER_WIDTH-1:0] counter;

	always@(posedge CLK_50M or negedge reset_n)
	begin
		if(!reset_n) begin
			CLK_38K <= 1'b0;
			counter <= {COUNTER_WIDTH{1'b0}};
		end else 
			if(counter == HALF_CYCLE_DURATION) begin
				CLK_38K <= !CLK_38K;
				counter <= {COUNTER_WIDTH{1'b0}};
			end else counter <= counter + 1'b1;
	end
endmodule