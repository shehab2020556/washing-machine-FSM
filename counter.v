module counter #(
    parameter max_count = 3,
    parameter reg_number = $clog2(max_count)
) (
    input en,clk,rst,
    // output reg [reg_number-1:0] count,
    output wire count_done,count_done_pre
);
    
reg [reg_number-1:0] count;

always @(posedge clk or negedge rst) begin
    if (!rst || count_done) begin
        count <= 'b0;        
    end
    else if (en) begin
        count <= count +1;        
    end
end

assign count_done = (count == max_count);
assign count_done_pre = (count == max_count-1);

endmodule