`default_nettype none

module abstractChipInterface(
  input logic KEY0,
  input logic [5:0] SW,
  output logic [7:0] LEDG,
  output logic [6:0] HEX0);
  
  logic clock,reset,drop,q0,q1,q2;
  logic [3:0] credit;
  logic [1:0] coin;
  
  always_comb begin
    coin[1:0] = SW[1:0];
    clock = KEY0;
    reset = SW[5];
    if(drop) LEDG[7:0] = 8'b1111_1111;
    else LEDG[7:0] = 8'b0000_0000;
  end
  
  abstractFSM testFSM(.*);
  
  logic [3:0] BCD7, BCD6, BCD5, BCD4, BCD3, BCD2, BCD1, BCD0;
  logic [7:0] blank;
  logic [6:0] HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1;
  
  always_comb begin
    blank[7:1] = 7'b111_1111;
    blank[0] = 1'b0;
    BCD7 = 4'd0;
    BCD6 = 4'd0;
    BCD5 = 4'd0;
    BCD4 = 4'd0;
    BCD3 = 4'd0;
    BCD2 = 4'd0;
    BCD1 = 4'd0;
    BCD0 = credit;
  end
  
  SevenSegmentDisplay ssd(.*);
  
endmodule:abstractChipInterface
