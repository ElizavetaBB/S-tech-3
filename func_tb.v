`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2021 02:32:05 PM
// Design Name: 
// Module Name: func_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module func_tb;
	reg clk_i;
	reg rst_i;
	reg start_i;
	reg [7:0] a_i, b_i;
	wire busy_o;
	wire [23:0] y_o;
	initial begin
		rst_i <= 1;
		a_i <= 0;
		b_i <= 0;
	end
	initial begin
		clk_i <= 1;
		forever
			#10 clk_i <= ~clk_i;
	end
	reg[23:0] expected_value;
	
	func func1(
		.clk_i(clk_i),
		.rst_i(rst_i),
		.start_i(start_i),
		.a_i(a_i),
		.b_i(b_i),
		.busy_o(busy_o),
		.y_o(y_o)
	);
	
	always @(posedge clk_i) begin
		if (rst_i) begin
			expected_value <= 0;
			rst_i <= 0;
			start_i <= 1;
		end else if (!busy_o && start_i==0) begin
			if (b_i<1) begin
				expected_value <= a_i*a_i*a_i;
			end else if (b_i<4) begin
				expected_value <= a_i*a_i*a_i+1;
			end else if (b_i<9) begin
				expected_value <= a_i*a_i*a_i+2;
			end else if (b_i<16) begin
				expected_value <= a_i*a_i*a_i+3;
			end else if (b_i<25) begin
				expected_value <= a_i*a_i*a_i+4;
			end else if (b_i<36) begin
				expected_value <= a_i*a_i*a_i+5;
			end else if (b_i<49) begin
				expected_value <= a_i*a_i*a_i+6;
			end else if (b_i<64) begin
				expected_value <= a_i*a_i*a_i+7;
			end else if (b_i<81) begin
				expected_value <= a_i*a_i*a_i+8;
			end else if (b_i<100) begin
				expected_value <= a_i*a_i*a_i+9;
			end else if (b_i<121) begin
				expected_value <= a_i*a_i*a_i+10;
			end else if (b_i<144) begin
				expected_value <= a_i*a_i*a_i+11;
			end else if (b_i<169) begin
				expected_value <= a_i*a_i*a_i+12;
			end else if (b_i<196) begin
				expected_value <= a_i*a_i*a_i+13;
			end else if (b_i<225) begin
				expected_value <= a_i*a_i*a_i+14;
			end else begin
				expected_value <= a_i*a_i*a_i+15;
			end
			#1
			$display("cube(%d)+sqrt(%d)=%d, expected_value=%d",a_i,b_i,y_o,expected_value);
			if (!rst_i && a_i<241) begin
				a_i <= a_i+15;
				b_i <= b_i+15;
				rst_i <= 1;
			end else begin
				$stop;
			end
		end else begin
			start_i <= 0;
		end
	end
endmodule
