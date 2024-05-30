module top(clk,an,seg);
    input clk;
	
    output wire [3:0] an;
    output wire [6:0] seg;
    wire [3:0] display_num;
 
    anode_cycle anode(.clk(clk), .i1(4'b0001), .i2(4'b0001), .led_output(display_num), .an(an));
    convert_7seg convert(.num(display_num),.seg(seg));
	
endmodule
