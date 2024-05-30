module top(clk,an,seg);
    input clk;
	
    output wire [3:0] an;
    output wire [6:0] seg;
    wire [3:0] display_num;
 
    anode_cycle anode(.clk(clk), .i1(sec0), .i2(sec1), .led_output(display_num), .an(an));
    convert_7seg convert(.num(display_num),.seg(seg));
	
endmodule
