module tb();
    reg clk = 1;
    reg btnR = 0;
    reg [15:0] sw = 16'd0;
    reg btnU = 0;
    reg btnL = 0;
    reg btnC = 0;
    reg btnD = 0;
    wire [6:0] seg;
    wire [6:0] seg2;
    wire [6:0] seg3;
    wire [3:0] an;
    wire [0:0] an2;
    wire [0:0] an3;
    always begin 
       #5 clk = ~clk;
    end
    top UUT(.clk(clk),.btnR(btnR), .sw(sw), .btnU(btnU), .btnL(btnL), .btnC(btnC),.btnD(btnD),.seg(seg),.an(an),.an2(an2),.seg2(seg2),.an3(an3),.seg3(seg3));
endmodule
