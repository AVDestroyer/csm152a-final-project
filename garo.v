//https://electronics.stackexchange.com/questions/263656/hardware-sources-of-entropy-on-an-fpga
module garo(clk, rnd);
    input clk;
    output reg [7:0] rnd;

    (* ALLOW_COMBINATORIAL_LOOPS = "TRUE", KEEP = "TRUE" *) wire [7:0] ring;
    (* ASYNC_REG = "TRUE" *) reg [7:0] ring_reg;
    
    assign ring = {ring, ring[7]} ^ ring ^ ({ring[0], ring}>>1) ^ {3{2'b01}};
    
    always  @(posedge clk) begin
        ring_reg <= ring;
        rnd <= {rnd, 1'b0} ^ ring_reg ^ (rnd & 8'h06) ^ ({1'b0, rnd}>>1);
    end
endmodule
