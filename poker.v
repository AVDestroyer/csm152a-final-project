module top_module ();
	reg clk=0;
	always #5 clk = ~clk;  // Create clock with period=10
	initial `probe_start;   // Start the timing diagram

	`probe(clk);        // Probe signal "clk"

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

module poker(a1, a2, a3, a4, a5, b1, b2, b3, b4, b5, win, tie);
    input [5:0] a1;
    input [5:0] a2;
    input [5:0] a3;
    input [5:0] a4;
    input [5:0] a5;
    input [5:0] b1;
    input [5:0] b2;
    input [5:0] b3;
    input [5:0] b4;
    input [5:0] b5;
    
    wire [3:0] card1;
    wire [3:0] card2;
    wire [3:0] card3;
    wire [3:0] card4;
    wire [3:0] card5;
    wire [3:0] card6;
    wire [3:0] card7;
    wire [3:0] card8;
    wire [3:0] card9;
    wire [3:0] card10;
    wire [1:0] suit1;
    wire [1:0] suit2;
    wire [1:0] suit3;
    wire [1:0] suit4;
    wire [1:0] suit5;
    wire [1:0] suit6;
    wire [1:0] suit7;
    wire [1:0] suit8;
    wire [1:0] suit9;
    wire [1:0] suit10;
    wire [14:0] score1;
    wire [14:0] score2;
    
    output [0:0] win;
    output [0:0] tie;
    
    assign card1 = a1/13;
    assign card2 = a2/13;
    assign card3 = a3/13;
    assign card4 = a4/13;
    assign card5 = a5/13;
    
    assign suit1 = a1 % 13;
    assign suit2 = a2 % 13;
    assign suit3 = a3 % 13;
    assign suit4 = a4 % 13;
    assign suit5 = a5 % 13;
    
    assign card6 = b1/13;
    assign card7 = b2/13;
    assign card8 = b3/13;
    assign card9 = b4/13;
    assign card10 = b5/13;
    
    assign suit6 = b1 % 13;
    assign suit7 = b2 % 13;
    assign suit8 = b3 % 13;
    assign suit9 = b4 % 13;
    assign suit10 = b5 % 13;
    
    hand player1 (.card1(card1), .suit1(suit1), .card2(card2), .suit2(suit2), 
                 .card3(card3), .suit3(suit3), .card4(card4), .suit4(suit4),
                  .card5(card5), .suit5(suit5), .score(score1));
    
    hand player2 (.card1(card6), .suit1(suit6), .card2(card7), .suit2(suit7), 
                  .card3(card8), .suit3(suit8), .card4(card9), .suit4(suit9),
                  .card5(card10), .suit5(suit10), .score(score2));
    
    assign win = (score2 <= score1);
    assign tie = (score2 == score1);
    
    // `probe(win);
    // `probe(tie);
    
endmodule

module hand(card1, suit1, card2, suit2, card3, suit3, card4, suit4, card5, suit5, flush, pair, three, four, royal, twopair, house, straight, straightflush, highestCard, score);
    input [3:0] card1; 
    input [3:0] card2; 
    input [3:0] card3; 
    input [3:0] card4;
    input [3:0] card5;
    input [1:0] suit1; 
    input [1:0] suit2;
    input [1:0] suit3; 
    input [1:0] suit4;
    input [1:0] suit5;
    output [0:0] flush;
    output [0:0] pair;
    output [0:0] three;
    output [0:0] four;
    output [0:0] royal;
    output [0:0] twopair;
    output [0:0] house;
    output [0:0] straight;
    output [0:0] straightflush;
    output [3:0] highestCard;
    output [14:0] score;
    
    
    assign flush = ((suit1 == suit2) && (suit2 == suit3) && (suit3 == suit4) && (suit4 == suit5));
    assign pair = ((card1 == card2) || (card1 == card3) || (card1 == card4) || (card1 == card5)
                   || (card2 == card3) || (card2 == card4) || (card2 == card5)
                   || (card3 == card4) || (card3 == card5) || (card4 == card5));
    assign three = (((card1 == card2) && (card1 == card3)) || ((card1 == card2) && (card1 == card4))
                    || ((card1 == card2) && (card1 == card5)) || ((card1 == card3) && (card1 == card4))
                    || ((card1 == card3) && (card1 == card5)) || ((card1 == card4) && (card1 == card5))
                    || ((card2 == card3) && (card2 == card4)) || ((card2 == card3) && (card2 == card5))
                    || ((card2 == card4) && (card2 == card5)) || ((card3 == card4) && (card3 == card5)));
    
    assign four = (((card1 == card2) && (card1 == card3) && (card1 == card4))
                   || ((card1 == card2) && (card1 == card3) && (card1 == card5))
                   || ((card1 == card2) && (card1 == card4) && (card1 == card5))
                   || ((card1 == card3) && (card1 == card4) && (card1 == card5))
                   || ((card2 == card3) && (card2 == card4) && (card2 == card5)));
    
    assign royal = ((suit1 == suit2) && (suit2 == suit3) && (suit3 == suit4) && (suit4 == suit5)) && (((card1 == 9) || (card2 == 9) || (card3 == 9) || (card4 == 9) || (card5 == 9))
                    && ((card1 == 10) || (card2 == 10) || (card3 == 10) || (card4 == 10) || (card5 == 10))
                    && ((card1 == 11) || (card2 == 11) || (card3 == 11) || (card4 == 11) || (card5 == 11))
                    && ((card1 == 12) || (card2 == 12) || (card3 == 12) || (card4 == 12) || (card5 == 12))
                    && ((card1 == 0) || (card2 == 0) || (card3 == 0) || (card4 == 0) || (card5 == 0)));
    
    assign straight = ((((card1 == 9) || (card2 == 9) || (card3 == 9) || (card4 == 9) || (card5 == 9))
                    && ((card1 == 10) || (card2 == 10) || (card3 == 10) || (card4 == 10) || (card5 == 10))
                    && ((card1 == 11) || (card2 == 11) || (card3 == 11) || (card4 == 11) || (card5 == 11))
                    && ((card1 == 12) || (card2 == 12) || (card3 == 12) || (card4 == 12) || (card5 == 12))
                    && ((card1 == 1) || (card2 == 1) || (card3 == 1) || (card4 == 1) || (card5 == 1)))
        			||
        			(((card1 == 10) || (card2 == 10) || (card3 == 10) || (card4 == 10) || (card5 == 10))
                    && ((card1 == 11) || (card2 == 11) || (card3 == 11) || (card4 == 11) || (card5 == 11))
                    && ((card1 == 12) || (card2 == 12) || (card3 == 12) || (card4 == 12) || (card5 == 12))
                    && ((card1 == 0) || (card2 == 0) || (card3 == 0) || (card4 == 0) || (card5 == 0))
                    && ((card1 == 1) || (card2 == 1) || (card3 == 1) || (card4 == 1) || (card5 == 1)))
        			||
        			(((card1 == 2) || (card2 == 2) || (card3 == 2) || (card4 == 2) || (card5 == 2))
                    && ((card1 == 11) || (card2 == 11) || (card3 == 11) || (card4 == 11) || (card5 == 11))
                    && ((card1 == 12) || (card2 == 12) || (card3 == 12) || (card4 == 12) || (card5 == 12))
                    && ((card1 == 0) || (card2 == 0) || (card3 == 0) || (card4 == 0) || (card5 == 0))
                    && ((card1 == 1) || (card2 == 1) || (card3 == 1) || (card4 == 1) || (card5 == 1)))
        			||
        			(((card1 == 2) || (card2 == 2) || (card3 == 2) || (card4 == 2) || (card5 == 2))
                    && ((card1 == 3) || (card2 == 3) || (card3 == 3) || (card4 == 3) || (card5 == 3))
                    && ((card1 == 12) || (card2 == 12) || (card3 == 12) || (card4 == 12) || (card5 == 12))
                    && ((card1 == 0) || (card2 == 0) || (card3 == 0) || (card4 == 0) || (card5 == 0))
                    && ((card1 == 1) || (card2 == 1) || (card3 == 1) || (card4 == 1) || (card5 == 1)))
                    ||
        			(((card1 == 2) || (card2 == 2) || (card3 == 2) || (card4 == 2) || (card5 == 2))
                    && ((card1 == 3) || (card2 == 3) || (card3 == 3) || (card4 == 3) || (card5 == 3))
                    && ((card1 == 4) || (card2 == 4) || (card3 == 4) || (card4 == 4) || (card5 == 4))
                    && ((card1 == 0) || (card2 == 0) || (card3 == 0) || (card4 == 0) || (card5 == 0))
                    && ((card1 == 1) || (card2 == 1) || (card3 == 1) || (card4 == 1) || (card5 == 1)))
        			||
        			(((card1 == 2) || (card2 == 2) || (card3 == 2) || (card4 == 2) || (card5 == 2))
                    && ((card1 == 3) || (card2 == 3) || (card3 == 3) || (card4 == 3) || (card5 == 3))
                    && ((card1 == 4) || (card2 == 4) || (card3 == 4) || (card4 == 4) || (card5 == 4))
                    && ((card1 == 5) || (card2 == 5) || (card3 == 5) || (card4 == 5) || (card5 == 5))
                    && ((card1 == 1) || (card2 == 1) || (card3 == 1) || (card4 == 1) || (card5 == 1)))
        			||
        			(((card1 == 2) || (card2 == 2) || (card3 == 2) || (card4 == 2) || (card5 == 2))
                    && ((card1 == 3) || (card2 == 3) || (card3 == 3) || (card4 == 3) || (card5 == 3))
                    && ((card1 == 4) || (card2 == 4) || (card3 == 4) || (card4 == 4) || (card5 == 4))
                    && ((card1 == 5) || (card2 == 5) || (card3 == 5) || (card4 == 5) || (card5 == 5))
                    && ((card1 == 6) || (card2 == 6) || (card3 == 6) || (card4 == 6) || (card5 == 6)))
        			||
        			(((card1 == 7) || (card2 == 7) || (card3 == 7) || (card4 == 7) || (card5 == 7))
                    && ((card1 == 3) || (card2 == 3) || (card3 == 3) || (card4 == 3) || (card5 == 3))
                    && ((card1 == 4) || (card2 == 4) || (card3 == 4) || (card4 == 4) || (card5 == 4))
                    && ((card1 == 5) || (card2 == 5) || (card3 == 5) || (card4 == 5) || (card5 == 5))
                    && ((card1 == 6) || (card2 == 6) || (card3 == 6) || (card4 == 6) || (card5 == 6)))
        			||
        			(((card1 == 7) || (card2 == 7) || (card3 == 7) || (card4 == 7) || (card5 == 7))
                    && ((card1 == 8) || (card2 == 8) || (card3 == 8) || (card4 == 8) || (card5 == 8))
                    && ((card1 == 4) || (card2 == 4) || (card3 == 4) || (card4 == 4) || (card5 == 4))
                    && ((card1 == 5) || (card2 == 5) || (card3 == 5) || (card4 == 5) || (card5 == 5))
                    && ((card1 == 6) || (card2 == 6) || (card3 == 6) || (card4 == 6) || (card5 == 6)))
        			||
        			(((card1 == 7) || (card2 == 7) || (card3 == 7) || (card4 == 7) || (card5 == 7))
                    && ((card1 == 8) || (card2 == 8) || (card3 == 8) || (card4 == 8) || (card5 == 8))
                    && ((card1 == 9) || (card2 == 9) || (card3 == 9) || (card4 == 9) || (card5 == 9))
                    && ((card1 == 5) || (card2 == 5) || (card3 == 5) || (card4 == 5) || (card5 == 5))
                    && ((card1 == 6) || (card2 == 6) || (card3 == 6) || (card4 == 6) || (card5 == 6)))
        			||
        			(((card1 == 7) || (card2 == 7) || (card3 == 7) || (card4 == 7) || (card5 == 7))
                    && ((card1 == 8) || (card2 == 8) || (card3 == 8) || (card4 == 8) || (card5 == 8))
                    && ((card1 == 9) || (card2 == 9) || (card3 == 9) || (card4 == 9) || (card5 == 9))
                    && ((card1 == 10) || (card2 == 10) || (card3 == 10) || (card4 == 10) || (card5 == 10))
                    && ((card1 == 6) || (card2 == 6) || (card3 == 6) || (card4 == 6) || (card5 == 6)))
        			||
        			(((card1 == 7) || (card2 == 7) || (card3 == 7) || (card4 == 7) || (card5 == 7))
                    && ((card1 == 8) || (card2 == 8) || (card3 == 8) || (card4 == 8) || (card5 == 8))
                    && ((card1 == 9) || (card2 == 9) || (card3 == 9) || (card4 == 9) || (card5 == 9))
                    && ((card1 == 10) || (card2 == 10) || (card3 == 10) || (card4 == 10) || (card5 == 10))
                    && ((card1 == 11) || (card2 == 11) || (card3 == 11) || (card4 == 11) || (card5 == 11)))
        			||
        			(((card1 == 12) || (card2 == 12) || (card3 == 12) || (card4 == 12) || (card5 == 12))
                    && ((card1 == 8) || (card2 == 8) || (card3 == 8) || (card4 == 8) || (card5 == 8))
                    && ((card1 == 9) || (card2 == 9) || (card3 == 9) || (card4 == 9) || (card5 == 9))
                    && ((card1 == 10) || (card2 == 10) || (card3 == 10) || (card4 == 10) || (card5 == 10))
                    && ((card1 == 11) || (card2 == 11) || (card3 == 11) || (card4 == 11) || (card5 == 11))));
    
    assign twopair = (((card1 == card2) && (card3 == card4)) || ((card1 == card2) && (card3 == card5))
                    || ((card1 == card2) && (card4 == card5)) || ((card1 == card3) && (card2 == card4))
                    || ((card1 == card3) && (card2 == card5)) || ((card1 == card3) && (card4 == card5))
                    || ((card1 == card4) && (card2 == card3)) || ((card1 == card4) && (card2 == card5))
                    || ((card1 == card4) && (card3 == card5)) || ((card1 == card5) && (card2 == card3))
                    || ((card1 == card5) && (card2 == card4)) || ((card1 == card5) && (card3 == card4))
                    || ((card2 == card3) && (card4 == card5)) || ((card2 == card4) && (card3 == card5))
                    || ((card2 == card5) && (card3 == card4)));
    
    assign house = (((card1 == card2) && (card1 == card3) && (card4 == card5))
                    || ((card1 == card2) && (card1 == card4) && (card3 == card5))
                    || ((card1 == card2) && (card1 == card5) && (card3 == card4)) 
                    || ((card1 == card3) && (card1 == card4) && (card2 == card5))
                    || ((card1 == card3) && (card1 == card5) && (card2 == card4)) 
                    || ((card1 == card4) && (card1 == card5) && (card2 == card3))
                    || ((card2 == card3) && (card2 == card4) && (card1 == card5)) 
                    || ((card2 == card3) && (card2 == card5) && (card1 == card4))
                    || ((card2 == card4) && (card2 == card5) && (card1 == card3)) 
                    || ((card3 == card4) && (card3 == card5) && (card1 == card2)));
    
    assign straightflush = ((suit1 == suit2) && (suit2 == suit3) && (suit3 == suit4) && (suit4 == suit5)) &&
        			((((card1 == 9) || (card2 == 9) || (card3 == 9) || (card4 == 9) || (card5 == 9))
                    && ((card1 == 10) || (card2 == 10) || (card3 == 10) || (card4 == 10) || (card5 == 10))
                    && ((card1 == 11) || (card2 == 11) || (card3 == 11) || (card4 == 11) || (card5 == 11))
                    && ((card1 == 12) || (card2 == 12) || (card3 == 12) || (card4 == 12) || (card5 == 12))
                    && ((card1 == 1) || (card2 == 1) || (card3 == 1) || (card4 == 1) || (card5 == 1)))
        			||
        			(((card1 == 10) || (card2 == 10) || (card3 == 10) || (card4 == 10) || (card5 == 10))
                    && ((card1 == 11) || (card2 == 11) || (card3 == 11) || (card4 == 11) || (card5 == 11))
                    && ((card1 == 12) || (card2 == 12) || (card3 == 12) || (card4 == 12) || (card5 == 12))
                    && ((card1 == 0) || (card2 == 0) || (card3 == 0) || (card4 == 0) || (card5 == 0))
                    && ((card1 == 1) || (card2 == 1) || (card3 == 1) || (card4 == 1) || (card5 == 1)))
        			||
        			(((card1 == 2) || (card2 == 2) || (card3 == 2) || (card4 == 2) || (card5 == 2))
                    && ((card1 == 11) || (card2 == 11) || (card3 == 11) || (card4 == 11) || (card5 == 11))
                    && ((card1 == 12) || (card2 == 12) || (card3 == 12) || (card4 == 12) || (card5 == 12))
                    && ((card1 == 0) || (card2 == 0) || (card3 == 0) || (card4 == 0) || (card5 == 0))
                    && ((card1 == 1) || (card2 == 1) || (card3 == 1) || (card4 == 1) || (card5 == 1)))
        			||
        			(((card1 == 2) || (card2 == 2) || (card3 == 2) || (card4 == 2) || (card5 == 2))
                    && ((card1 == 3) || (card2 == 3) || (card3 == 3) || (card4 == 3) || (card5 == 3))
                    && ((card1 == 12) || (card2 == 12) || (card3 == 12) || (card4 == 12) || (card5 == 12))
                    && ((card1 == 0) || (card2 == 0) || (card3 == 0) || (card4 == 0) || (card5 == 0))
                    && ((card1 == 1) || (card2 == 1) || (card3 == 1) || (card4 == 1) || (card5 == 1)))
                    ||
        			(((card1 == 2) || (card2 == 2) || (card3 == 2) || (card4 == 2) || (card5 == 2))
                    && ((card1 == 3) || (card2 == 3) || (card3 == 3) || (card4 == 3) || (card5 == 3))
                    && ((card1 == 4) || (card2 == 4) || (card3 == 4) || (card4 == 4) || (card5 == 4))
                    && ((card1 == 0) || (card2 == 0) || (card3 == 0) || (card4 == 0) || (card5 == 0))
                    && ((card1 == 1) || (card2 == 1) || (card3 == 1) || (card4 == 1) || (card5 == 1)))
        			||
        			(((card1 == 2) || (card2 == 2) || (card3 == 2) || (card4 == 2) || (card5 == 2))
                    && ((card1 == 3) || (card2 == 3) || (card3 == 3) || (card4 == 3) || (card5 == 3))
                    && ((card1 == 4) || (card2 == 4) || (card3 == 4) || (card4 == 4) || (card5 == 4))
                    && ((card1 == 5) || (card2 == 5) || (card3 == 5) || (card4 == 5) || (card5 == 5))
                    && ((card1 == 1) || (card2 == 1) || (card3 == 1) || (card4 == 1) || (card5 == 1)))
        			||
        			(((card1 == 2) || (card2 == 2) || (card3 == 2) || (card4 == 2) || (card5 == 2))
                    && ((card1 == 3) || (card2 == 3) || (card3 == 3) || (card4 == 3) || (card5 == 3))
                    && ((card1 == 4) || (card2 == 4) || (card3 == 4) || (card4 == 4) || (card5 == 4))
                    && ((card1 == 5) || (card2 == 5) || (card3 == 5) || (card4 == 5) || (card5 == 5))
                    && ((card1 == 6) || (card2 == 6) || (card3 == 6) || (card4 == 6) || (card5 == 6)))
        			||
        			(((card1 == 7) || (card2 == 7) || (card3 == 7) || (card4 == 7) || (card5 == 7))
                    && ((card1 == 3) || (card2 == 3) || (card3 == 3) || (card4 == 3) || (card5 == 3))
                    && ((card1 == 4) || (card2 == 4) || (card3 == 4) || (card4 == 4) || (card5 == 4))
                    && ((card1 == 5) || (card2 == 5) || (card3 == 5) || (card4 == 5) || (card5 == 5))
                    && ((card1 == 6) || (card2 == 6) || (card3 == 6) || (card4 == 6) || (card5 == 6)))
        			||
        			(((card1 == 7) || (card2 == 7) || (card3 == 7) || (card4 == 7) || (card5 == 7))
                    && ((card1 == 8) || (card2 == 8) || (card3 == 8) || (card4 == 8) || (card5 == 8))
                    && ((card1 == 4) || (card2 == 4) || (card3 == 4) || (card4 == 4) || (card5 == 4))
                    && ((card1 == 5) || (card2 == 5) || (card3 == 5) || (card4 == 5) || (card5 == 5))
                    && ((card1 == 6) || (card2 == 6) || (card3 == 6) || (card4 == 6) || (card5 == 6)))
        			||
        			(((card1 == 7) || (card2 == 7) || (card3 == 7) || (card4 == 7) || (card5 == 7))
                    && ((card1 == 8) || (card2 == 8) || (card3 == 8) || (card4 == 8) || (card5 == 8))
                    && ((card1 == 9) || (card2 == 9) || (card3 == 9) || (card4 == 9) || (card5 == 9))
                    && ((card1 == 5) || (card2 == 5) || (card3 == 5) || (card4 == 5) || (card5 == 5))
                    && ((card1 == 6) || (card2 == 6) || (card3 == 6) || (card4 == 6) || (card5 == 6)))
        			||
        			(((card1 == 7) || (card2 == 7) || (card3 == 7) || (card4 == 7) || (card5 == 7))
                    && ((card1 == 8) || (card2 == 8) || (card3 == 8) || (card4 == 8) || (card5 == 8))
                    && ((card1 == 9) || (card2 == 9) || (card3 == 9) || (card4 == 9) || (card5 == 9))
                    && ((card1 == 10) || (card2 == 10) || (card3 == 10) || (card4 == 10) || (card5 == 10))
                    && ((card1 == 6) || (card2 == 6) || (card3 == 6) || (card4 == 6) || (card5 == 6)))
        			||
        			(((card1 == 7) || (card2 == 7) || (card3 == 7) || (card4 == 7) || (card5 == 7))
                    && ((card1 == 8) || (card2 == 8) || (card3 == 8) || (card4 == 8) || (card5 == 8))
                    && ((card1 == 9) || (card2 == 9) || (card3 == 9) || (card4 == 9) || (card5 == 9))
                    && ((card1 == 10) || (card2 == 10) || (card3 == 10) || (card4 == 10) || (card5 == 10))
                    && ((card1 == 11) || (card2 == 11) || (card3 == 11) || (card4 == 11) || (card5 == 11)))
        			||
        			(((card1 == 12) || (card2 == 12) || (card3 == 12) || (card4 == 12) || (card5 == 12))
                    && ((card1 == 8) || (card2 == 8) || (card3 == 8) || (card4 == 8) || (card5 == 8))
                    && ((card1 == 9) || (card2 == 9) || (card3 == 9) || (card4 == 9) || (card5 == 9))
                    && ((card1 == 10) || (card2 == 10) || (card3 == 10) || (card4 == 10) || (card5 == 10))
                    && ((card1 == 11) || (card2 == 11) || (card3 == 11) || (card4 == 11) || (card5 == 11))));

    assign highestCard = ((card1 >= card2) && (card1 >= card3) && (card1 >= card4) && (card1 >= card5)) * card1
        				+((card2 >= card1) && (card2 >= card3) && (card2 >= card4) && (card2 >= card5)) * card2
        				+((card3 >= card1) && (card3 >= card2) && (card3 >= card4) && (card3 >= card5)) * card3
        				+((card4 >= card1) && (card4 >= card2) && (card4 >= card3) && (card4 >= card5)) * card4
        				+((card5 >= card1) && (card5 >= card2) && (card5 >= card3) && (card5 >= card4)) * card5;
    
    assign score = highestCard + (pair << 6) + (twopair << 7) + (three << 8) + 
        (straight << 9) + (flush << 10) + (house << 11) + (four << 12) +
        (straightflush << 13) + (royal << 14);
    /*
    `probe(flush);
    `probe(pair);
    `probe(three);
    `probe(four);
    `probe(royal);
    `probe(twopair);
    `probe(house);
    `probe(straight);
    `probe(straightflush);
    `probe(highestCard);
    `probe(score);
	*/
endmodule 



