module top_module ();
    reg clk=0;
    always #5 clk = ~clk;  // Create clock with period=10

	// A testbench
    reg [5:0] g1 = 1; reg [5:0] g2 = 4; reg [5:0] g3 = 22; reg [5:0] g4 = 13; reg [5:0] g5 = 49;
    reg [5:0] g6 = 16; reg [5:0] g7 = 7; reg [5:0] g8 = 42; reg [5:0] g9 = 33; reg [5:0] g10 = 31;
    initial begin
        $display ("Hello world! The current time is ( ps)", $time);
	#50 $finish;            // Quit the simulation
    end
    
    wire [0:0] win;
    wire [0:0] tie; 
    poker game (.a1(g1), .a2(g2), .a3(g3), .a4(g4), .a5(g5), .b1(g6), .b2(g7), .b3(g8), .b4(g9), .b5(g10), .win(win), .tie(tie));
    // hand myhand (.card1(card1), .suit1(suit1), .card2(card2), .suit2(suit2), .card3(card3), .suit3(suit3), .card4(card4), .suit4(suit4), .card5(card5), .suit5(suit5));
	
endmodule
