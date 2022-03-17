`default_nettype none

module abstractFSM(
    output logic [3:0] credit,
    output logic [1:0] drop,
    input logic [1:0] coin,
    input logic clock, reset);

    enum logic [4:0] {N0G,N1G,D1G,N2G,D2G,N3G,D3G,D0G,N0H,N1H,D1H,N2H,D2H,N3H,D3H,D0H,D0H2} currState, nextState;
    enum logic [1:0] {two = 2'b10,one = 2'b01,zero = 2'b00} dropState, nextDrop;
    enum logic [1:0] {nickel = 2'b11, thrupence = 2'b10, pence = 2'b01, none = 2'b00} coinState, nextCoin;

    always_ff @(posedge clock) begin
        if (reset == 1'b1) begin
            currState <= N0G;
            dropState <= zero;
            coinState <= none;
        end
        else begin
            currState <= nextState;
            dropState <= nextDrop;
            coinState <= nextCoin;
        end
	end

    always_latch begin
		if(reset == 1'b1) begin
			drop = 2'b00;
			nextDrop = zero;
			nextCoin = none;
		end
		else begin
        drop[1] = dropState[1];
        drop[0] = dropState[0];
            case (coin)
                2'b11: nextCoin = nickel;
                2'b10: nextCoin = thrupence;
                2'b01: nextCoin = pence;
                default: nextCoin = none;
            endcase
            case (currState)
                N0G:begin
                    case (coin)
                        2'b01: begin 
                            nextState = N1H;
                            nextDrop = zero;
                        2'b10: begin 
                            nextState = N3H;
                            nextDrop = zero;
                        2'b11: begin 
                            nextState = D1H;
                            nextDrop = one;
                        end
                        default: begin 
                            nextState = N0H;
                            nextDrop = zero;
                    endcase
                    credit = 4'b0;
                end
                N1G:begin
                    case (coin)
                        2'b01: begin 
                            nextState = N2H;
                            nextDrop = zero;
                        2'b10: begin 
                            nextState = D0H;
                            nextDrop = one;
                        end
                        2'b11: begin 
                            nextState = D1H;
                            nextDrop = one;
                        end
                        default: begin 
                            nextState = N1H;
                            nextDrop = zero;
                    endcase
                    credit = 4'd1;
                end
                D1G:begin
                    case (coin)
                        2'b01: begin 
                            nextState = N2H;
                            nextDrop = zero;
                        2'b10: begin 
                            nextState = D0H;
                            nextDrop = one;
                        end
                        2'b11: begin 
                            nextState = D2H;
                            nextDrop = one;
                        end
                        default: begin 
                            nextState = N1H;
                            nextDrop = zero;
                    endcase
                    credit = 4'd1;
                end
                N2G:begin
                    case (coin)
                        2'b01: begin 
                            nextState = N3H;
                            nextDrop = zero;
                        2'b10: begin 
                            nextState = D1H;
                            nextDrop = one;
                        end
                        2'b11: begin 
                            nextState = D3H;
                            nextDrop = one;
                        end
                        default: begin 
                            nextState = N2H;
                            nextDrop = zero;
                    endcase
                    credit = 4'd2;
                end
                D2G:begin
                    case (coin)
                        2'b01: begin 
                            nextState = N3H;
                            nextDrop = zero;
                        2'b10: begin 
                            nextState = D1H;
                            nextDrop = one;
                        end
                        2'b11: begin 
                            nextState = D3H;
                            nextDrop = one;
                        end
                        default: begin 
                            nextState = N2H;
                            nextDrop = zero;
                    endcase
                    credit = 4'd2;
                end
                N3G:begin
                    case (coin)
                        2'b01: begin 
                            nextState = D0H;
                            nextDrop = one;
                        end
                        2'b10: begin 
                            nextState = D2H;
                            nextDrop = one;
                        end
                        2'b11: begin 
                        nextState = D0H2;
                        nextDrop = two;
                    end
                        default: begin 
                            nextState = N3H;
                            nextDrop = zero;
                    endcase
                    credit = 4'd3;
                end
                D3G:begin
                    case (coin)
                        2'b01: begin 
                            nextState = D0H;
                            nextDrop = one;
                        end
                        2'b10: begin 
                            nextState = D2H;
                            nextDrop = one;
                        end
                        2'b11: begin 
                        nextState = D0H2;
                        nextDrop = two;
                    end
                        default: begin 
                            nextState = N3H;
                            nextDrop = zero;
                    endcase
                    credit = 4'd3;
                end
                D0G:begin
                    case (coin)
                        2'b01: begin 
                            nextState = N1H;
                            nextDrop = zero;
                        2'b10: begin 
                            nextState = N3H;
                            nextDrop = zero;
                        2'b11: begin 
                            nextState = D1H;
                            nextDrop = one;
                        end
                        default: begin 
                            nextState = N0H;
                            nextDrop = zero;
                    endcase
                    credit = 4'd0;
                end
                N0H:begin
                    if (coin == coinState) nextState = currState;
                    else nextState = N0G;
                    credit = 4'd0;
                end
                N1H:begin
                    if (coin == coinState) nextState = currState;
                    else nextState = N1G;
                    credit = 4'd1;
                end
                D1H:begin
                    if (coin == coinState) nextState = currState;
                    else nextState = D1G;
                    credit = 4'd1;
                end
                N2H:begin
                    if (coin == coinState) nextState = currState;
                    else nextState = N2G;
                    credit = 4'd2;
                end
                D2H:begin
                    if (coin == coinState) nextState = currState;
                    else nextState = D2G;
                    credit = 4'd2;
                end
                N3H:begin
                    if (coin == coinState) nextState = currState;
                    else nextState = N3G;
                    credit = 4'd3;
                end
                D3H:begin
                    if (coin == coinState) nextState = currState;
                    else nextState = D3G;
                    credit = 4'd3;
                end
                D0H:begin
                    if (coin == coinState) nextState = currState;
                    else nextState = D0G;
                    credit = 4'd0;
                end
                D0H2:begin
                    if (coin == coinState) nextState = currState;
                    else nextState = D0G;
                    credit = 4'd0;
                end
            endcase
		end
    end

endmodule:abstractFSM
