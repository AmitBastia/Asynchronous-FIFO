`timescale 1ns / 1ps
module async_fifo #(parameter data_width=8)(
    input wr_clk,
    input rd_clk,
    input rst,
    input wr,
    input rd,
    input [data_width-1:0] wdata,
    output reg [data_width-1:0] rdata,
    output reg valid,
    output empty,
    output full,
    output reg overflow,
    output reg underflow
);

parameter fifo_depth   = 8;
parameter address_size = 4; 

reg [address_size-1:0] wr_pointer, wr_pntr_g_s1, wr_pntr_g_s2;
reg [address_size-1:0] rd_pointer, rd_pntr_g_s1, rd_pntr_g_s2;
wire [address_size-1:0] wr_pntr_g;
wire [address_size-1:0] rd_pntr_g;

reg [data_width-1:0] mem [fifo_depth-1:0];


always @(posedge wr_clk) begin
    if (rst)
        wr_pointer <= 0;
    else if (wr && !full) begin
        wr_pointer <= wr_pointer + 1;
        mem[wr_pointer[address_size-2:0]] <= wdata; // only need depth-indexing bits
    end
end


always @(posedge rd_clk) begin
    if (rst)
        rd_pointer <= 0;
    else if (rd && !empty) begin
        rd_pointer <= rd_pointer + 1;
        rdata      <= mem[rd_pointer[address_size-2:0]];
    end
end


assign wr_pntr_g = wr_pointer ^ (wr_pointer >> 1);
assign rd_pntr_g = rd_pointer ^ (rd_pointer >> 1);


always @(posedge rd_clk) begin
    if (rst) begin
        wr_pntr_g_s1 <= 0;
        wr_pntr_g_s2 <= 0;
    end else begin
        wr_pntr_g_s1 <= wr_pntr_g;
        wr_pntr_g_s2 <= wr_pntr_g_s1;
    end
end

always @(posedge wr_clk) begin
    if (rst) begin
        rd_pntr_g_s1 <= 0;
        rd_pntr_g_s2 <= 0;
    end else begin
        rd_pntr_g_s1 <= rd_pntr_g;
        rd_pntr_g_s2 <= rd_pntr_g_s1;
    end
end


assign empty = (rd_pntr_g == wr_pntr_g_s2);


assign full = (wr_pntr_g[address_size-1]   != rd_pntr_g_s2[address_size-1]) &&
              (wr_pntr_g[address_size-2]   != rd_pntr_g_s2[address_size-2]) &&
              (wr_pntr_g[address_size-3:0] == rd_pntr_g_s2[address_size-3:0]);


always @(posedge wr_clk) begin
    if (rst)
        overflow <= 0;
    else
        overflow <= full && wr;
end

always @(posedge rd_clk) begin
    if (rst) begin
        underflow <= 0;
        valid     <= 0;
    end else begin
        underflow <= empty && rd;
        valid     <= rd && !empty;
    end
end

endmodule
