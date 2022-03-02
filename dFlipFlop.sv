`default_nettype none

module dFlipFlop
  (output logic q,
   input logic d, clock, reset);
  
  always_ff @(posedge clock)
    if(reset == 1'b1) q<= 0;
    else q <= d;
endmodule: dFlipFlop
