module anode_cycle_main(clk, reset, i1,i2,i3,i4, led_output, an);
    input clk;
    input reset;
	
    input [4:0] i1;
    input [4:0] i2;
    input [4:0] i3;
    input [4:0] i4;
	
    output reg [4:0] led_output;
    output reg [3:0] an = 0;
    
    wire clk_dv;
	
	parameter integer PERIOD = 100000;
	
	reg[1:0] counter = 0;
	
	clk_div div(.clk_in(clk),.clk_out(clk_dv),.rst(reset),.period(PERIOD));
    
    
    always @ (posedge clk_dv or posedge reset)
        begin
            if (reset)
                begin
                    led_output <= 0;
                    an <= 0;
                    counter <= 0;
                end
            else begin
                counter = counter + 1;
                case (counter)
                    2'b00: 
                        begin
                            led_output <= i1;
                            an <= 4'b1110;
                        end
                    2'b01: 
                        begin
                            led_output <= i2;
                            an <= 4'b1101;
                        end
                    2'b10: 
                        begin
                            led_output <= i3;
                            an <= 4'b1011;
                        end
                    2'b11: 
                        begin
                            led_output <= i4;
                            an <= 4'b0111;
                        end
               endcase
           end
        end                                                                                                 
endmodule