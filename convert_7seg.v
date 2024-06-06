// converting a number (or letter) to a 7-segment code 
// Pmods need code to be inverted
module convert_7seg(num, seg, invert);
    input [4:0] num;
    reg [6:0] code;
    output reg [6:0] seg;
    input invert;
    always @(*)
        begin
            case (num)
                0: code = 7'b0000001; 
                1: code = 7'b1001111;
                2: code = 7'b0010010;
                3: code = 7'b0000110;
                4: code = 7'b1001100;
                5: code = 7'b0100100;
                6: code = 7'b0100000;
                7: code = 7'b0001111;
                8: code = 7'b0000000;
                9: code = 7'b0000100;
                10: code = 7'b1000111; //J
                12: code = 7'b1111000; // K (first digit, looks like ?)
                13: code = 7'b0001000; // A 
                15: code = 7'b1111001; // I (looks like 1 but on left side)
                16: code = 7'b1001000; // H
                17: code = 7'b0110000; // E
                18: code = 7'b0110001; // C
                20: code = 7'b0100100; // S
                21: code = 7'b0011000; // P
                22: code = 7'b1110111; // Q (second digit, looks like _)
                23: code = 7'b0110111; // K (second digit, looks like =)
                default: code = 7'b1111111; //blank
             endcase
             // this line written by chatGPT
             seg = code ^ {7{invert}};
        end
endmodule