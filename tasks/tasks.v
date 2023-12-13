task reset;

begin
    clk=0; rst=0; coin_insert=0; double_wash=0; lid=0;
    #10 clk=0; rst=1; coin_insert=0; double_wash=0; lid=0;
end

endtask


task drive;

begin
    @(posedge clk)
    coin_insert=1;
    @(posedge clk)
    coin_insert=0;
    @(posedge laundry_done)

    @(posedge clk)
    coin_insert=1;
    double_wash=1;
    @(posedge clk)
    coin_insert=0;
    @(posedge laundry_done)
    double_wash=0;

    @(posedge clk)
    coin_insert=1;
    double_wash=1;
    @(posedge clk)
    coin_insert=0;
    repeat (20)begin
        @(posedge clk);
    end
    lid=1;
    repeat (10) begin
        @(posedge clk);
    end
    lid=0;
    repeat(62) begin
        @(posedge clk);
        
    end 
    lid=1;
    repeat(10) begin
        @(posedge clk);
    end
    lid=0;
    @(posedge laundry_done)
    double_wash=0;


    @(posedge clk)
    coin_insert=1;
    double_wash=1;
    @(posedge clk)
    coin_insert=0;
    repeat (20)begin
        @(posedge clk);
    end
    lid=1;
    repeat (10) begin
        @(posedge clk);
    end
    lid=0;
    repeat(62) begin
        @(posedge clk);
        
    end 
    lid=1;
    repeat(10) begin
        @(posedge clk);
    end
    lid=0;
    @(posedge laundry_done)
    double_wash=0;

end

endtask