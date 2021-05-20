`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2021 02:02:29 PM
// Design Name: 
// Module Name: sqrt_tb
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


module sqrt_tb;
	reg clk_i, rst_i, start_i;
	reg [7:0] x_i;
	wire [1:0] busy_o;
	wire [3:0] y_o;
	reg [3:0] counter;
	reg start_time;
	
	sqrt sqrt1(
		.clk_i(clk_i),
		.rst_i(rst_i),
		.start_i(start_i),
		.x_i(x_i),
		.busy_o(busy_o),
		.y_o(y_o)
	);
	initial begin
		counter <= 0;
		rst_i <= 1;
		x_i <= 1;
		clk_i <= 1;
		forever
			#10 clk_i <= ~clk_i;
	end
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
			$display("sqrt(%d)=%d",x_i,y_o);
			if (counter<10) begin
				counter <= counter+1;
				x_i <= x_i+12;
				rst_i <= 1;
			end else begin
				$stop;
			end
		end
	end
endmodule
