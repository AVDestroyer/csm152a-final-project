module prng(clk, rst, num);
    input clk;
    input rst;
    output reg [7:0] num;
    
    wire [7:0] init_seed;
    
    parameter a = 233;
    parameter c = 197;
    
    garo(.clk(clk),.rnd(init_seed));
    
    initial begin
        num <= init_seed;
    end
    
    always @(posedge clk, rst) begin
        if (rst == 1'b1) begin
            num <= init_seed;
        end
        else begin
            num <= a*num + c;
        end
    end
    
    
endmodule
