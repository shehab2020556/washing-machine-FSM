module fsm #(
    parameter max_count=10
) (
    input   wire        clk,rst,
    input   wire        coin_insert,double_wash,lid,
    output  wire         laundry_done,double_wash_done,lid_done
    // output  reg [2:0]   current_state
    // output  reg          count_enable,count_2_enable,lid_reg_enable,
    // output  reg          double_wash_enable,double_wash_rinse_flag_enable,double_wash_wash_flag_enable,
    // output  reg          double_wash_rinse_flag,double_wash_wash_flag,
    // input   wire         count_done,count_2_done,double_wash_rinse_flag_reg,double_wash_wash_flag_reg,double_wash_done_reg
);

reg          laundry_done_comp,double_wash_done_comp,lid_done_comp;
reg          count_enable,count_2_enable,lid_reg_enable;
reg          double_wash_enable,double_wash_rinse_flag_enable,double_wash_wash_flag_enable;
reg          double_wash_rinse_flag,double_wash_wash_flag;
wire         count_done,count_2_done,double_wash_rinse_flag_reg,double_wash_wash_flag_reg;
wire         count_done_pre,count_done_pre_x,lid_done_reg;

localparam wait_state = 3'b000 , soak_state=3'b001 , washing_state=3'b010 , rinse_state=3'b011 , spin_state=3'b100 ;

reg [2:0] next_state,current_state;


always @(posedge clk or negedge rst) begin
    if (!rst) begin
        current_state <= wait_state;
    end    
    else begin
        current_state <= next_state;
    end
end

always @(*) begin

    case (current_state)
        wait_state:begin
            if(coin_insert) begin
                next_state=soak_state;
            end
            else begin
                next_state=wait_state;
            end
        end 
        soak_state:begin
            if(count_done) begin
                next_state=washing_state;
            end
            else begin
                next_state=soak_state;
            end
        end 
        washing_state:begin
            if(count_2_done) begin
                next_state=rinse_state;
            end
            else begin
                next_state=washing_state;
            end
        end 

        rinse_state:begin
            if(count_done &&( double_wash && ~double_wash_done) ) begin
                next_state=washing_state;
            end
            else if (count_done && (~double_wash || double_wash_done) ) begin
                next_state=spin_state;                
            end
            else begin
                next_state=rinse_state;
            end
        end 

        spin_state:begin
            if (count_done) begin
                next_state=wait_state;
            end
            else begin
                next_state=spin_state;
            end
        end

    
        default: next_state = wait_state;
    endcase

end


always @(*) begin
    case (current_state)
        wait_state : begin
            laundry_done_comp=0;
            count_enable=0;
            count_2_enable=0;
            lid_reg_enable=1;
            lid_done_comp=0;
            double_wash_enable=1;
            double_wash_done_comp=0;
            double_wash_rinse_flag_enable=1;
            double_wash_rinse_flag=0;
            double_wash_wash_flag_enable=1;
            double_wash_wash_flag=0;
            
        end 

        soak_state : begin
            laundry_done_comp=0;
            count_enable=1;
            count_2_enable=0;
            lid_reg_enable=0;
            lid_done_comp=0;
            double_wash_enable=0;
            double_wash_done_comp=0;
            double_wash_rinse_flag_enable=0;
            double_wash_rinse_flag=0;
            double_wash_wash_flag_enable=0;
            double_wash_wash_flag=0;
            
        end

        washing_state : begin
            laundry_done_comp=0;
            count_enable=1;
            count_2_enable=1;
            lid_reg_enable=0;
            lid_done_comp=0;
            double_wash_enable=0;
            double_wash_done_comp=0;

            double_wash_rinse_flag_enable=0;
            double_wash_rinse_flag=0;

            if (double_wash_rinse_flag_reg) begin
                double_wash_wash_flag_enable=1;
                double_wash_wash_flag=1;
            end
            else begin
                double_wash_wash_flag_enable=0;
                double_wash_wash_flag=0;
            end

            
        end

        rinse_state : begin
            laundry_done_comp=0;
            count_enable=1;
            count_2_enable=0;
            lid_reg_enable=0;
            lid_done_comp=0;
            if (double_wash_wash_flag_reg && count_done_pre) begin
                double_wash_enable=1;
                double_wash_done_comp=1;
            end
            else begin
                double_wash_enable=0;
                double_wash_done_comp=0;
            end
            if (double_wash) begin
                double_wash_rinse_flag_enable=1;
                double_wash_rinse_flag=1;
            end
            else begin
                double_wash_rinse_flag_enable=0;
                double_wash_rinse_flag=0;
            end

            double_wash_wash_flag_enable=0;
            double_wash_wash_flag=0;


        end
        spin_state : begin
            if (count_done) begin
                laundry_done_comp=1;
            end
            else begin
                laundry_done_comp=0;
            end

            if (lid ) begin
                count_enable=0;
                lid_reg_enable=1;
                lid_done_comp=1;                
            end
            else begin
                count_enable=1;
                lid_reg_enable=0;
                lid_done_comp=0;
            end
            count_2_enable=0;
            double_wash_enable=0;
            double_wash_done_comp=0;
            double_wash_rinse_flag_enable=0;
            double_wash_rinse_flag=0;
            double_wash_wash_flag_enable=0;
            double_wash_wash_flag=0;
            
        end
        default: begin
            laundry_done_comp=0;
            count_enable=0;
            count_2_enable=0;
            lid_reg_enable=1;
            lid_done_comp=0;
            double_wash_enable=1;
            double_wash_done_comp=0;
            double_wash_rinse_flag_enable=1;
            double_wash_rinse_flag=0;
            double_wash_wash_flag_enable=1;
            double_wash_wash_flag=0;
            
        end
    endcase
    
end






register #(.bus_width(1)) d0 (.d(laundry_done_comp),.clk(clk),.rst(rst),.enable(1'b1),.q(laundry_done));

register #(.bus_width(1)) d1 (.d(double_wash_done_comp),.clk(clk),.rst(rst),.enable(double_wash_enable),.q(double_wash_done));

register #(.bus_width(1)) d2 (.d(lid_done_comp),.clk(clk),.rst(rst),.enable(lid_reg_enable),.q(lid_done_reg));

register #(.bus_width(1)) d3 (.d(double_wash_rinse_flag),.clk(clk),.rst(rst),.enable(double_wash_rinse_flag_enable),.q(double_wash_rinse_flag_reg));

register #(.bus_width(1)) d4 (.d(double_wash_wash_flag),.clk(clk),.rst(rst),.enable(double_wash_wash_flag_enable),.q(double_wash_wash_flag_reg));



counter #(
    .max_count(max_count-1)
) counter_0 (
    .en(count_enable),
    .clk(clk),
    .rst(rst),
    .count_done(count_done),
    .count_done_pre(count_done_pre)
);


counter #(
    .max_count(3)
) counter_1 (
    .en(count_2_enable&count_done_pre),
    .clk(clk),
    .rst(rst),
    .count_done(count_2_done),
    .count_done_pre(count_done_pre_x)
);
    
assign lid_done = ~lid&lid_done_reg;

    
endmodule