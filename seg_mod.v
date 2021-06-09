`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Gunnar Pederson
// 
// Create Date: 06/09/2021 11:51:59 AM
// Design Name: 
// Module Name: seg_mod
// Project Name: 7 segment controller
// Target Devices: RealDigital Blackboard
// Tool Versions: Vivado 2020.2
// Description: module to control the 4 7-segment displays of the BlackBoard with 4 4-bit inputs
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module seg_mod(
    input clk_in,
    input [3:0]I0,                  //digit inputs
    input [3:0]I1,
    input [3:0]I2,
    input [3:0]I3,
    output [3:0]an,                 //segment anodes
    output [7:0]cat                 //segment cathodes
    );
    
wire [1:0]select;
wire clk_slow;
wire [3:0]mux_out;

clk_div divider(
    .clk_in(clk_in),
    .clk_out(clk_slow)
    );
    
counter2_bit counter (
    .clk_in(clk_slow),
    .S(select)
    );

decoder2_4 decoder (
    .S(select),
    .Y(an)
    );

mux4_1 mux (
    .I0(I0),
    .I1(I1),
    .I2(I2),
    .I3(I3),
    .S(select),
    .Y(mux_out)
    );

decoder_7seg decoder1 (
    .I(mux_out),
    .seg(cat)
    );

endmodule


//2-bit counter cylces through select inputs
module counter2_bit (
    input clk_in,                   //input clk
    output reg [1:0]S = 2'b00       //select output
    );

always @ (posedge clk_in)
    S <= S + 1;                     //incriment S

endmodule 


//decoder will select witch 7 segment annode is acctive
module decoder2_4 (
    input [1:0]S,                   //select input
    output reg [3:0]Y                   //output
    );

always @ (S) begin
    case (S)
        2'b01: Y <= 4'b1101;
        2'b10: Y <= 4'b1011;
        2'b11: Y <= 4'b0111;
        default: Y <= 4'b1110;
    endcase
end

endmodule 

//4-bit 4:1 mux
module mux4_1 (
    input [3:0]I0,                          //inputs
    input [3:0]I1,
    input [3:0]I2,
    input [3:0]I3,
    input [1:0]S,                           //select
    output reg [3:0]Y                           //output
    );
    
    
always @ (S) begin
    case (S)
        2'b01: Y <= I1;
        2'b10: Y <= I2;
        2'b11: Y <= I3;
        default: Y <= I0;
    endcase
end

endmodule 

module decoder_7seg (
    input [3:0]I,
    output reg [7:0]seg
    );

always @ (I) begin
    case (I)
        4'b0000: seg <= 8'b11000000;        //0
        4'b0001: seg <= 8'b11111001;        //1
        4'b0010: seg <= 8'b10100100;        //2
        4'b0011: seg <= 8'b10110000;        //3
        4'b0100: seg <= 8'b10011001;        //4
        4'b0101: seg <= 8'b10010010;        //5
        4'b0110: seg <= 8'b10000010;        //6
        4'b0111: seg <= 8'b11111000;        //7
        4'b1000: seg <= 8'b10000000;        //8
        4'b1001: seg <= 8'b10010000;        //9
        4'b1010: seg <= 8'b10001000;        //A
        4'b1011: seg <= 8'b10000011;        //B
        4'b1100: seg <= 8'b11000110;        //C
        4'b1101: seg <= 8'b10100001;        //D
        4'b1110: seg <= 8'b10000110;        //E
        4'b1111: seg <= 8'b10001110;        //F
        default: seg <= 8'b11111111;        //Default no display
    endcase
end

endmodule 

module clk_div(
    input clk_in,
    output reg clk_out = 1'b0
    );

reg [14:0]count = 14'b0;

always @ (posedge clk_in) begin
    if (count == 14'd9999) begin
        count <= 14'b0;
        clk_out <= ~clk_out;
    end
    else if (count == 14'd4999) begin
        count <= count + 1;
        clk_out <= ~clk_out;
    end
    else
        count <= count + 1;
end
endmodule 