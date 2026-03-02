`timescale 1ns / 1ps

module async_fifo #(parameter data_width=8)( input wr_clk,
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
                   output reg underflow);

parameter fifo_depth= 8;
parameter address_size= 4;
reg [address_size-1:0] wr_pointer, wr_pntr_g_s1, wr_pntr_g_s2;
reg [address_size-1:0] rd_pointer, rd_pntr_g_s1, rd_pntr_g_s2;
wire [address_size-1:0] wr_pntr_g;
wire [address_size-1:0] rd_pntr_g;

//declaring 2d array for fifo memory
reg [data_width-1:0] mem [fifo_depth-1:0];

//writing data into FIFO
always @(posedge wr_clk) begin
if(rst) 
wr_pointer <= 0;
else begin
if (wr && !full) begin
wr_pointer <= wr_pointer +1;
mem[wr_pointer] <= wdata;
end
end
end

// reading data from FIFO
always @(posedge rd_clk) begin
if(rst) 
rd_pointer <= 0;
else begin
if (rd && !full) begin
rd_pointer <= rd_pointer +1;
rdata <= mem[rd_pointer];
end
end
end

//wr_pointer and rd_pointer binary to gray
assign wr_pntr_g = wr_pointer ^ (wr_pointer>>1);
assign rd_pntr_g = rd_pointer ^ (rd_pointer>>1);

//2 stage synchronizer for wr_pointer wrt rd_clk
always @(posedge rd_clk) begin
if(rst) begin
wr_pntr_g_s1 <= 0;
wr_pntr_g_s2 <= 0;
end
else begin
wr_pntr_g_s1 <= wr_pntr_g;      // 1st FF
wr_pntr_g_s2 <= wr_pntr_g_s1;   // 2nd FF
end
end

always @(posedge wr_clk) begin
if(rst) begin
rd_pntr_g_s1 <= 0;
rd_pntr_g_s2 <= 0;
end
else begin
rd_pntr_g_s1 <= rd_pntr_g;      // 1st FF
rd_pntr_g_s2 <= rd_pntr_g_s1;   // 2nd FF
end
end


// empty condition
assign empty = (rd_pntr_g == wr_pntr_g_s2);
assign full = (wr_pntr_g[address_size-1] != rd_pntr_g_s2[address_size-1]) && 
              (wr_pntr_g[address_size-2] != rd_pntr_g_s2[address_size-2]) &&
              (wr_pntr_g[address_size-3] != rd_pntr_g_s2[address_size-3]);
              
 //overflow
 always @(posedge wr_clk)
 overflow = full && wr;
 always @(posedge rd_clk) begin
 underflow <= empty && rd;
 valid <= (rd && !empty);
 end
 

endmodule
