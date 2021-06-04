`timescale 1ns / 1ps

module func(
	input clk_i,
	input rst_i,
	input start_i,
	input [7:0] a_i,
	input [7:0] b_i,
	input change_mode,
	output [1:0] busy_o,
	//output reg [23:0] y_o 
	output [15:0] y_o
);
  localparam IDLE = 2'b00, WORK=2'b10, UNSET_START=2'b01;
  wire [1:0] busy_cube, busy_sqrt;
  reg start_cube,start_sqrt;
  reg [1:0] state;
  reg [23:0] part_result;
  reg mode=1'b0;
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
  assign y_o[7:0]=mode? part_result[23:16]:part_result[7:0];
  assign y_o[15:8]=mode? 0:part_result[15:8];
  
  always @(posedge clk_i) begin
    if (change_mode) mode=~mode;
    if (rst_i) begin
      part_result <= 0;
      state <= IDLE;
    end else begin
      case (state)
		IDLE:
			if (start_i) begin
			    part_result <= 0;
				a <= a_i;
				b <= b_i;
				start_cube <= 1;
				start_sqrt <= 1;
				state <= UNSET_START;
				//$display("state=%d",state);
			end
	    UNSET_START:
	       begin
	           if (busy_cube) begin
	               start_cube <= 0;
	             //  $display("start_cube=%d",start_cube);
	           end
	           if (busy_sqrt) begin
	               start_sqrt <= 0;
	              // $display("start_sqrt=%d",start_sqrt);
	           end
	           if (start_cube==0 && start_sqrt==0) begin
	               state <= WORK;
	           end
	           //$display("busy_cube=%d; busy_sqrt=%d; start_cube=%d; start_sqrt=%d",busy_cube,busy_sqrt,start_cube,start_sqrt);
	       end
		WORK:
			begin
				if (done) begin
					part_result <= result_cube+result_sqrt;
					state <= IDLE;
				end
			end
	  endcase
      end
    end
    
   // always @(posedge clk_i) begin
      //  if (busy_cube) begin
        //    start_cube <= 0;
        //end
        //if (busy_sqrt) begin
          //  start_sqrt <= 0;
        //end
    //end
endmodule