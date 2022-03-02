`default_nettype none

module abstractFSM(
    output logic [3:0] credit,
    output logic drop,
    output logic q0, q1, q2,
    input logic [1:0] coin,
    input logic clock, reset);
   
    enum logic [2:0] {A0,A1,B1,A2,B2,A3,B3,B0} currState, nextState;

    always_ff @(posedge clock)
        if (reset == 1'b1) currState <= A0;
        else currState <= nextState;

    always_comb begin
        q0 = currState[0];
        q1 = currState[1];
        q2 = currState[2];
       case (currState)
            A0:begin
                case (coin)
                    2'b01: nextState = A1;
                    2'b10: nextState = A3;
                    2'b11: nextState = B1;
                    default: nextState = A0;
                endcase
                credit = 4'b0;
                drop = 1'b0;
            end
            A1:begin
                case (coin)
                    2'b01: nextState = A2;
                    2'b10: nextState = B0;
                    2'b11: nextState = B1;
                    default: nextState = A1;
                endcase
                credit = 4'd1;
                drop = 1'b0;
            end
            B1:begin
                case (coin)
                    2'b01: nextState = A2;
                    2'b10: nextState = B0;
                    2'b11: nextState = B2;
                    default: nextState = A1;
                endcase
                credit = 4'd1;
                drop = 1'b1;
            end
            A2:begin
                case (coin)
                    2'b01: nextState = A3;
                    2'b10: nextState = B1;
                    2'b11: nextState = B3;
                    default: nextState = A2;
                endcase
                credit = 4'd2;
                drop = 1'b0;
            end
            B2:begin
                case (coin)
                    2'b01: nextState = A3;
                    2'b10: nextState = B1;
                    2'b11: nextState = B3;
                    default: nextState = A2;
                endcase
                credit = 4'd2;
                drop = 1'b1;
           end
            A3:begin
                case (coin)
                    2'b01: nextState = B0;
                    2'b10: nextState = B2;
                    2'b11: nextState = B0;
                    default: nextState = A3;
                endcase
                credit = 4'd3;
                drop = 1'b0;
            end
            B3:begin
                case (coin)
                    2'b01: nextState = B0;
                    2'b10: nextState = B2;
                    2'b11: nextState = B0;
                    default: nextState = A3;
                endcase
                credit = 4'd3;
                drop = 1'b1;
            end
            B0:begin
                case (coin)
                    2'b01: nextState = A1;
                    2'b10: nextState = A3;
                    2'b11: nextState = B1;
                    default: nextState = B0;
                endcase
                credit = 1'd0;
                drop = 1'b1;
            end
        endcase
    end
endmodule:abstractFSM