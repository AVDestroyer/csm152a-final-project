//t flip flop
module flipflop(rst, in, out);

    input rst;
    input in;
    output reg out = 0;
    
    always @(posedge in or posedge rst) begin
        if (rst) begin
            out <= 1'b0;
        end else if (in) begin
            out <= ~out;
        end
    end
endmodule
