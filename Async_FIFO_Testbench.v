`timescale 1ns/1ps
module async_fifo_tb;

parameter data_width = 8;

reg wr_clk;
reg rd_clk;
reg rst;
reg wr;
reg rd;
reg [data_width-1:0] wdata;
wire [data_width-1:0] rdata;
wire valid;
wire empty;
wire full;
wire overflow;
wire underflow;

// Instantiated DUT
async_fifo #(data_width) DUT (
    .wr_clk(wr_clk),
    .rd_clk(rd_clk),
    .rst(rst),
    .wr(wr),
    .rd(rd),
    .wdata(wdata),
    .rdata(rdata),
    .valid(valid),
    .empty(empty),
    .full(full),
    .overflow(overflow),
    .underflow(underflow)
);

initial begin
    wr_clk = 0;
    forever #5 wr_clk = ~wr_clk;   
end
initial begin
    rd_clk = 0;
    forever #7 rd_clk = ~rd_clk;  
end

initial begin
    $dumpfile("async_fifo_tb.vcd");
    $dumpvars(0, async_fifo_tb);

    rst = 1;
    wr  = 0;
    rd  = 0;
    wdata = 0;
    #20;
    rst = 0;


    #10;
    rd = 1;   
    #20;
    rd = 0;

 
    #10;
    @(posedge wr_clk); wr = 1; wdata = 8'hA1;
    @(posedge wr_clk); wdata = 8'hB2;
    @(posedge wr_clk); wdata = 8'hC3;
    @(posedge wr_clk); wdata = 8'hD4;
    @(posedge wr_clk); wdata = 8'hE5;
    @(posedge wr_clk); wdata = 8'hF6;
    @(posedge wr_clk); wdata = 8'h07;
    @(posedge wr_clk); wdata = 8'h18;
    @(posedge wr_clk); wr = 0;
    
    #10;
    @(posedge wr_clk); wr = 1; wdata = 8'hFF;   
    @(posedge wr_clk); wr = 0;
 
    #40;
    @(posedge rd_clk); rd = 1;
    @(posedge rd_clk);
    @(posedge rd_clk);
    @(posedge rd_clk);
    @(posedge rd_clk);
    @(posedge rd_clk);
    @(posedge rd_clk);
    @(posedge rd_clk);
    @(posedge rd_clk); rd = 0;   
    #30;
    rst = 1;
    #20;
    rst = 0;
    #100;
    $finish;
end

endmodule
