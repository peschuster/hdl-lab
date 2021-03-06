

module testbench();

// PARAMETERS

// INTERNAL SIGNALS
reg [31:0] imm;
reg [31:0] rn;
reg [2:0] sel;
wire [31:0] result;
wire [3:0] apsr;

// MODULE INSTANTIATION
alu alu_i(
	.i_imm(imm),
	.i_rn(rn),
	.i_sel(sel),
	.o_result_r(result),
	.o_apsr_r(apsr)
);

//memory ...
//clk_gen ...
//rst_gen ...

initial begin
  $monitor ($time,,,"sel= %b imm= %d rn= %d result= %d apsr= %b",
        sel, imm, rn, result, apsr);

  // add 1+1 = 2 APSR 00
  sel = 3'b000;
  imm = 1;
  rn = 1;
  
  // sub 5-1 = 4 APSR 00
  #1 sel = 3'b101;
  imm = 1;
  rn = 5;

  // mv (imm) = 3 APSR 00
  #1 sel = 3'b001;
  imm = 3;
  rn = 1;

  // mv (reg) = 1 APSR 00
  #1 sel = 3'b010;
  imm = 3;
  rn = 1;

  // cmp 3-1 = 2 APSR 00
  // uses substraction mode
  #1 sel = 3'b101;
  imm = 1;
  rn = 3;

  // cmp 1-1 = 0  APSR 01
  #1 rn = 1;

  // cmp 1-2 = -1  APSR 10
  #1 imm = 2;

  

  #500 $finish;

end
endmodule
