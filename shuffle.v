module shuffle(clk, rst, card1, card2, card3, card4, card5, card6, card7);

    input clk;
    input rst;
    
    output wire [5:0] card1;
    output wire [5:0] card2;
    output wire [5:0] card3;
    output wire [5:0] card4;
    output wire [5:0] card5;
    output wire [5:0] card6;
    output wire [5:0] card7;
    
    wire [7:0] random_num;
    
    reg [7:0] rng_buf [6:0];
    
    reg [5:0] cards [6:0];
    
    integer i;
    integer j;
    integer k;
    
    initial begin
        for (j = 0; j < 7; j = j+1)
            rng_buf[j] = 0;
        for (j = 0; j < 7; j = j+1)
            cards[j] = j;
    end
    
    prng rng_source(.clk(clk),.rst(rst),.num(random_num));
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 7 ; i = i+1)
                rng_buf[i] <= 8'b0;
        end else begin 
            for (i = 6 ; i > 0; i = i-1) begin
                rng_buf[i] <= rng_buf[i-1];
            end
            rng_buf[0] <= random_num;
        end
    end
    
    //https://stackoverflow.com/questions/2394246/algorithm-to-select-a-single-random-combination-of-values
    always @(posedge clk) begin
        for (k = 0; k < 7; k = k + 1) begin
            cards[k] = rng_buf[k] % 52;
        end
    end
    
    assign card1 = cards[0];
    assign card2 = cards[1];
    assign card3 = cards[2];
    assign card4 = cards[3];
    assign card5 = cards[4];
    assign card6 = cards[5];
    assign card7 = cards[6];
    
    
endmodule