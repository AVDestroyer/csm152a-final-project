// cycles through cards on the table, creating the "digits" needed to represent them on the 7-segment display
// displayed digits change every second
// each card needs 4 digits (2 for number, 2 for suit), so we display 1 card at a time on the main 7-segment display
// number of cards cycled through depends on round (flop, turn, river)
module maincard_display(clk, rst, num, card1, card2, card3, outdig1, outdig2, outdig3, outdig4);
    input clk;
    input rst;
    input [1:0] num;
    input [5:0] card1;
    input [5:0] card2;
    input [5:0] card3;
    output reg [4:0] outdig1 = 0;
    output reg [4:0] outdig2 = 0;
    output reg [4:0] outdig3 = 0;
    output reg [4:0] outdig4 = 0;
    
    wire [4:0] card1dig1;
    wire [4:0] card1dig2;
    wire [4:0] card1dig3;
    wire [4:0] card1dig4;
    wire [4:0] card2dig1;
    wire [4:0] card2dig2;
    wire [4:0] card2dig3;
    wire [4:0] card2dig4;
    wire [4:0] card3dig1;
    wire [4:0] card3dig2;
    wire [4:0] card3dig3;
    wire [4:0] card3dig4;
    
    convert_cards c1main(.card(card1),.dig1(card1dig1),.dig2(card1dig2),.dig3(card1dig3),.dig4(card1dig4));
    convert_cards c2main(.card(card2),.dig1(card2dig1),.dig2(card2dig2),.dig3(card2dig3),.dig4(card2dig4));
    convert_cards c3main(.card(card3),.dig1(card3dig1),.dig2(card3dig2),.dig3(card3dig3),.dig4(card3dig4));
    
    parameter integer PERIOD = 100000000;
    wire clk_sec;
    
    clk_div sec_div(.clk_in(clk),.clk_out(clk_sec),.rst(rst),.period(PERIOD));
    
    reg [1:0] counter = 0;
    
    always @(posedge clk_sec or posedge rst) begin
        if (rst)
            counter = 0;
        else begin
            counter = counter + 1;
            if (counter >= num)
                counter = 0;
        end
    end
    
    always @(posedge clk) begin
        case (counter)
            0: begin
                outdig1 = card1dig1;
                outdig2 = card1dig2;
                outdig3 = card1dig3;
                outdig4 = card1dig4;
            end
            1: begin
                outdig1 = card2dig1;
                outdig2 = card2dig2;
                outdig3 = card2dig3;
                outdig4 = card2dig4;
            end
            2: begin
                outdig1 = card3dig1;
                outdig2 = card3dig2;
                outdig3 = card3dig3;
                outdig4 = card3dig4;
            end
            default: begin
                outdig1 = 0;
                outdig2 = 0;
                outdig3 = 0;
                outdig4 = 0;
            end
        endcase
    end
    
      
endmodule
