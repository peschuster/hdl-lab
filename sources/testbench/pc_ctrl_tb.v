`timescale 1 ns / 1 ps

module pc_ctrl_tb ();

logic [ 1:0] i_mode; // 00: stall, 01: normal (+2), 10: branch
logic [31:0] i_pc;
logic [31:0] i_branch;

logic [31:0] o_pc;

pc_ctrl dut (
  .i_mode(i_mode),
  .i_pc(i_pc),
  .i_branch(i_branch),
  .o_pc(o_pc)
);

initial begin

  i_mode = 0;
  i_pc = 0;
  i_branch = 20;

  #1;
  
  if (i_pc === o_pc) begin
    $display ("Mode 0 works ok.");
  end else begin
    #1  $error("assert failed at mode 0 test");
  end

  #1 i_pc = o_pc;
  i_mode = 1;

  #1;
  
  if (o_pc === 2) begin
    $display ("Mode 1 works ok.");
  end else begin
    #1  $error("assert failed at mode 0 test");
  end

  #1 i_pc = o_pc;

  #1;
  
  if (o_pc === 4) begin
    $display ("Mode 1 works ok.");
  end else begin
    #1  $error("assert failed at mode 0 test");
  end

  #1 i_pc = o_pc;
  i_mode = 2;

  #1;
  
  if (o_pc === 24) begin
    $display ("Mode 2 works ok.");
  end else begin
    #1  $error("assert failed at mode 0 test");
  end
end
 
endmodule
