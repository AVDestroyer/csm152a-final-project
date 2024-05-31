module debounce(clk, in, out);
    input clk;
    input in;
    output reg out;
    
    reg [5:0] deb;
    
    initial begin
        out = 1'b0;
        deb = 6'b0;
    end
    
    always @(posedge clk) begin      
        deb[5:0] = {in, deb[5:1]};
    end
    
    always @ (posedge clk) begin
        if (out == 1'b0)
            out = ~deb[0] & deb[1] & deb[2] & deb[3] & deb[4] & deb[5];
        else
            out = ~(deb[0] & ~deb[1] & ~deb[2] & ~deb[3] & ~deb[4] & ~deb[5]);
    end

endmodule
