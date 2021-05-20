`timescale 1ns / 1ps
//////////////////////////////////////////////
// Engineer: FPGA-Mechanic
//
// Design Name: Prototype Project
// Module Name: M_Nexys4_DISP
// Project Name: MCH_Nexys4_Test
// Target Devices: XC7A100 FPGA / Nexys4 Digilent Board
// Tool versions: Xilinx DS 14.4
// Description: 7-Segment Display Signal Generator
//
//////////////////////////////////////////////
module M_Nexys4_DISP(
    input CLK,
    input RST,
    input [23:0] HEX_IN,
    output CA,
    output CB,
    output CC,
    output CD,
    output CE,
    output CF,
    output CG,
    output reg DP,
    output [7:0] AN,
    input [7:0] DP_IN
    );
// Internal signals declaration:
//------------------------------------------
 reg CEO_DIV_H, CEO_DIV_L;
 reg [2:0] DIGIT_CNT;
 reg [3:0] I_CODE;
 wire O_SEG_A, O_SEG_B, O_SEG_C, O_SEG_D, O_SEG_E, O_SEG_F, O_SEG_G;
 reg [7:0] ANODE_DC;
 
 reg [19:0] clk_counter = 'b0;
 reg [19:0] MAX_clk_counter = 20'd400000;

//------------------------------------------
// Display Digit Counter:
 always @ (posedge CLK) begin
    if(RST) begin 
        DIGIT_CNT <= 'b0;
        clk_counter <= 'b0;
    end    
    else if(clk_counter == MAX_clk_counter) begin
        DIGIT_CNT <= ((DIGIT_CNT + 1'b1) == 3'b110) ? 2'b00 : (DIGIT_CNT + 1'b1);
        clk_counter <= 'b0;
    end else begin
        clk_counter <= clk_counter + 1'b1;
    end
end
//------------------------------------------
// Display Digit Multiplexer:
 always @ (DIGIT_CNT)
    case(DIGIT_CNT)
        3'b000:
           begin
               I_CODE = HEX_IN[3:0];
               DP = ~DP_IN[0];
               ANODE_DC = 8'd1;
           end
        3'b001:
           begin
               I_CODE = HEX_IN[7:4];
               DP = ~DP_IN[1];
               ANODE_DC = 8'd2;
           end
        3'b010:
           begin
               I_CODE = HEX_IN[11:8];
               DP = ~DP_IN[2];
               ANODE_DC = 8'd4;
           end
        3'b011:
           begin
               I_CODE = HEX_IN[15:12];
               DP = ~DP_IN[3];
               ANODE_DC = 8'd8;
           end
		3'b100:
			begin
				I_CODE = HEX_IN[19:16];
				DP = ~DP_IN[4];
				ANODE_DC = 8'd16;
			end
		3'b101:
			begin
				I_CODE = HEX_IN[23:20];
               DP = ~DP_IN[5];
               ANODE_DC = 8'd32;
			end
        default: 
            begin
               I_CODE = 0;
               DP = 1'b1;
               ANODE_DC = 8'b11111111;
            end
        endcase
//------------------------------------------
// 7-Segment Decoder:
 M_7SEG_DECODER_V10 DISP_DEC (
    .I_CODE(I_CODE),
    .O_SEG_A(O_SEG_A),
    .O_SEG_B(O_SEG_B),
    .O_SEG_C(O_SEG_C),
    .O_SEG_D(O_SEG_D),
    .O_SEG_E(O_SEG_E),
    .O_SEG_F(O_SEG_F),
    .O_SEG_G(O_SEG_G)
);
//------------------------------------------
 assign AN = ~ANODE_DC | {8{RST}};
 assign CA = ~O_SEG_A;
 assign CB = ~O_SEG_B;
 assign CC = ~O_SEG_C;
 assign CD = ~O_SEG_D;
 assign CE = ~O_SEG_E;
 assign CF = ~O_SEG_F;
 assign CG = ~O_SEG_G;
//------------------------------------------
endmodule