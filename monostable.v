// converts an input signal into a 1 clock cycle pulse for each positive edge
module monostable(clk, in, out);
    input clk;
    input in;
    output reg out;
    
    reg prev;
    
    initial begin
        out = 0;
        prev = 0;
    end
    
    always @(posedge clk) begin
        if (in == 1 && prev == 0) begin
            out <= 1;
        end else begin
            out <= 0;
        end
        prev <= in;
    end    
    
endmodule
