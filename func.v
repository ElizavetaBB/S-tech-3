`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2021 02:11:42 PM
// Design Name: 
// Module Name: func
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


module func(
	input clk_i,
	input rst_i,
	input start_i,
	input [7:0] a_i,
	input [7:0] b_i,
	output busy_o,
	output reg [23:0] y_o 
);
  localparam IDLE = 1'b0, WORK=1'b1;
  wire [1:0] busy_cube, busy_sqrt;
  reg start_cube,start_sqrt,state;
  reg [23:0] part_result;
  wire [23:0] result_cube;
  wire [3:0] result_sqrt;
  reg [7:0] a,b;
  wire done;
  
  cube cube1(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.x_bi(a),
	.start_i(start_cube),
	.busy_o(busy_cube),
	.y_bo(result_cube)
  );
  
  sqrt sqrt1(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.x_i(b),
	.start_i(start_sqrt),
	.busy_o(busy_sqrt),
	.y_o(result_sqrt)
  );
  
  assign busy_o = state;
  assign done = (busy_sqrt==0 && busy_cube==0 && (result_cube!=0 && a!=0 || result_cube==0 && a==0) && (result_sqrt!=0 && b!=0 || result_sqrt==0 && b==0));  
  
  always @(posedge clk_i)
    if (rst_i) begin
      y_o <= 0;
      state <= IDLE;
    end else begin
      case (state)
		IDLE:
			if (start_i) begin
				a <= a_i;
				b <= b_i;
				start_cube <= 1;
				start_sqrt <= 1;
				state <= WORK;
			end
		WORK:
			begin
				if (done) begin
					y_o <= result_cube+result_sqrt;
					state <= IDLE;
				end
			end
	  endcase
    end   
 always @(posedge clk_i) begin
	if (busy_cube) begin
		start_cube <= 0;
	end
 end
 always @(posedge clk_i) begin
	if (busy_sqrt) begin
		start_sqrt <= 0;
	end
 end
endmodule
