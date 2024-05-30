module anode_cycle(clk, i1, i2, led_output, an);
    input clk;
	
    input [3:0] i1;
    input [3:0] i2;
	
    output reg [1:0] an;
    output reg [3:0] led_output;   
    reg[0:0] counter;
	
    always @ (posedge clk)
                begin
		    counter = counter + 1;
                    case (counter)
                        2'b00: 
                            begin
                                led_output <= i1;
                            end
                                an <= 2'b10;
                            end
                        2'b01: 
                            begin
                                led_output <= i2;
                                an <= 2'b01;
                            end
                   endcase
                end                                                                                                 
        end     

    initial begin
        counter <= 2'b00;
        an <= 4'b00; 

endmodule
