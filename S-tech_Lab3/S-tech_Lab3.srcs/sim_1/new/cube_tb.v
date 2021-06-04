`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2021 02:54:27 PM
// Design Name: 
// Module Name: cube_tb
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


module cube_tb;
	reg clk_i, rst_i, start_i;
	reg [7:0] x_bi;
	wire [1:0] busy_o;
	wire [23:0] y_bo;
	reg [3:0] counter;
	reg start_time;
	
	initial begin
		counter <= 0;
		rst_i <= 1;
		x_bi <= 1;
		clk_i <= 1;
		forever
			#10 clk_i <= ~clk_i;
	end
	cube cube1(
		.clk_i(clk_i),
		.rst_i(rst_i),
		.start_i(start_i),
		.busy_o(busy_o),
		.x_bi(x_bi),
		.y_bo(y_bo)
	);
	always @(posedge clk_i) begin
		if (rst_i) begin
			rst_i <= 0;
			start_i <= 1;
			start_time <= 0;
		end else if (start_i==1) begin
			if (start_time==1) begin
				start_i <= 0;
			end else begin
				start_time <= 1;
			end
		end else if (busy_o==0) begin
			$display("cube(%d)=%d",x_bi,y_bo);
			if (counter<10) begin
				counter <= counter+1;
				x_bi <= x_bi+12;
				rst_i <= 1;
			end else begin
				$stop;
			end
		end
	end
endmodule