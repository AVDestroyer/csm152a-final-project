module top (clk, btnR, sw, btnU, btnL, btnC, btnD, seg, an, seg2, an2, seg3, an3);
    input clk;
    input btnR;
    input [3:0] sw;
    input btnU;
    input btnL;
    input btnC;
    input btnD;
    output wire [6:0] seg;
    output wire [3:0] an;
    output wire [6:0] seg2;
    output wire [0:0] an2;
    output wire [6:0] seg3;
    output wire [0:0] an3;
        
    wire reset_d;
    wire cashout_d;
    wire fold_d;
    wire fold_p;
    wire call_d;
    wire call_p;
    wire raise_d;
    wire raise_p;
    wire freeze_d;
    wire freeze_ff;
    wire pubcards_d;
    wire p1cards_d;
    wire p2cards_d;
    wire [0:0] win;
    wire [0:0] tie;

    debounce reset_debounce(.clk(clk),.in(btnR),.out(reset_d));
    debounce cashout_debounce(.clk(clk),.in(sw[0]),.out(cashout_d));
    debounce fold_debounce(.clk(clk),.in(btnU),.out(fold_d));
    monostable fold_pulse(.clk(clk),.in(fold_d),.out(fold_p));
    debounce checkcall_debounce(.clk(clk),.in(btnL),.out(call_d));
    monostable checkcall_pulse(.clk(clk),.in(call_d),.out(call_p));
    debounce raisebet_debounce(.clk(clk),.in(btnC),.out(raise_d));
    monostable raisebet_pulse(.clk(clk),.in(raise_d),.out(raise_p));
    debounce freeze_debounce(.clk(clk),.in(btnD),.out(freeze_d));
    flipflop freezeff(.clk(clk),.rst(reset_d),.in(freeze_d),.out(freeze_ff));
    debounce pubcards_debounce(.clk(clk),.in(sw[1]),.out(pubcards_d));
    debounce p1cards_debounce(.clk(clk),.in(sw[2]),.out(p1cards_d));
    debounce p2cards_debounce(.clk(clk),.in(sw[3]),.out(p2cards_d));

    parameter playing = 2'b00;
    parameter cashout = 2'b01;
    parameter loading = 2'b10;
    parameter freeze = 2'b11;
    reg [1:0] game_state = loading;
    reg [1:0] next_game_state = loading;
    reg [1:0] saved_game_state = playing;
    reg [5:0] counter = 6'b000000;
    reg start_game = 0;
    
    parameter preflop = 3'b0;
    parameter flop = 3'b1;
    parameter turn = 3'b10;
    parameter river = 3'b11;
    reg [1:0] current_round = preflop;
    reg [1:0] next_round = preflop;
    
    reg cur_player = 0;
    parameter p1 = 0;
    parameter p2 = 1;
    reg [7:0] num_game_rounds = 0;
    wire start_player = num_game_rounds % 2;
    reg [6:0] p1_balance = 49;
    reg [6:0] p2_balance = 49;
    wire [4:0] p1_balanced1;
    wire [4:0] p1_balanced2;
    wire [4:0] p2_balanced1;
    wire [4:0] p2_balanced2;
    assign p1_balanced1 = p1_balance / 10;
    assign p1_balanced2 = p1_balance % 10;
    assign p2_balanced1 = p2_balance / 10;
    assign p2_balanced2 = p2_balance % 10;
    reg [6:0] pot = 0;
    wire [4:0] potdig1;
    wire [4:0] potdig2;
    assign potdig1 = pot / 10;
    assign potdig2 = pot % 10;
    reg [6:0] cur_bet = 0;
    reg [6:0] p1_betted = 0;
    reg [6:0] p2_betted = 0;
    
    wire [4:0] main_display;
    wire [4:0] p1_display;
    wire [4:0] p2_display;
    
    reg reset_game = 0;
    
    wire [5:0] c1;
    wire [5:0] c2;
    wire [5:0] c3;
    wire [5:0] c4;
    wire [5:0] c5;
    wire [5:0] c6;
    wire [5:0] c7;
    reg [5:0] card1 = 0;
    reg [5:0] card2 = 0;
    reg [5:0] card3 = 0;
    reg [5:0] card4 = 0;
    reg [5:0] card5 = 0;
    reg [5:0] card6 = 0;
    reg [5:0] card7 = 0;

    shuffle shuf_cards(.clk(clk), .rst(reset_d), .card1(c1), .card2(c2), .card3(c3), .card4(c4), .card5(c5), .card6(c6), .card7(c7));
    poker game (.a1(card1), .a2(card2), .a3(card3), .a4(card4), .a5(card5), .b1(card1), .b2(card2), .b3(card3), .b4(card6), .b5(card7), .win(win), .tie(tie));
    wire [4:0] carddisplay_1;
    wire [4:0] carddisplay_2;
    wire [4:0] carddisplay_3;
    wire [4:0] carddisplay_4;
    wire [4:0] p1card_1;
    wire [4:0] p1card_2;
    wire [4:0] p2card_1;
    wire [4:0] p2card_2;   
    
    reg [4:0] maindisplay_1 = 0;
    reg [4:0] maindisplay_2 = 0;
    reg [4:0] maindisplay_3 = 0;
    reg [4:0] maindisplay_4 = 0;
    reg [4:0] p1display_1 = 0;
    reg [4:0] p1display_2 = 0;
    reg [4:0] p2display_1 = 0;
    reg [4:0] p2display_2 = 0;
    
    reg p1_drawcards = 0;
    reg p2_drawcards = 0;
    
    always @(posedge clk) begin
        counter = counter + 1;
        if (counter >= 53)
            start_game = 1;
    end
    
    always @(posedge clk) begin
        case (game_state)
            loading: begin
                if (start_game)
                    next_game_state = playing;
            end
            playing: begin
                reset_game = 0;
                if (freeze_ff == 1'b1) begin
                    next_game_state = freeze;
                    saved_game_state = playing;
                end
                else if (cashout_d == 1'b1 && next_round == preflop)
                    next_game_state = cashout;
                else
                    next_game_state = playing;
            end
            cashout: begin
                if (freeze_ff == 1'b1) begin
                    next_game_state = freeze;
                    saved_game_state = cashout;
                end
                else if (cashout_d == 1'b0) begin
                    next_game_state = playing;
                    reset_game = 1;
                end else
                    next_game_state = cashout;
            end
            freeze: begin
                if (freeze_ff == 1'b0)
                    next_game_state = saved_game_state;
                else
                    next_game_state = freeze;
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
            if (current_round == preflop && next_round == flop) begin
                card1 = c1;
                card2 = c2;
                card3 = c3;
            end
            current_round = next_round;
        end
    end
        
    always @(posedge clk) begin
        if (reset_d || reset_game) begin
            p1_balance <= 49;
            p2_balance <= 49;
            num_game_rounds <= 0;
            cur_bet <= 0;
            pot <= 0;
            p1_betted <= 0;
            p2_betted <= 0;
            next_round <= preflop;
            cur_player <= p1;
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
                                pot = 1;
                                cur_player = start_player;
                                num_game_rounds = num_game_rounds + 1;
                                cur_bet = 1;
				if (cur_player == p1) begin
				    p1_betted = 1; p2_betted = 0;
				end else begin
				    p2_betted = 1; p1_betted = 1;
				end
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
                                    cur_player = start_player;
                                    cur_bet = 0;
                                    p1_betted = 0;
                                    p2_betted = 0;
                                    next_round = flop;
                                end else begin
                                    if (cur_player == ~start_player) begin
                                        next_round = flop;
                                        cur_player = start_player;
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
                                pot = 1;
                                cur_player = start_player;
                                num_game_rounds = num_game_rounds + 1;
                                cur_bet = 1;
				if (cur_player == p1) begin
				    p1_betted = 1; p2_betted = 0;
				end else begin
				    p2_betted = 1; p1_betted = 1;
				end
                                next_round = preflop; 
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
                                    cur_player = start_player;
                                    cur_bet = 0;
                                    p1_betted = 0;
                                    p2_betted = 0;
                                    next_round = turn;
                                end else begin
                                    if (cur_player == ~start_player) begin
                                        next_round = turn;
                                        cur_player = start_player;
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
                                pot = 1;
                                cur_player = start_player;
                                num_game_rounds = num_game_rounds + 1;
                                cur_bet = 1;
				if (cur_player == p1) begin
				    p1_betted = 1; p2_betted = 0;
				end else begin
				    p2_betted = 1; p1_betted = 1;
				end
                                next_round = preflop; 
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
                                    cur_player = start_player;
                                    cur_bet = 0;
                                    p1_betted = 0;
                                    p2_betted = 0;
                                    next_round = river;
                                end else begin
                                    if (cur_player == ~start_player) begin
                                        next_round = river;
                                        cur_player = start_player;
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
                                pot = 1;
                                cur_bet = 1;
				if (cur_player == p1) begin
				    p1_betted = 1; p2_betted = 0;
				end else begin
				    p2_betted = 1; p1_betted = 1;
				end
                                next_round = preflop; 
                                cur_player = start_player;
                                num_game_rounds = num_game_rounds + 1;
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
				    if (tie == 1) begin
                                        p1_balance = p1_balance + pot/2;
                                        p2_balance = p2_balance + pot/2;
				    end else if (win == 1) begin
                                        p1_balance = p1_balance + pot;
				    end else begin
                                        p2_balance = p2_balance + pot;
			            end
                                    pot = 0;
                                    num_game_rounds = num_game_rounds + 1;
                                    cur_player = start_player;
                                    cur_bet = 0;
                                    p1_betted = 0;
                                    p2_betted = 0;
                                    next_round = preflop;
                                end else begin
                                    if (cur_player == ~start_player) begin
					if (tie == 1) begin
                                            p1_balance = p1_balance + pot/2;
                                            p2_balance = p2_balance + pot/2;
					end else if (win == 1) begin
                                            p1_balance = p1_balance + pot;
					end else begin
                                            p2_balance = p2_balance + pot;
					end
                                        pot = 0;
                                        num_game_rounds = num_game_rounds + 1;
                                        cur_player = start_player;
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
     
     maincard_display card_nums(.clk(clk), .rst(reset_d), .num(current_round), .card1(card1), .card2(card2), .card3(card3), .outdig1(carddisplay_1), .outdig2(carddisplay_2), .outdig3(carddisplay_3), .outdig4(carddisplay_4));
     pcard_display p1_card_nums(.clk(clk), .rst(reset_d), .card1(card4), .card2(card5), .outdig1(p1card_1), .outdig2(p1card_2));
     pcard_display p2_card_nums(.clk(clk), .rst(reset_d), .card1(card6), .card2(card7), .outdig1(p2card_1), .outdig2(p2card_2));
    
     always @(posedge clk) begin
        if (game_state == playing && current_round != preflop && pubcards_d) begin
            //dp = ~dp;
            maindisplay_1 = carddisplay_1;
            maindisplay_2 = carddisplay_2;
            maindisplay_3 = carddisplay_3;
            maindisplay_4 = carddisplay_4;
        end else begin
            maindisplay_1 = current_round;
            maindisplay_2 = cur_player;
            maindisplay_3 = potdig1;
            maindisplay_4 = potdig2;
        end
     end
     
     always @(posedge clk) begin
        if (game_state == playing && p1cards_d) begin
            p1display_1 = p1card_2;
            p1display_2 = p1card_1;
        end else begin
            p1display_1 = p1_balanced2;
            p1display_2 = p1_balanced1;
        end
     end
     
     always @(posedge clk) begin
        if (game_state == playing && p2cards_d) begin
            p2display_1 = p2card_2;
            p2display_2 = p2card_1;
        end else begin
            p2display_1 = p2_balanced2;
            p2display_2 = p2_balanced1;
        end
     end
     
     always @(posedge clk) begin
        if (reset_d || reset_game) begin
            card4 = 0;
            card5 = 0;
            p1_drawcards = 0;
        end else if (game_state == playing && p1cards_d && (!p1_drawcards)) begin
            card4 = c4;
            card5 = c5;
            p1_drawcards = 1;
        end
    end
    
    always @(posedge clk) begin
       if (reset_d || reset_game) begin
           card6 = 0;
           card7 = 0;
           p2_drawcards = 0;
       end else if (game_state == playing && p2cards_d && (!p2_drawcards)) begin
           card6 = c6;
           card7 = c7;
           p2_drawcards = 1;
       end
   end
                 
    anode_cycle_main large_an_cycle(.clk(clk),.reset(reset_d),.i1(maindisplay_4), .i2(maindisplay_3), .i3(maindisplay_2), .i4(maindisplay_1), .led_output(main_display),.an(an));
    convert_7seg convert_pot(.num(main_display),.seg(seg), .invert(0));
    anode_cycle_p an_cycle_p1(.clk(clk),.reset(reset_d),.i1(p1display_1), .i2(p1display_2), .led_output(p1_display),.an(an2));
    convert_7seg convert_p1(.num(p1_display),.seg(seg2), .invert(1));
    anode_cycle_p an_cycle_p2(.clk(clk),.reset(reset_d),.i1(p2display_1), .i2(p2display_2), .led_output(p2_display),.an(an3));
    convert_7seg convert_p2(.num(p2_display),.seg(seg3), .invert(1));
    
    
    
endmodule
