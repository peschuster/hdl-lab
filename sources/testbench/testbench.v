// Integrated Electronic Systems Lab
// TU Darmstadt
// Author:	Dipl.-Ing. Boris Traskov
// Email: 	boris.traskov@ies.tu-darmstadt.de

`timescale 1 ns / 1 ps

module testbench();

// PARAMETERS
parameter MEM_DEPTH   		= 2**12;	//8192 Bytes
parameter ADDR_WIDTH   		= $clog2(MEM_DEPTH*2);
parameter string filename	= "../../sources/software/count32.bin";

// INTERNAL SIGNALS
integer file, status; // needed for file-io
logic			clk;
logic			rst;
logic			en;
logic			rd_en;
logic [ 1:0]	wr_en;
logic [15:0]	data_cpu2mem;
logic [15:0]	data_mem2cpu;
logic [ADDR_WIDTH-1:0] addr;


// CPU INSTANTIATION
cpu  #(
	.MEM_DEPTH (MEM_DEPTH)) 
cpu_inst (
  .clk (clk),
  .rst (rst),

  .i_mem_do (data_mem2cpu),
  
  .o_mem_di (data_cpu2mem),
  .o_mem_addr (addr),
  .o_mem_en (en),
  .o_mem_rd_en (rd_en),
  .o_mem_wr_en (wr_en)
);

// MODULE INSTANTIATION
memory #(
	.MEM_DEPTH (MEM_DEPTH)) 
memory_i (
   	.clk 	(clk),
    .addr	(addr),
    .en  	(en),
    .rd_en  (rd_en),
    .wr_en  (wr_en),
    .din (data_cpu2mem),
    .dout(data_mem2cpu)
);
  
//CLOCK GENERATOR
initial begin
	clk = 1'b0;
	forever #1  clk = !clk;
end

//RESET GENERATOR  
initial begin
	rst			= 1'b0;
	file		= $fopen(filename, "r");
	#3 rst		= 1'b1;     // 3   ns
	status		= $fread(memory_i.ram, file);
	#2.1 rst	= 1'b0;  //2.1 ns
	// $finish;
end

endmodule
