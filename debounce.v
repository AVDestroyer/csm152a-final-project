module debounce(clk, in, out);
    input clk;
    input in;
    output reg out;
    
    reg [10:0] deb;
    
    initial begin
        out = 1'b0;
        deb = 11'b0;
    end
    
    always @(posedge clk) begin      
        deb[10:0] <= {in, deb[10:1]};
    end
    
    always @(posedge clk) begin
        if (out == 1'b0) begin
            if (&deb[10:1] && ~deb[0])
                out <= 1'b1;
        end else begin
            if (~|deb[10:1] && deb[0])
                out <= 1'b0;
        end
    end

endmodule
