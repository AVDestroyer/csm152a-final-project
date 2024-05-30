module top (clk, btnR, sw, btnL, dp, seg, an, an2, seg2);
    
    input clk;
    input btnR;
    input [0:0] sw;
    input btnL;
    output wire dp;
    output wire [6:0] seg;
    output reg [3:0] an = 4'b0000;
    
    output wire [0:0] an2;
    output wire [6:0] seg2;
    wire [3:0] display_num;
    
    wire reset_d;
    wire cashout_d;
    wire cycle_d;
    wire cycle_p;
    
    debounce reset_debounce(.clk(clk),.in(btnR),.out(reset_d));
    debounce cashout_debounce(.clk(clk),.in(sw[0]),.out(cashout_d));
    debounce cycle_debounce(.clk(clk),.in(btnL),.out(cycle_d));
    monostable cycle_pulse(.clk(clk),.in(cycle_d),.out(cycle_p));
    
    parameter playing = 1'b0;
    parameter cashout = 1'b1;
    reg game_state = playing;
    reg next_game_state = playing;
    
    parameter preflop = 3'b0;
    parameter flop = 3'b1;
    parameter turn = 3'b10;
    parameter river = 3'b11;
    parameter tallyup = 3'b100;
    reg [2:0] current_round = preflop;
    reg [2:0] next_round = preflop;
    
    wire switch_round;
    assign switch_round = cycle_p;
    
    
    always @(game_state, next_game_state, reset_d, cashout_d) begin
        case (game_state)
            playing: begin
                if (reset_d == 1'b1)
                    next_game_state = cashout;
                if (cashout_d == 1'b1 && current_round == tallyup && next_round == preflop)
                    next_game_state = cashout;
                else
                    next_game_state = playing;
                end
            cashout: begin
                if (cashout_d == 1'b0)
                    next_game_state = playing;
                else
                    next_game_state = cashout;
                end
        endcase
    end
    
    always @(switch_round, reset_d) begin
        if (reset_d == 1'b1)
            next_round = preflop;
        else if (switch_round == 1'b1)
            next_round = (current_round + 1) % 6;
    end
        
    always @(posedge clk, posedge reset_d) begin
        if (reset_d == 1'b1) begin
            game_state = playing;
            current_round = preflop;
            
        end
        else begin
            game_state = next_game_state;
            current_round = next_round;
        end
    end
    
    assign dp = game_state;
    convert_7seg (.num(current_round),.seg(seg), .invert(0));
    
    anode_cycle anode(.clk(clk), .i1(4'b0001), .i2(4'b0001), .led_output(display_num), .an(an2));
    convert_7seg convert(.num(display_num),.seg(seg2), .invert(1));
    
    
endmodule
