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
