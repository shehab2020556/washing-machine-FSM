`timescale 1us/1ps

module tb ();

reg        clk,rst;
reg        coin_insert,double_wash,lid;
wire       laundry_done,double_wash_done,lid_done;


fsm #(
    .max_count(10)
) dut (
    .clk(clk),
    .rst(rst),
    .coin_insert(coin_insert),
    .double_wash(double_wash),
    .lid(lid),
    .laundry_done(laundry_done),
    .double_wash_done(double_wash_done),
    .lid_done(lid_done)
);

`include "tasks/tasks.v"

always #5 clk=~clk;

initial begin
    reset();
    drive();
end
    


endmodule