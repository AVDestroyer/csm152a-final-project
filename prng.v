// https://en.wikipedia.org/wiki/Linear_congruential_generator
// a,c are primes and m is 256, allowing the period of the LCG to be maximized (m-1)
module prng(clk, rst, num);
    input clk;
    input rst;
    output reg [7:0] num;
    
    reg [7:0] init_seed = 251;
    
    parameter a = 233;
    parameter c = 197;
        
    initial begin
        num = init_seed;
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            num <= init_seed;
        end
        else begin
            num <= a*num + c;
        end
    end
    
    
endmodule
