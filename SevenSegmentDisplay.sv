
`default_nettype none

module SevenSegmentDisplay
  (input  logic [3:0] BCD7, BCD6, BCD5, BCD4, BCD3, BCD2, BCD1, BCD0,
   input  logic [7:0] blank,
   output logic [6:0] HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);

  logic [6:0] seg7, seg6, seg5, seg4, seg3, seg2, seg1, seg0;
  logic [6:0] inv7, inv6, inv5, inv4, inv3, inv2, inv1, inv0;

  assign HEX7 = ~inv7;
  assign HEX6 = ~inv6;
  assign HEX5 = ~inv5;
  assign HEX4 = ~inv4;
  assign HEX3 = ~inv3;
  assign HEX2 = ~inv2;
  assign HEX1 = ~inv1;
  assign HEX0 = ~inv0;

  BCDtoSevenSegment bss7(.bcd(BCD7), .segment(seg7));
  BCDtoSevenSegment bss6(.bcd(BCD6), .segment(seg6));
  BCDtoSevenSegment bss5(.bcd(BCD5), .segment(seg5));
  BCDtoSevenSegment bss4(.bcd(BCD4), .segment(seg4));
  BCDtoSevenSegment bss3(.bcd(BCD3), .segment(seg3));
  BCDtoSevenSegment bss2(.bcd(BCD2), .segment(seg2));
  BCDtoSevenSegment bss1(.bcd(BCD1), .segment(seg1));
  BCDtoSevenSegment bss0(.bcd(BCD0), .segment(seg0));

  Mux2to1 mux7(.I1(7'b000_0000), .I0(seg7), .Y(inv7), .S(blank[7]));
  Mux2to1 mux6(.I1(7'b000_0000), .I0(seg6), .Y(inv6), .S(blank[6]));
  Mux2to1 mux5(.I1(7'b000_0000), .I0(seg5), .Y(inv5), .S(blank[5]));
  Mux2to1 mux4(.I1(7'b000_0000), .I0(seg4), .Y(inv4), .S(blank[4]));
  Mux2to1 mux3(.I1(7'b000_0000), .I0(seg3), .Y(inv3), .S(blank[3]));
  Mux2to1 mux2(.I1(7'b000_0000), .I0(seg2), .Y(inv2), .S(blank[2]));
  Mux2to1 mux1(.I1(7'b000_0000), .I0(seg1), .Y(inv1), .S(blank[1]));
  Mux2to1 mux0(.I1(7'b000_0000), .I0(seg0), .Y(inv0), .S(blank[0]));

endmodule : SevenSegmentDisplay

module BCDtoSevenSegment
  (input  logic [3:0] bcd,
   output logic [6:0] segment);

  always_comb
    unique case (bcd)
      4'd0: segment = 7'b011_1111;
      4'd1: segment = 7'b000_0110;
      4'd2: segment = 7'b101_1011;
      4'd3: segment = 7'b100_1111;
      4'd4: segment = 7'b110_0110;
      4'd5: segment = 7'b110_1101;
      4'd6: segment = 7'b111_1101;
      4'd7: segment = 7'b000_0111;
      4'd8: segment = 7'b111_1111;
      4'd9: segment = 7'b110_0111;
    endcase

endmodule : BCDtoSevenSegment

module Mux2to1(
    input logic S,
    input logic [6:0] I0, I1,
    output logic [6:0] Y);

    assign Y = (S) ? I1:I0;

endmodule: Mux2to1
~                                                                                                                                  
~                             
