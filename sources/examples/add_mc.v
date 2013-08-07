// Integrated Electronic Systems Lab
// TU Darmstadt
// Author:	Dipl.-Ing. Boris Traskov
// Email: 	boris.traskov@ies.tu-darmstadt.de

`timescale 1 ns / 1 ps

module add_mc (clk, rst, sel, a, b, c, r);

// PARAMETERS
parameter STAGES = 3;

// INPUTS
input clk;
input rst;
input wire			sel;
input wire [31:0]	a;
input wire [31:0]	b;
input wire			c;
output wire [31:0]	r;

reg [31:0] alu_out[0:STAGES];
integer stage;
// DFF, synch reset
	
	
always @(*) begin
	if (sel == 1'b1) begin
		alu_out[0] = a+b+c;
	end else begin	
		alu_out[0] = a-b-c;
	end
end

always @(posedge clk) begin
	if (rst == 1'b1) begin
		for(stage=1; stage<=STAGES; stage=stage+1) begin
			alu_out[stage] <= 0;
		end
	end else begin
		for(stage=1; stage<=STAGES; stage=stage+1) begin
			alu_out[stage] <= alu_out[stage-1];
		end
	end	
end

assign r = alu_out[STAGES];

endmodule 
