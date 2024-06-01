module shuf(clk, rst, card1, card2, card3, card4, card5, card6, card7);

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
    
    reg [7:0] rng_buf [51:0];
    
    reg [5:0] cards [51:0];
    reg [5:0] temp;
    
    integer i;
    integer j;
    integer k;
    integer l;
    
    initial begin
        for (j = 0; j < 52; j = j+1)
            rng_buf[j] = 0;
        for (j = 0; j < 52; j = j+1)
            cards[j] = j;
    end
    
    prng rng_source(clk,rst,random_num);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 52; i = i+1)
                rng_buf[i] <= 8'b0;
        end else begin 
            for (i = 51; i > 0; i = i-1) begin
                rng_buf[i] <= rng_buf[i-1];
            end
            rng_buf[0] <= random_num;
        end
    end
    
    // https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle
    always @(posedge clk) begin
        for (k = 51; k >= 1; k = k-1) begin
            l = rng_buf[k] % k;
            temp = cards[l];
            cards[l] = cards[k];
            cards[k] = temp;
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