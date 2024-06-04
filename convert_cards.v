module convert_cards(clk, card, dig1, dig2, dig3, dig4);
    input clk;
    input [5:0] card;
    output reg [6:0] dig1;
    output reg [6:0] dig2;
    output reg [6:0] dig3;
    output reg [6:0] dig4;
    
    wire suit;
    wire num;
    
    assign suit = card / 13;
    assign num = card % 13;
    
    always @(*) begin
        case (suit)
            0: begin
                assign dig3 = 7'b0000001;
                assign dig4  = 7'b1111001;
            end
            1: begin
                assign dig3 = 7'b0110111;
                assign dig4 = 7'b0110000;
            end
            2: begin
                assign dig3 = 7'b0110001;
                assign dig4 = 7'b1001111;
            end
            3: begin
                assign dig3 = 7'b0100100;
                assign dig4 = 7'b0011000;
            end
        endcase
    end
    always @(*) begin
        case (num)
            0: begin
                assign dig1 = 7'b0001000;
                assign dig2 = 7'b1111111;
            end
            1: begin
                assign dig1 = 7'b0010010;
                assign dig2 = 7'b1111111;
            end
            2: begin
                assign dig1 = 7'b0000110;
                assign dig2 = 7'b1111111;
            end
            3: begin
                assign dig1 = 7'b1001100;
                assign dig2 = 7'b1111111;
            end
            4: begin
                assign dig1 = 7'b0100100;
                assign dig2 = 7'b1111111;
            end
            5: begin
                assign dig1 = 7'b0100000;
                assign dig2 = 7'b1111111;
            end
            6: begin
                assign dig1 = 7'b0001111;
                assign dig2 = 7'b1111111;
            end
            7: begin
                assign dig1 = 7'b0000000;
                assign dig2 = 7'b1111111;
            end
            8: begin
                assign dig1 = 7'b0000100;
                assign dig2 = 7'b1111111;
            end
            9: begin
                assign dig1 = 7'b1001111;
                assign dig2 = 7'b0000001;
            end
            10: begin
                assign dig1 = 7'b1000111;
                assign dig2 = 7'b1111111;
            end
            11: begin
                assign dig1 = 7'b0000001;
                assign dig2 = 7'b1110111;
            end
            12: begin
                assign dig1 = 7'b1111000;
                assign dig2 = 7'b0110111;
            end
        endcase
    end

endmodule
