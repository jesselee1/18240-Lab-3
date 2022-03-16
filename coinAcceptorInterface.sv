`default_nettype none

module coinAccepterInterface (
    input logic CLOCK_50,
    input logic [3:0] KEY,
    input logic [5:0] SW,
    output logic [7:0] LEDG,
    output logic [6:0] HEX0, HEX1, HEX2);

    logic clock, reset;
    logic [3:0] credit;
    logic [1:0] coin, drop;

    always_comb begin
        clock = CLOCK_50;
    end

    always_comb begin
        reset = SW [5];
    end

    always_comb begin
        unique case ({KEY [2], KEY [1], KEY [0]})
            3'b011: coin = 2'b11;
            3'b101: coin = 2'b10;
            3'b110: coin = 2'b01;
            default: coin = 2'b00;
        endcase
	end

    abstractFSM fsm(.*);

	 logic [3:0] BCD7, BCD6, BCD5, BCD4, BCD3, BCD2, BCD1, BCD0;
    logic [7:0] blank;
    logic [6:0] HEX7, HEX6, HEX5, HEX4, HEX3;

	 always_comb begin
		if (drop != 2'b00) LEDG = 8'b1111_1111;
		else LEDG = 8'b0000_0000;
	 end
	 
    always_comb begin
        blank[7:3] = 5'b11_111;
        blank[2:0] = 3'b000;
        BCD7 = 4'd0;
        BCD6 = 4'd0;
        BCD5 = 4'd0;
        BCD4 = 4'd0;
        BCD3 = 4'd0;
        case (drop)
				2'b10: BCD2 = 4'd2;
				2'b01: BCD2 = 4'd1;
				default: BCD2 = 4'd0;
		  endcase
        case (coin)
            2'b01: BCD1 = 4'd1;
            2'b10: BCD1 = 4'd3;
            2'b11: BCD1 = 4'd5;
            default: BCD1 = 4'd0;
		  endcase
        BCD0 = credit;
    end

    SevenSegmentDisplay ssd(.*);

endmodule: coinAccepterInterface
