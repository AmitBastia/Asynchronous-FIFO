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

// Generated asynchronous clocks
initial begin
    wr_clk = 0;
    forever #5 wr_clk = ~wr_clk;   // 10ns period
end

initial begin
    rd_clk = 0;
    forever #7 rd_clk = ~rd_clk;   // 14ns period
end

initial begin
    $dumpfile("async_fifo_tb.vcd");
    $dumpvars(0, async_fifo_tb);

    // Checking functionality in Reset
    rst = 1;
    wr = 0;
    rd = 0;
    wdata = 0;
    #20;
    rst = 0;

    // Checking functionality in underflow
    #10;
    rd = 1;   // trying to read empty FIFO
    #20;
    rd = 0;

    // Writing into FIFO memory
    #10;
    repeat (5) begin
        @(posedge wr_clk);
        wr = 1;
        wdata = $random;
    end
    @(posedge wr_clk);
    wr = 0;

    // Reading from FIFO memory
    #20;
    repeat (5) begin
        @(posedge rd_clk);
        rd = 1;
    end
    @(posedge rd_clk);
    rd = 0;

    // Checking functionality in Overflow condition
    #20;
    repeat (12) begin   // write more than depth (8)
        @(posedge wr_clk);
        wr = 1;
        wdata = $random;
    end
    @(posedge wr_clk);
    wr = 0;

    // Checking functionality in Reset during operation
    #30;
    rst = 1;
    #20;
    rst = 0;

    // Finish
    #100;
    $finish;
end

endmodule
