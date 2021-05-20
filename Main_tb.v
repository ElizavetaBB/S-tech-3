`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.05.2021 14:24:01
// Design Name: 
// Module Name: Main_tb
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


module Main_tb;
    reg clk,rst,start;
    reg [7:0] a,b;
    wire busy, dots;
    wire [6:0] segments;
    wire [7:0] an;
    Main main1(
        clk,
        rst,
        start,
        a,
        b,
        busy,
        segments,
        dots,
        an 
    );
	initial begin
		rst <= 1;
		a <= 0;
		b <= 0;
	end
	initial begin
		clk <= 1;
		forever
			#10 clk <= ~clk;
	end
	always @(posedge clk) begin
		if (rst) begin
			rst <= 0;
			start <= 1;
		end else if (!busy && start==0) begin
			if (!rst && a<241) begin
				a <= a+15;
				b <= b+15;
				rst <= 1;
			end else begin
				$stop;
			end
		end else begin
			start <= 0;
		end
	end
endmodule
