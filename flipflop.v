module flipflop(clk, rst, in, out);

    input clk;
    input rst;
    input in;
    output reg out;
    
    always @(posedge in or posedge rst) begin
        if (rst) begin
            out <= 1'b0;
        end else if (in) begin
            out <= ~out;
        end
    end
endmodule
