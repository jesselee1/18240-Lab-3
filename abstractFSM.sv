`default_nettype none

module abstractFSM(
    output logic [3:0] credit,
    output logic drop,
    output logic q0, q1, q2,
    input logic [1:0] coin,
    input logic clock, reset);

    enum logic [2:0] {A0,A1,B1,A2,B2,A3,B3,B0} currState, nextState;
    
    always_ff @ (posedge clock)
        currState <= nextState;
        q0 = currState[0];
        q1 = currState[1];
        q2 = currState[2];
        case (currState)
            A0: begin
                drop = 1'b0;
                credit = 4'd0;
            end
            A1: begin
                drop = 1'b0;
                credit = 4'd1;
            end
            B1: begin
                drop = 1'b1;
                credit = 4'd1;
            end
            A2: begin
                drop = 1'b0;
                credit = 4'd2;
            end
            B2: begin
                drop = 1'b1;
                credit = 4'd2;
            end
            A3: begin
                drop = 1'b0;
                credit = 4'd3;
            end
            B3: begin
                drop = 1'b1;
                credit = 4'd3;
            end
            B0: begin
                drop = 1'b1;
                credit = 4'd0;
            end
        endcase

    always_comb begin
        case (currState)
            A0:begin
                case (coin)
                    2'b01: nextState = A1;
                    2'b10: nextState = A3;
                    2'b11: nextState = B1;
                    default: nextState = A0;
                endcase
            end
            A1:begin
                case (coin)
                    2'b01: nextState = A2;
                    2'b10: nextState = B0;
                    2'b11: nextState = B1;
                    default: nextState = A1;
                endcase
            end
            B1:begin
                case (coin)
                    2'b01: nextState = A2;
                    2'b10: nextState = B0;
                    2'b11: nextState = B2;
                    default: nextState = A1;
                endcase
            end
            A2:begin
                case (coin)
                    2'b01: nextState = A3;
                    2'b10: nextState = B1;
                    2'b11: nextState = B3;
                    default: nextState = A2;
                endcase
            end
            B2:begin
                case (coin)
                    2'b01: nextState = A3;
                    2'b10: nextState = B1;
                    2'b11: nextState = B3;
                    default: nextState = A2;
                endcase
            end
            A3:begin
                case (coin)
                    2'b01: nextState = B0;
                    2'b10: nextState = B2;
                    2'b11: nextState = B0;
                    default: nextState = A3;
                endcase
            end
            B3:begin
                case (coin)
                    2'b01: nextState = B0;
                    2'b10: nextState = B2;
                    2'b11: nextState = B0;
                    default: nextState = A3;
                endcase
            end
            B0:begin
                case (coin)
                    2'b01: nextState = A1;
                    2'b10: nextState = A3;
                    2'b11: nextState = B1;
                    default: nextState = B0;
                endcase
            end
        endcase
    end
endmodule:abstractFSM
