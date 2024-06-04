module anode_cycle_p(clk, reset, i1,i2, led_output, an);
    input clk;
    input reset;
	
    input [3:0] i1;
    input [3:0] i2;
	
    output reg [3:0] led_output;
    output reg [0:0] an = 0;
    
	
    wire clk_dv;
	
	parameter integer PERIOD = 100000;
	
	reg[0:0] counter = 0;
	
	clk_div div(.clk_in(clk),.clk_out(clk_dv),.rst(reset),.period(PERIOD));
    
    
    always @ (posedge clk_dv or posedge reset)
        begin
            if (reset)
                begin
                    led_output <= 4'd0;
                    an <= 4'b0000;
                    counter <= 2'b00;
            end else begin
                counter = counter + 1;
                case (counter)
                    1'b0: 
                        begin
                            led_output <= i1;
                            an <= 1'b0;
                        end
                    1'b1: 
                        begin
                            led_output <= i2;
                            an <= 1'b1;
                        end
               endcase
           end
        end                                                                                                 
endmodule
