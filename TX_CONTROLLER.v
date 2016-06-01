module TX_CONTROLLER(reset_n,CLK_50M,send_en,Din,Dout,busy);
	input reset_n; //active low reset
	input  CLK_50M; // 50MHz system clock
	input send_en; // send enable, start sending when high
	input [7:0] Din; // 8 bit data
	output reg Dout; // data out
	output reg busy; // busy flag, high when sending
	// PARAMETERS
	localparam LEADER_HIGH_DURATION = 100000; //100000 * 20ns = 2ms
	localparam LEADER_LOW_DURATION = 25000;
	localparam LOGIC_ONE_DURATION = 75000;
	localparam LOGIC_ZERO_DURATION = 50000;
	localparam BURST_ONE_DURATION = 50000;
	localparam BURST_ZERO_DURATION = 25000;
	localparam STOP_DURATION = 75000;
	// STATES
	localparam STATE_IDLE = 0;
	localparam STATE_LEADER_HIGH = 1;
	localparam STATE_LEADER_LOW = 2;
	localparam STATE_SENDING_DATA = 3;
	localparam STATE_SEND_0 = 4;
	localparam STATE_SEND_1 = 5;
	localparam STATE_STOP = 6;
	// defining Registers
	reg [31:0] TimeCounter; // counter to count time
	reg [3:0] SentCounter; // counter to count the number of sent data
	reg [2:0] CurrentState; // FSM states
	reg [7:0] DataReg; // Register stores data being sent

	always@(posedge CLK_50M) 
	begin
		if(!reset_n) begin
			TimeCounter <= 32'b0;
			SentCounter <= 4'b0;
			CurrentState <= STATE_IDLE;
			DataReg <= 8'b0;
			busy <= 1'b0;
			Dout <= 1'b0;
		end
		else begin
			case(CurrentState)
				STATE_IDLE:
					if(send_en) begin
						TimeCounter<=32'b0;
						SentCounter<=4'b0;
						CurrentState <= STATE_LEADER_HIGH;
						DataReg <= Din;
						busy <= 1'b1;
						Dout <= 1'b1;
					end else begin
						TimeCounter <= 32'b0;
						SentCounter <= 4'b0;
						CurrentState <= STATE_IDLE;
						DataReg <= 8'b0;
						busy <= 1'b0;
						Dout <= 1'b0;
					end
				STATE_LEADER_HIGH:
					if(TimeCounter == LEADER_HIGH_DURATION) begin
						TimeCounter <= 32'b0;
						CurrentState <= STATE_LEADER_LOW;
						Dout <= 1'b0;
					end else begin
						TimeCounter <= TimeCounter + 1'b1;
					end
				STATE_LEADER_LOW:
					if(TimeCounter == LEADER_LOW_DURATION) begin
						TimeCounter <= 32'b0;
						CurrentState <= STATE_SENDING_DATA;
						Dout <= 1'b0;
					end else begin
						TimeCounter <= TimeCounter + 1'b1;
					end
				STATE_SENDING_DATA:
					if(SentCounter[3]) begin // if all data was sent
						SentCounter <= 4'b0;
						CurrentState <= STATE_STOP;
						Dout <= 1'b1; // ?
					end else begin
						SentCounter <= SentCounter + 1'b1;
						if(DataReg[7]) CurrentState <= STATE_SEND_1;
						else CurrentState <= STATE_SEND_0;
						DataReg <= {DataReg[6:0],1'b0};
						Dout <= 1'b1;
					end
				STATE_SEND_0:
					if(TimeCounter == LOGIC_ZERO_DURATION) begin
						TimeCounter <= 32'b0;
						CurrentState <= STATE_SENDING_DATA;
						Dout <= 1'b0;
					end else begin
						busy <= 1'b1;
						if(TimeCounter >= BURST_ZERO_DURATION) begin
							TimeCounter <= TimeCounter + 1'b1;
							Dout <= 1'b0;
						end else begin
							TimeCounter <= TimeCounter + 1'b1;
							Dout <= 1'b1;
						end
					end
				STATE_SEND_1:
					if(TimeCounter == LOGIC_ONE_DURATION) begin
						TimeCounter <= 32'b0;
						CurrentState <= STATE_SENDING_DATA;
						Dout <= 1'b0;
					end else begin
						busy <= 1'b1;
						if(TimeCounter >= BURST_ONE_DURATION) begin
							TimeCounter <= TimeCounter + 1'b1;
							Dout <= 1'b0;
						end else begin
							TimeCounter <= TimeCounter + 1'b1;
							Dout <= 1'b1;
						end
					end
				STATE_STOP:
					if(TimeCounter == STOP_DURATION) begin
						TimeCounter <= 32'b0;
						CurrentState <= STATE_IDLE;
						Dout <= 1'b0;
					end else begin
						TimeCounter <= TimeCounter + 1'b1;
						CurrentState <= STATE_STOP;
						Dout <= 1'b1;
					end
			endcase
		end
	end
endmodule
