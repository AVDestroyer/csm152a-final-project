// Triggered on positive edge of input clock -- it should start at 1
// creates a 1 clock cycle pulse with a larger period
module clk_div(clk_in,clk_out,rst,period);
    input clk_in;
    output reg clk_out = 1;
	input rst;
    input [31:0] period;
    reg[31:0] counter = 32'd0;
    
    
    always @ (posedge clk_in or posedge rst) begin
        if (rst)
            begin
                clk_out = 1;
                counter = 32'd0;
            end
        else
            begin
                counter = counter+1;
                if (counter == 1)
                    clk_out = 0;
                if (counter == period) begin
                    clk_out = 1;
                    counter = 32'd0;
                end
            end
    end
endmodule
