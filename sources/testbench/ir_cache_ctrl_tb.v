`timescale 1 ns / 1 ps

module ir_cache_ctrl_tb ();
logic         clk, rst, stall;
logic[15:0]   i_data;
logic[15:0]   o_data; 


ir_cache_ctrl dut(
  .clk (clk),
  .rst (rst),
  .stall (stall),

  .i_data (i_data),
  .o_data (o_data)
);

initial begin
  clk = 0;
  forever #1 clk = !clk;
end

always_ff @(posedge clk) begin
  i_data <= i_data+1;
end

initial begin
  rst = 0;
  i_data = 0;
  stall = 0;

  #3 rst = 1;
  #2.1 rst = 0;

  #2.6 stall = 1;
  #4 stall = 0;
end

endmodule
