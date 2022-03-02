'default_nettype none

module dFlipFlop(
    output logic q,
    input logic d, clock, reset);

    always_ff @(posedge clock)
        if (reset == 1'b1) q <= 0;
        else q <= d;
    end

endmodule:dFlipFlop

module explicitFSM(
    output logic [3:0] credit,
    output logic drop,
    output logic q0, q1, q2,
    input logic [1:0] coin,
    input logic clock, reset);

    logic d0, d1, d2;

    dFlipFlop ff0(.d(d0),.q(q0),.*),
              ff1(.d(d1),.q(q1),.*),
              ff2(.d(d2),.q(q2),.*);

    assign d2 = ~q2&(~q1&coin[1]&~coin[0]|q1&q0&coin[0]|q1&~q0&coin[1])|
                q2&(q1^q0&coin[1]&coin[0]|~q1&coin[0]|(q1|q0)&coin[1]&~coin[0]|q1&~q0&coin[0]);
    assign d1 = ~q2&(q1&q0&~coin[1]&~coin[0]|q1&~q0&~coin[1]&coin[0]|~q1&~q0&coin[1]&coin[0]|
                    ~q1&q0&~coin[1]&coin[0]|q0&coin[1]|q1&coin[1]&~coin[0])|
                q2&(~q1&~q0&~coin[1]&~coin[0]|q1&~q0&~coin[1]&coin[0]|ocin[1]&coin[0]|
                    ~q1&q0&coin[1]&~coin[0]);
    assign d0 = ~q2&(q0&~coin[1]|q1&~coin[1]|~q1&~coin[1]&coin[0]|~q1&coin[1]&~coin[0]|
                    q1&~q0&coin[1]&~coin[0])|
                q2&(~q1&~coin[1]|q1&~q0&~coin[1]|q1&~coin[1]&coin[0]|~q1&q0&coin[1]&coin[0]|
                    q1&~q0&coin[1]&coin[0]|q1&q0&coin[1]&~coin[0]);

    assign drop = ~q2&q1&~q0|q2&~q1&~q0|q2&q1&~q0|q2&q1&q0;
    assign credit[3] = 0;
    assign credit[2] = 0;
    assign credit[1] = q2^q1|q2&q1&~q0
    assign credit[0] = q1^q0;

endmodule: explicitFSM

module abstractFSM(
    output logic [3:0] credit,
    output logic drop,
    output logic q0, q1, q2,
    input logic [1:0] coin,
    input logic click, reset);

    enum logic [2:0] {A0,A1,B1,A2,B2,A3,B3,B0} currState, nextState;

    always_comb begin
        unique case (currState)
            A0:begin
                unique case (coin)
                    2'b01: nextState = A1;
                    2'b10: nextState = A3;
                    2'b11: nextState = B1;
                    default: nextState = A0;
                endcase
            end
            A1:begin
                unique case (coin)
                    2'b01: nextState = A2;
                    2'b10: nextState = B0;
                    2'b11: nextState = B1;
                    default: nextState = A1;
                endcase
            end
            B1:begin
                unique case (coin)
                    2'b01: nextState = A2;
                    2'b10: nextState = B0;
                    2'b11: nextState = B2;
                    default: nextState = A1;
                endcase
            end
            A2:begin
                unique case (coin)
                    2'b01: nextState = A3;
                    2'b10: nextState = B1;
                    2'b11: nextState = B3;
                    default: nextState = A2;
                endcase
            end
            B2:begin
                unique case (coin)
                    2'b01: nextState = A3;
                    2'b10: nextState = B1;
                    2'b11: nextState = B3;
                    default: nextState = A2;
                endcase
            end
            A3:begin
                unique case (coin)
                    2'b01: nextState = B0;
                    2'b10: nextState = B2;
                    2'b11: nextState = B0;
                    default: nextState = A3;
                endcase
            end
            B3:begin
                unique case (coin)
                    2'b01: nextState = B0;
                    2'b10: nextState = B2;
                    2'b11: nextState = B0;
                    default: nextState = A3;
                endcase
            end
            B0:begin
                unique case (coin)
                    2'b01: nextState = A1;
                    2'b10: nextState = A3;
                    2'b11: nextState = B1;
                    default: nextState = B0;
                endcase
            end
        endcase
    end
endmodule:abstractFSM
