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
