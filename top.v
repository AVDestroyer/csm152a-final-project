module top (clk, btnR, sw, btnU, btnL, btnC, btnD, seg, an, an2, seg2, an3, seg3);
    input clk;
    input btnR;
    input [0:0] sw;
    input btnU;
    input btnL;
    input btnC;
    input btnD;
    output wire [6:0] seg;
    output wire [3:0] an;
    output wire [0:0] an2;
    output wire [6:0] seg2;
    output wire [0:0] an3;
    output wire [6:0] seg3;
    
    wire reset_d;
    wire cashout_d;
    wire fold_d;
    wire fold_p;
    wire call_d;
    wire call_p;
    wire raise_d;
    wire raise_p;
    wire freeze_d;
    
    debounce reset_debounce(.clk(clk),.in(btnR),.out(reset_d));
    debounce cashout_debounce(.clk(clk),.in(sw[0]),.out(cashout_d));
    debounce fold_debounce(.clk(clk),.in(btnU),.out(fold_d));
    monostable fold_pulse(.clk(clk),.in(fold_d),.out(fold_p));
    debounce checkcall_debounce(.clk(clk),.in(btnL),.out(call_d));
    monostable checkcall_pulse(.clk(clk),.in(call_d),.out(call_p));
    debounce raisebet_debounce(.clk(clk),.in(btnC),.out(raise_d));
    monostable raisebet_pulse(.clk(clk),.in(raise_d),.out(raise_p));
    debounce freeze_debounce(.clk(clk),.in(btnD),.out(freeze_d));
    
    parameter playing = 2'b00;
    parameter cashout = 2'b01;
    parameter loading = 2'b10;
    reg [1:0] game_state = loading;
    reg [1:0] next_game_state = loading;
    reg [5:0] counter = 6'b000000;
    reg start_game = 0;
    
    parameter preflop = 3'b0;
    parameter flop = 3'b1;
    parameter turn = 3'b10;
    parameter river = 3'b11;
    parameter tallyup = 3'b100;
    reg [2:0] current_round = preflop;
    reg [2:0] next_round = preflop;
        
    wire [7:0] rngout;
    reg [7:0] random_num;
    
    wire clk_sec;
    parameter integer STOPWATCHPERIOD = 114913817;
    
    clk_div sec_div(.clk_in(clk),.clk_out(clk_sec),.rst(reset_d),.period(STOPWATCHPERIOD));
    
    reg cur_player = 0;
    parameter p1 = 0;
    parameter p2 = 1;
    reg [7:0] num_game_rounds = 0;
    reg [6:0] p1_balance = 49;
    reg [6:0] p2_balance = 49;
    wire [3:0] p1_balanced1;
    wire [3:0] p1_balanced2;
    wire [3:0] p2_balanced1;
    wire [3:0] p2_balanced2;
    assign p1_balanced1 = p1_balance / 10;
    assign p1_balanced2 = p1_balance % 10;
    assign p2_balanced1 = p2_balance / 10;
    assign p2_balanced2 = p2_balance % 10;
    reg [6:0] pot = 0;
    wire [3:0] potdig1;
    wire [3:0] potdig2;
    assign potdig1 = pot / 10;
    assign potdig2 = pot % 10;
    reg [6:0] cur_bet = 0;
    reg [6:0] p1_betted = 0;
    reg [6:0] p2_betted = 0;
    
    wire [3:0] pot_display;
    wire [3:0] p1_balance_display;
    wire [3:0] p2_balance_display;
    
    reg reset_game = 0;
    
    always @(posedge clk) begin
        counter = counter + 1;
        if (counter >= 53)
            start_game = 1;
    end
    
    always @(game_state, next_game_state, reset_d, cashout_d, start_game) begin
        case (game_state)
            loading: begin
                if (start_game)
                    next_game_state = playing;
            end
            playing: begin
                reset_game = 0;
                if (cashout_d == 1'b1 && next_round == preflop)
                    next_game_state = cashout;
                else
                    next_game_state = playing;
            end
            cashout: begin
                if (cashout_d == 1'b0) begin
                    next_game_state = playing;
                    reset_game = 1;
                end else
                    next_game_state = cashout;
            end
        endcase
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
    
    always @(posedge fold_p, posedge call_p, posedge raise_p, posedge reset_d, posedge reset_game) begin
        if (reset_d || reset_game) begin
            p1_balance = 49;
            p2_balance = 49;
            num_game_rounds = 0;
            cur_bet = 0;
            pot = 0;
            p1_betted = 0;
            p2_betted = 0;
            next_round = preflop;
            cur_player = p1;
        end else begin
            case (game_state)
                playing: begin
                    case (current_round)
                        preflop: begin
                            if (fold_p) begin
                                if (cur_player == p1)
                                    p2_balance = p2_balance + pot;
                                else
                                    p1_balance = p1_balance + pot;
                                pot = 0;
                                num_game_rounds = num_game_rounds + 1;
                                cur_player = (num_game_rounds % 2);
                                cur_bet = 0;
                                p1_betted = 0;
                                p2_betted = 0;
                                next_round = preflop; 
                            end else if (call_p) begin
                                if (cur_bet > 0) begin
                                    if (cur_player == p1) begin
                                        p1_balance = p1_balance - (cur_bet - p1_betted);
                                        pot = pot + (cur_bet - p1_betted);
                                        p1_betted = cur_bet;
                                    end else begin
                                        p2_balance = p2_balance - (cur_bet - p2_betted);
                                        pot = pot + (cur_bet - p2_betted);
                                        p2_betted = cur_bet;
                                    end
                                    cur_player = (num_game_rounds % 2);
                                    cur_bet = 0;
                                    p1_betted = 0;
                                    p2_betted = 0;
                                    next_round = flop;
                                end else begin
                                    if (cur_player == ~(num_game_rounds % 2)) begin
                                        next_round = flop;
                                        cur_player = (num_game_rounds % 2);
                                    end else
                                        cur_player = ~cur_player;
                                end
                            end else if (raise_p) begin
                                if (cur_bet > 0) begin
                                    if (cur_player == p1) begin
                                        p1_balance = p1_balance -((cur_bet - p1_betted) + 5);
                                        pot = pot + (cur_bet - p1_betted) + 5;
                                        cur_bet = cur_bet + 5;
                                        p1_betted = cur_bet;
                                    end else begin
                                        p2_balance = p2_balance -((cur_bet - p2_betted) + 5);
                                        pot = pot + (cur_bet - p2_betted) + 5;
                                        cur_bet = cur_bet + 5;
                                        p2_betted = cur_bet;
                                    end
                                end else begin
                                    if (cur_player == p1) begin
                                        p1_balance = p1_balance - 5;
                                        pot = pot + 5;
                                        cur_bet = 5;
                                        p1_betted = 5;
                                    end else begin
                                        p2_balance = p2_balance - 5;
                                        pot = pot + 5;
                                        cur_bet = 5;
                                        p2_betted = 5;
                                    end
                                end
                                cur_player = ~cur_player;
                            end
                        end
                        flop: begin
                            if (fold_p) begin
                                if (cur_player == p1)
                                    p2_balance = p2_balance + pot;
                                else
                                    p1_balance = p1_balance + pot;
                                pot = 0;
                                num_game_rounds = num_game_rounds + 1;
                                cur_player = (num_game_rounds % 2);
                                cur_bet = 0;
                                p1_betted = 0;
                                p2_betted = 0;
                                next_round = preflop; 
                            end else if (call_p) begin
                                if (cur_bet > 0) begin
                                    if (cur_player == p1) begin
                                        p1_balance = p1_balance - (cur_bet - p1_betted);
                                        pot = pot + (cur_bet - p1_betted);
                                        p1_betted = cur_bet;
                                    end else begin
                                        p2_balance = p2_balance - (cur_bet - p2_betted);
                                        pot = pot + (cur_bet - p2_betted);
                                        p2_betted = cur_bet;
                                    end
                                    cur_player = (num_game_rounds % 2);
                                    cur_bet = 0;
                                    p1_betted = 0;
                                    p2_betted = 0;
                                    next_round = turn;
                                end else begin
                                    if (cur_player == ~(num_game_rounds % 2)) begin
                                        next_round = turn;
                                        cur_player = (num_game_rounds % 2);
                                    end else
                                        cur_player = ~cur_player;
                                end
                            end else if (raise_p) begin
                                if (cur_bet > 0) begin
                                    if (cur_player == p1) begin
                                        p1_balance = p1_balance -((cur_bet - p1_betted) + 5);
                                        pot = pot + (cur_bet - p1_betted) + 5;
                                        cur_bet = cur_bet + 5;
                                        p1_betted = cur_bet;
                                    end else begin
                                        p2_balance = p2_balance -((cur_bet - p2_betted) + 5);
                                        pot = pot + (cur_bet - p2_betted) + 5;
                                        cur_bet = cur_bet + 5;
                                        p2_betted = cur_bet;
                                    end
                                end else begin
                                    if (cur_player == p1) begin
                                        p1_balance = p1_balance - 5;
                                        pot = pot + 5;
                                        cur_bet = 5;
                                        p1_betted = 5;
                                    end else begin
                                        p2_balance = p2_balance - 5;
                                        pot = pot + 5;
                                        cur_bet = 5;
                                        p2_betted = 5;
                                    end
                                end
                                cur_player = ~cur_player;
                            end
                        end
                        turn: begin
                            if (fold_p) begin
                                if (cur_player == p1)
                                    p2_balance = p2_balance + pot;
                                else
                                    p1_balance = p1_balance + pot;
                                pot = 0;
                                num_game_rounds = num_game_rounds + 1;
                                cur_player = (num_game_rounds % 2);
                                cur_bet = 0;
                                p1_betted = 0;
                                p2_betted = 0;
                                next_round = preflop; 
                            end else if (call_p) begin
                                if (cur_bet > 0) begin
                                    if (cur_player == p1) begin
                                        p1_balance = p1_balance - (cur_bet - p1_betted);
                                        pot = pot + (cur_bet - p1_betted);
                                        p1_betted = cur_bet;
                                    end else begin
                                        p2_balance = p2_balance - (cur_bet - p2_betted);
                                        pot = pot + (cur_bet - p2_betted);
                                        p2_betted = cur_bet;
                                    end
                                    cur_player = (num_game_rounds % 2);
                                    cur_bet = 0;
                                    p1_betted = 0;
                                    p2_betted = 0;
                                    next_round = river;
                                end else begin
                                    if (cur_player == ~(num_game_rounds % 2)) begin
                                        next_round = river;
                                        cur_player = (num_game_rounds % 2);
                                    end else
                                        cur_player = ~cur_player;
                                end
                            end else if (raise_p) begin
                                if (cur_bet > 0) begin
                                    if (cur_player == p1) begin
                                        p1_balance = p1_balance -((cur_bet - p1_betted) + 5);
                                        pot = pot + (cur_bet - p1_betted) + 5;
                                        cur_bet = cur_bet + 5;
                                        p1_betted = cur_bet;
                                    end else begin
                                        p2_balance = p2_balance -((cur_bet - p2_betted) + 5);
                                        pot = pot + (cur_bet - p2_betted) + 5;
                                        cur_bet = cur_bet + 5;
                                        p2_betted = cur_bet;
                                    end
                                end else begin
                                    if (cur_player == p1) begin
                                        p1_balance = p1_balance - 5;
                                        pot = pot + 5;
                                        cur_bet = 5;
                                        p1_betted = 5;
                                    end else begin
                                        p2_balance = p2_balance - 5;
                                        pot = pot + 5;
                                        cur_bet = 5;
                                        p2_betted = 5;
                                    end
                                end
                                cur_player = ~cur_player;
                            end
                        end
                        river: begin
                            if (fold_p) begin
                                if (cur_player == p1)
                                    p2_balance = p2_balance + pot;
                                else
                                    p1_balance = p1_balance + pot;
                                pot = 0;
                                num_game_rounds = num_game_rounds + 1;
                                cur_player = (num_game_rounds % 2);
                                cur_bet = 0;
                                p1_betted = 0;
                                p2_betted = 0;
                                next_round = preflop; 
                            end else if (call_p) begin
                                if (cur_bet > 0) begin
                                    if (cur_player == p1) begin
                                        p1_balance = p1_balance - (cur_bet - p1_betted);
                                        pot = pot + (cur_bet - p1_betted);
                                        p1_betted = cur_bet;
                                    end else begin
                                        p2_balance = p2_balance - (cur_bet - p2_betted);
                                        pot = pot + (cur_bet - p2_betted);
                                        p2_betted = cur_bet;
                                    end
                                    p1_balance = p1_balance + pot;
                                    pot = 0;
                                    num_game_rounds = num_game_rounds + 1;
                                    cur_player = (num_game_rounds % 2);
                                    cur_bet = 0;
                                    p1_betted = 0;
                                    p2_betted = 0;
                                    next_round = preflop;
                                end else begin
                                    if (cur_player == ~(num_game_rounds % 2)) begin
                                        p1_balance = p1_balance + pot;
                                        pot = 0;
                                        num_game_rounds = num_game_rounds + 1;
                                        cur_player = (num_game_rounds % 2);
                                        next_round = preflop;
                                    end else
                                        cur_player = ~cur_player;
                                end
                            end else if (raise_p) begin
                                if (cur_bet > 0) begin
                                    if (cur_player == p1) begin
                                        p1_balance = p1_balance -((cur_bet - p1_betted) + 5);
                                        pot = pot + (cur_bet - p1_betted) + 5;
                                        cur_bet = cur_bet + 5;
                                        p1_betted = cur_bet;
                                    end else begin
                                        p2_balance = p2_balance -((cur_bet - p2_betted) + 5);
                                        pot = pot + (cur_bet - p2_betted) + 5;
                                        cur_bet = cur_bet + 5;
                                        p2_betted = cur_bet;
                                    end
                                end else begin
                                    if (cur_player == p1) begin
                                        p1_balance = p1_balance - 5;
                                        pot = pot + 5;
                                        cur_bet = 5;
                                        p1_betted = 5;
                                    end else begin
                                        p2_balance = p2_balance - 5;
                                        pot = pot + 5;
                                        cur_bet = 5;
                                        p2_betted = 5;
                                    end
                                end
                                cur_player = ~cur_player;
                            end
                        end                                
                    endcase
                end
             endcase
         end
     end
                
    anode_cycle_main large_an_cycle(.clk(clk),.reset(reset_d),.i1(4'b0000), .i2(4'b0000), .i3(potdig2), .i4(potdig1), .led_output(pot_display),.an(an));
    convert_7seg convert_pot(.num(pot_display),.seg(seg), .invert(0));
    anode_cycle_p an_cycle_p1(.clk(clk),.reset(reset_d),.i1(p1_balanced1), .i2(p1_balanced2), .led_output(p1_balance_display),.an(an2));
    convert_7seg convert_p1(.num(p1_balance_display),.seg(seg2), .invert(1));
    anode_cycle_p an_cycle_p2(.clk(clk),.reset(reset_d),.i1(p2_balanced1), .i2(p2_balanced2), .led_output(p2_balance_display),.an(an3));
    convert_7seg convert_p2(.num(p2_balance_display),.seg(seg3), .invert(1));
    
    prng rng(.clk(clk),.rst(reset_d),.num(rngout));
    
    always @(posedge clk_sec)
        random_num = rngout;
    
    
endmodule
