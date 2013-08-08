`timescale 1 ns / 1 ps

module addr_ctrl_tb ();

parameter	MEM_DEPTH	= 2**12;

//addresses this many Bytes (1Byte = 8bit)
localparam	ADDR_WIDTH	= $clog2(MEM_DEPTH*2);

localparam [1:0]
  MODE_NORMAL = 0,
  MODE_ALU_IR = 1,
  MODE_MEM = 2,
  MODE_ALU_DATA = 3;

logic        rst, clk;
logic [ 1:0] mode; // 00: normal (+2), 01: alu-addr (ir memory), 10: mem-addr (pop), 11: alu-addr (data memory)
logic [31:0] pc, alu_addr, mem_addr;

logic [31:0] pc_next;
logic [ADDR_WIDTH-1:0] addr;

addr_ctrl #(.MEM_DEPTH(MEM_DEPTH)) dut (
  .rst(rst),
  .i_mode(mode),
  .i_pc(pc),
  .i_alu_addr(alu_addr),
  .i_mem_addr(mem_addr),
  .o_pc(pc_next),
  .o_addr(addr)
);

initial begin

  rst = 1;
  mode = MODE_NORMAL;

  #3 rst = 0;

  alu_addr = 20;
  
  #4.2 mode = MODE_ALU_IR;
  #2 mode = MODE_NORMAL;

  #6 mode = MODE_ALU_DATA;
  #4 mode = MODE_NORMAL;

  mem_addr = 5;

  #6 mode = MODE_MEM;
  #2 mode = MODE_NORMAL;
  
  #20 $finish;
end

//CLOCK GENERATOR
initial begin
	clk = 1'b0;
	forever #1  clk = !clk;
end

always_ff @(posedge clk) begin
  if (rst) begin
    pc <= 0;    
  end
  else begin
    pc <= pc_next;
  end
end
 
endmodule
