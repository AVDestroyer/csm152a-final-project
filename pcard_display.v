module pcard_display(clk, rst, card1, card2, outdig1, outdig2);
    input clk;
    input rst;
    input [5:0] card1;
    input [5:0] card2;
    output reg [4:0] outdig1 = 0;
    output reg [4:0] outdig2 = 0;
    
    wire [4:0] card1dig1;
    wire [4:0] card1dig2;
    wire [4:0] card1dig3;
    wire [4:0] card1dig4;
    wire [4:0] card2dig1;
    wire [4:0] card2dig2;
    wire [4:0] card2dig3;
    wire [4:0] card2dig4;
    
    convert_cards c1main(.clk(clk),.card(card1),.dig1(card1dig1),.dig2(card1dig2),.dig3(card1dig3),.dig4(card1dig4));
    convert_cards c2main(.clk(clk),.card(card2),.dig1(card2dig1),.dig2(card2dig2),.dig3(card2dig3),.dig4(card2dig4));
    
    parameter integer PERIOD = 100000000;
    wire clk_sec;
    
    clk_div sec_div(.clk_in(clk),.clk_out(clk_sec),.rst(rst),.period(PERIOD));
    
    reg [1:0] counter = 0;
    
    always @(posedge clk_sec or posedge rst) begin
        if (rst)
            counter = 0;
        else
            counter = counter + 1;
    end
    
    always @(posedge clk) begin
        case (counter)
            0: begin
                outdig1 = card1dig1;
                outdig2 = card1dig2;
            end
            1: begin
                outdig1 = card1dig3;
                outdig2 = card1dig4;
            end
            2: begin
                outdig1 = card2dig1;
                outdig2 = card2dig2;
            end
            3: begin
                outdig1 = card2dig3;
                outdig2 = card2dig4;
            end
        endcase
    end
    
       
endmodule
