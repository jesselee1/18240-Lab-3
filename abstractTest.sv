`default_nettype none

module myFSM_test;
    logic  [3:0]  credit;
    logic         drop;
    logic         q2, q1, q0;
    logic [1:0]  coin;
    logic        clock, reset;

    abstractFSM T (.*);
    
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

    initial begin
        $monitor($time,, "state=%s, credit=%d, coin=%d, drop=%b",
            T.currState.name, credit, coin, drop);
    end

    enum logic [2:0] {A0,A1,B1,A2,B2,A3,B3,B0} currState, nextState;

    initial begin
        // initialize values
        reset <= 1'b1; 
        @(posedge clock);
        reset <= 1'b0; 
        
        coin <= 2'b00;
        @(posedge clock); 
        
        //From change = 1 all possible cases
        reset <= 1'b1; 
        @(posedge clock);
        reset <= 1'b0; 

        coin <= 2'b01; 
        @(posedge clock); // begin cycle 1
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock); //1A

        //3 loop
        reset <= 1'b1; 
        @(posedge clock);
        reset <= 1'b0;
        
        coin <= 2'b10; //At 1A
        @(posedge clock); // begin cycle 2
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock); //3A

        //5 loop
        reset <= 1'b1; 
        @(posedge clock);
        reset <= 1'b0;
        
        coin <= 2'b11; 
        @(posedge clock); 
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock); 

        //1A - 3
        reset <= 1'b1; 
        @(posedge clock);
        reset <= 1'b0;

        coin <= 2'b01;
        @(posedge clock); 
        coin <= 2'b10;
        @(posedge clock);

        //1A - 5
        reset <= 1'b1; 
        @(posedge clock);
        reset <= 1'b0;

        coin <= 2'b01;
        @(posedge clock); 
        coin <= 2'b11;
        @(posedge clock);

        //1B - 0
        reset <= 1'b1; 
        @(posedge clock);
        reset <= 1'b0;

        coin <= 2'b11;
        @(posedge clock); 
        coin <= 2'b00;
        @(posedge clock);
        @(posedge clock);

        //1B - 1
        reset <= 1'b1; 
        @(posedge clock);
        reset <= 1'b0;

        coin <= 2'b11;
        @(posedge clock); 
        coin <= 2'b01;
        @(posedge clock);
        @(posedge clock);

        //2A - 0,3
        reset <= 1'b1; 
        @(posedge clock);
        reset <= 1'b0;

        coin <= 2'b01;
        @(posedge clock);
        @(posedge clock); 
        coin <= 2'b00;
        @(posedge clock);
        coin <= 2'b10;
        @(posedge clock);

        //2A - 5
        reset <= 1'b1; 
        @(posedge clock);
        reset <= 1'b0;

        coin <= 2'b01;
        @(posedge clock);
        @(posedge clock); 
        coin <= 2'b11;
        @(posedge clock);

        //2B - 0
        reset <= 1'b1; 
        @(posedge clock);
        reset <= 1'b0;

        coin <= 2'b11;
        @(posedge clock);
        @(posedge clock); 
        coin <= 2'b00;
        @(posedge clock);

        //2B - 1
        reset <= 1'b1; 
        @(posedge clock);
        reset <= 1'b0;

        coin <= 2'b11;
        @(posedge clock);
        @(posedge clock); 
        coin <= 2'b01;
        @(posedge clock);

        //3A - 0,3
        reset <= 1'b1; 
        @(posedge clock);
        reset <= 1'b0;

        coin <= 2'b10;
        @(posedge clock); 
        coin <= 2'b00;
        @(posedge clock);
        coin <= 2'b11;
        @(posedge clock);

        //3B - 0
        reset <= 1'b1; 
        @(posedge clock);
        reset <= 1'b0;

        coin <= 2'b11;
        @(posedge clock);
        @(posedge clock);
        @(posedge clock); 
        coin <= 2'b00;
        @(posedge clock);

        //3B - 1
        reset <= 1'b1; 
        @(posedge clock);
        reset <= 1'b0;

        coin <= 2'b11;
        @(posedge clock);
        @(posedge clock);
        @(posedge clock); 
        coin <= 2'b01;
        @(posedge clock);

        //3B - 3
        reset <= 1'b1; 
        @(posedge clock);
        reset <= 1'b0;

        coin <= 2'b11;
        @(posedge clock);
        @(posedge clock);
        @(posedge clock); 
        coin <= 2'b10;
        @(posedge clock);

        //4 - 0
        reset <= 1'b1; 
        @(posedge clock);
        reset <= 1'b0;

        coin <= 2'b01;
        @(posedge clock);
        coin <= 2'b10;
        @(posedge clock); 
        coin <= 2'b00;
        @(posedge clock);

        #10 $finish;
    end
endmodule: myFSM_test
