module register #(
    parameter bus_width=1
) (
    input  wire [bus_width-1:0] d,
    input  wire                 clk,rst,enable,
    output reg  [bus_width-1:0] q
);

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        q<=0;
    end
    else if(enable==1) begin
        q<=d;
    end
    else begin
        q<=q;
    end

end

    
endmodule