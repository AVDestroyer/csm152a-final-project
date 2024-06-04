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
    
    assign royal = flush && (((card1 == 9) || (card2 == 9) || (card3 == 9) || (card4 == 9) || (card5 == 9))
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
    
    assign straightflush = flush && straight;

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
