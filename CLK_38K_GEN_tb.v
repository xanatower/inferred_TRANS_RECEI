`timescale 1ns/1ns 
module CLK_38K_GEN_tb(); 
reg CLK_50M, reset_n; wire CLK_38K;
 CLK_38K_GEN C0 (.CLK_50M(CLK_50M), .reset_n(reset_n), .CLK_38K(CLK_38K)); 
 initial begin
 CLK_50M = 1'b0; 
 reset_n = 1'b0; 
#100 reset_n = 1'b1; 
end 
always #10 CLK_50M = !CLK_50M; 
endmodule