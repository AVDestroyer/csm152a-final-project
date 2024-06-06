// 11 bit debouncing
module debounce(clk, in, out);
    input clk;
    input in;
    output reg out;
    
    reg [10:0] deb;
    
    initial begin
        out = 1'b0;
        deb = 11'b0;
    end
    
    // code originally written by me, input to chatGPT to improve it (which recommended to use nonblocking assignment and simplified syntax in the if statements)
    // https://chatgpt.com/share/0f2b1f74-a444-434d-8c46-18f8e80f8095
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
