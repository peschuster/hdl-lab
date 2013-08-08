module conditions(
  i_ir,
  i_apsr,
  o_met
);

localparam [3:0]
  EQ = 4'b0000,
  NE = 4'b0001,
  CS = 4'b0010,
  CC = 4'b0011,
  MI = 4'b0100,
  PL = 4'b0101,
  VS = 4'b0110,
  VC = 4'b0111,
  HI = 4'b1000,
  LS = 4'b1001,
  GE = 4'b1010,
  LT = 4'b1011,
  GT = 4'b1100,
  LE = 4'b1101,
  AL = 4'b1110,

  // none standard:
  FALSE = 4'b1111;

localparam [1:0]
  APSR_N = 3,
  APSR_Z = 2,
  APSR_C = 1,
  APSR_V = 0;

input  logic [15:0] i_ir;
input  logic [ 3:0] i_apsr;
output logic        o_met;

logic [3:0] condition;

// decode ir
always_comb begin
  casez (i_ir[15:11])
    5'b11100: condition = AL;
    5'b1101?: condition = i_ir[11:8];
    default: condition = FALSE;
  endcase
end

// evaluate apsr
always_comb begin
  case (condition)
    EQ: o_met = i_apsr[APSR_Z] == 1;
    NE: o_met = i_apsr[APSR_Z] == 0;
    CS: o_met = i_apsr[APSR_C] == 1;
    CC: o_met = i_apsr[APSR_C] == 0;
    MI: o_met = i_apsr[APSR_N] == 1;
    PL: o_met = i_apsr[APSR_N] == 0;
    VS: o_met = i_apsr[APSR_V] == 1;
    VC: o_met = i_apsr[APSR_V] == 0;
    HI: o_met = i_apsr[APSR_C] == 1 && i_apsr[APSR_Z] == 0;
    LS: o_met = i_apsr[APSR_C] == 0 || i_apsr[APSR_Z] == 1;
    GE: o_met = i_apsr[APSR_N] == i_apsr[APSR_V];
    LT: o_met = i_apsr[APSR_N] != i_apsr[APSR_V];
    GT: o_met = i_apsr[APSR_Z] == 0 && i_apsr[APSR_N] == i_apsr[APSR_V];
    LE: o_met = i_apsr[APSR_Z] == 1 || i_apsr[APSR_N] != i_apsr[APSR_V];
    AL: o_met = 1;
    default: o_met = 0;
  endcase
end

endmodule

