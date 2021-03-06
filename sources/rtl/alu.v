 `timescale 1 ns / 1 ps

module alu(
	i_imm,
	i_rn,
	i_sel,
	o_result_r,
	o_apsr_r
);

input wire [31:0] 	i_imm;
input wire [31:0] 	i_rn;
input wire [2:0] 	  i_sel;
output reg [31:0] 	o_result_r;
output reg [3:0] 	o_apsr_r;

reg [32:0] iresult_r; 

// sel_in mapping
// using bit 1 to 3 of first byte 
// 000 - add
// 101 - sub
// 001 - mv (imm)
// 010 - mv (reg)

// apsr
// 31 30 29 28
// N  Z  C  V
// mapped to
// 3 2 1 0
// N Z C V
//
//N - 1 if result of rn - imm < 0; 0 else
//Z - 1 if result of rn - imm = 0; 0 else
// not implemented yet:
//C - 1 if results in a carry condition (unsigned overflow); 0 else
//V - 1 if results in a overflow condition (signed overflow); 0 else

always@ (*) begin
  //reset APSR
  o_apsr_r = 0;

  //calculate
  case (i_sel)
    3'b000:
    //add
		iresult_r = i_imm + i_rn;
    3'b101: begin
    //sub
		iresult_r = i_rn - i_imm;
    if (iresult_r[32] == 1'b1) begin
      o_apsr_r[3] = 1;
    end
    end
    3'b001:
    //mv (imm)
    iresult_r = i_imm;
    3'b010:
    //mv (reg)
    iresult_r = i_rn;
    default:
    // error ??
    iresult_r = 0;
    // if you are sure that there will be no disallowed commands
    // we can use the default path for sub and save one sub block.
  endcase

  o_result_r = iresult_r[31:0];

  if (o_result_r == 0) begin
    //set Z flag
    o_apsr_r[2] = 1;
  end
 
end

endmodule 
