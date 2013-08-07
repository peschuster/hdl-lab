// Integrated Electronic Systems Lab
// TU Darmstadt
// Author:	Dipl.-Ing. Boris Traskov
// Email: 	boris.traskov@ies.tu-darmstadt.de

`timescale 1 ns / 1 ps

module memory(
	clk,
	en,
	rd_en,
	wr_en,
	addr,
	din,
	dout
);

//stores this many halfwords (1halfword=16bit=2Byte)
parameter	MEM_DEPTH	= 2**12;

//addresses this many Bytes (1Byte = 8bit)
localparam	ADDR_WIDTH	= $clog2(MEM_DEPTH*2);

// PORTS
input	logic						clk;
input	logic						en;
input	logic						rd_en;
input	logic [0:1]					wr_en;
input	logic [0:1][7:0]			din;
output	logic [0:1][7:0]			dout;
input	logic      [ADDR_WIDTH-1:0] addr;

// MEM ARRAY AND INTERNAL SIGNALS
logic [0:1][7:0] ram [0:MEM_DEPTH-1];
logic [0:1][7:0] wr_halfword;
integer wr_i;

// WR_EN DECODER
always_comb begin
	wr_halfword = ram[addr[ADDR_WIDTH-1:1]];
	for(wr_i=0; wr_i<2; wr_i=wr_i+1) begin
		if (wr_en[wr_i]==1'b1) begin
			wr_halfword[wr_i] = din[wr_i];
		end
	end
end

// REGISTERED WRITE
always_ff@(posedge clk) begin
	if (en==1'b1) begin
		ram[addr[ADDR_WIDTH-1:1]] <= wr_halfword;
	end
end

// REGISTERED READ
always_ff@(posedge clk) begin
	if (en==1'b1) begin
		if (rd_en==1'b1) begin
			dout <= ram[addr[ADDR_WIDTH-1:1]];
		end
	end
end

endmodule
