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
                10: code = 7'b1000111;
                12: code = 7'b1111000;
                13: code = 7'b0001000;
                15: code = 7'b1111001;
                16: code = 7'b1001000;
                17: code = 7'b0110000;
                18: code = 7'b0110001;
                20: code = 7'b0100100;
                21: code = 7'b0011000;
                22: code = 7'b1110111;
                23: code = 7'b0110111;
                default: code = 7'b1111111;
             endcase
             seg = code ^ {7{invert}};
        end
endmodule