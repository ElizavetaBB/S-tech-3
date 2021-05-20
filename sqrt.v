`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2021 01:46:39 PM
// Design Name: 
// Module Name: cube
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


module sqrt(
  input clk_i,
  input rst_i,
  input start_i,
  input [7:0] x_i,
  output [1:0] busy_o,
  output reg [3:0] y_o 
);
  localparam IDLE = 2'b00, Y_WORK = 2'b01, X_WORK = 2'b10;
  reg [6:0] m,y,b;
  reg [7:0] x;
  wire x_above_b,end_step;
  reg [1:0] state;
  
  assign busy_o=state;
  assign x_above_b=(x>=b);
  assign end_step=(m==0);
  
  always @(posedge clk_i)
    if (rst_i) begin
      y_o <= 0;
      state <= IDLE;
    end else begin
      case (state)
		IDLE:
			if (start_i) begin
				x <= x_i;
				m <= 7'b1000000;
				y <= 0;
				state <= Y_WORK;
			end
		Y_WORK:
			if (!end_step) begin
				b <= y|m;
				y <= y>>1;
				state <= X_WORK;
			end else begin
				y_o <= y;
				state <= IDLE;
			end
		X_WORK:
			begin
				if (x_above_b) begin
					x <= x-b;
					y <= y|m;
				end
				m <= m>>2;
				state <= Y_WORK;
			end
	  endcase
    end   
endmodule
