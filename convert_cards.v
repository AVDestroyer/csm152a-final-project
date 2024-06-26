// converts a card number (0-51) to numbers that can be displayed on the 7-segment display
// each card needs 4 digits as a display (2 for number, 2 for suit)
module convert_cards(card, dig1, dig2, dig3, dig4);
    input [5:0] card;
    output reg [4:0] dig1;
    output reg [4:0] dig2;
    output reg [4:0] dig3;
    output reg [4:0] dig4;
    
    wire [1:0] suit;
    wire [3:0] num;
    
    assign suit = card / 13;
    assign num = card % 13;
    
    always @(*) begin
        case (suit)
            0: begin
            //Diamonds (D I)
                dig3 = 0;
                dig4 = 15; // 7'b1111001;
            end
            1: begin
            // Hearts (H E)
                dig3 = 16; //7'b0110111;
                dig4 = 17; //7'b0110000;
            end
            2: begin
            // Clubs (C l)
                dig3 = 18; //7'b0110001;
                dig4 = 1;
            end
            3: begin
            // Spades (S P)
                dig3 = 20; //7'b0100100;
                dig4 = 21; //7'b0011000;
            end
        endcase
    end
    always @(*) begin
        case (num)
            // Ace
            0: begin
                dig1 = 13; //7'b0001000;
                dig2 = 24; // blank
            end
            // 2
            1: begin
                dig1 = 2;
                dig2 = 24; //blank
            end
            // 3
            2: begin
                dig1 = 3;
                dig2 = 24;
            end
            // 4
            3: begin
                dig1 = 4;
                dig2 = 24;
            end
            // 5
            4: begin
                dig1 = 5;
                dig2 = 24;
            end
            // 6
            5: begin
                dig1 = 6;
                dig2 = 24;
            end
            // 7
            6: begin
                dig1 = 7;
                dig2 = 24;
            end
            // 8
            7: begin
                dig1 = 8;
                dig2 = 24;
            end
            // 9
            8: begin
                dig1 = 9;
                dig2 = 24;
            end
            // 1 0
            9: begin
                dig1 = 1;
                dig2 = 0;
            end
            // Jack
            10: begin
                dig1 = 10; // 7'b1000111;
                dig2 = 24;
            end
            // Queen (0 _)
            11: begin
                dig1 = 0;
                dig2 = 22; //7'b1110111;
            end
            // King
            12: begin
                dig1 = 12; //7'b1111000;
                dig2 = 23; //7'b0110111;
            end
            default: begin
                dig1 = 0;
                dig2 = 0;
            end
        endcase
    end

endmodule
