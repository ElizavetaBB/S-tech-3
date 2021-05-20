`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.05.2021 14:12:51
// Design Name: 
// Module Name: Main
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


module Main(
    input clk,
	input rst,
	input start,
	input [7:0] a,
	input [7:0] b,
	output wire busy,
	output [6:0] segment,
	output dots,
	output [7:0] an 
    );
    wire [23:0] y;
    func func1(
        clk,
	    rst,
	    start,
	    a,
	    b,
        busy,
        y 
    );
    
    M_Nexys4_DISP display(
        clk,
        rst,
        y,
        segment[0],
        segment[1],
        segment[2],
        segment[3],
        segment[4],
        segment[5],
        segment[6],
        dots,
        an,
        8'h11
    );
endmodule
