module debounce(clk, in, out);
    input clk;
    input in;
    output reg out;
    
    reg [2:0] deb;
    
    initial begin
        out = 1'b0;
        deb = 3'b0;
    end
    
    always @(posedge clk) begin      
        deb[2:0] = {in, deb[2:1]};
    end
    
    always @ (posedge clk) begin
        if (out == 1'b0)
            out = ~deb[0] & deb[1] & deb[2];
        else
            out = ~(deb[0] & ~deb[1] & ~deb[2]);
    end

endmodule
