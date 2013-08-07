// Integrated Electronic Systems Lab
// TU Darmstadt
// Author:	Group 6
// Email:
//
// decoder module.
// decodes every supported command for the cpu
//
// alu sel commands --> see alu.v
// 
// mode control:
// 0 stall
// 1 normal operation
// 2 branch operation


module decode(
  clk,
  rst,

  // inputs  
  i_ir,
  i_apsr,
  
  // outputs
  o_addrrn_r,
  o_addrrd_r,
  o_addrrt_r,
  o_imm_r,
  o_mode_r,
  o_alusel_r
);

input logic   clk, rst;
input logic [15:0]  i_ir;
input logic [ 3:0]  i_apsr;

output logic [3:0]  o_addrrn_r;
output logic [3:0]  o_addrrd_r;
output logic [3:0]  o_addrrt_r;
output logic [31:0] o_imm_r;
output logic [1:0] o_mode_r;
output logic [2:0] o_alusel_r;

// pipeline stages for shift register
logic [3:0] addrrd_pre1_r, addrrd_pre2_r;

// is set if the APSR should be read
logic condition_check_r;


always_ff @(posedge clk) begin

  if (rst) begin
      o_imm_r <= 0;
      o_addrrn_r <= 0;
      o_addrrt_r <= 0;
      addrrd_pre1_r <= 0;
      o_alusel_r <= 3'b001;
    end
  else
    begin

      casez (i_ir[15:7])
        9'b0001110??: begin // ADD
            o_imm_r <= i_ir[8:6];
            o_addrrn_r <= i_ir[5:3];
            addrrd_pre1_r <= i_ir[2:0];
            o_alusel_r <= 3'b000;
          end
        9'b101100001: begin // SUB SP
            o_imm_r <= { { 25 { 1'b0 } }, i_ir[6:0]};
            o_addrrn_r <= 13; // warum 13????
            addrrd_pre1_r <= 13;
            o_alusel_r <= 3'b101;
          end
        9'b00100????: begin // MOV IMM
            o_imm_r <= { { 24 { 1'b0 } }, i_ir[7:0]};
            addrrd_pre1_r <= i_ir[10:8];
            o_alusel_r <= 3'b001;
          end
        9'b01000110?: begin // MOV REG
            o_imm_r <= 32'h00000000;
            o_addrrn_r <= i_ir[6:3];
            addrrd_pre1_r <= i_ir[2:0];
            o_alusel_r <= 3'b010;
          end
        9'b01101????: begin // LDR
            o_imm_r <= { { 27 { 1'b0 } }, i_ir[10:6]};
            o_addrrn_r <= i_ir[5:3];
            addrrd_pre1_r <= i_ir[2:0];
            o_alusel_r <= 3'b000;
          end
        9'b01100????: begin // STR
            o_imm_r <= { { 27 { 1'b0 } }, i_ir[10:6]};
            o_addrrn_r <= i_ir[5:3];
            o_addrrt_r <= i_ir[2:0];
            o_alusel_r <= 3'b000;
          end
        9'b1101?????: begin // B
            o_imm_r <= 32'h00000000;
//TODO ????
          end
        9'b00101????: begin // CMP
            o_imm_r <= { { 24 { 1'b0 } }, i_ir[7:0]};
            o_addrrn_r <= i_ir[10:8];
            o_alusel_r <= 3'b101;
          end
        default:     begin // error
            o_imm_r <= 32'h00000000;
            o_addrrn_r <= 0;
            o_alusel_r <= 3'b001;
          end
      endcase;
    end
end

// Condition pipeline
always_ff @(posedge clk) begin
  if (rst == 1) begin
      condition_check_r <= 0;
    end
  else if (i_ir[15:12] == 4'b1101) begin
      condition_check_r <= 1;
    end 
  else begin
    condition_check_r <= 0;
  end
end

// Shift registers
// 2 pipelinestages for output register
// we need the adress for the running command
// in 2 steps, so it will be saved in a 
// two stage shift register
always_ff @(posedge clk) begin
  if (rst) begin
    o_addrrd_r <= 0;
    addrrd_pre2_r <= 0;
    end
  else begin 
    addrrd_pre2_r <= addrrd_pre1_r;
    o_addrrd_r <= addrrd_pre2_r;
  end
end

// Mode ctrl
always_ff @(posedge clk) begin
  if (rst) begin
      o_mode_r <= 0;
    end
  else if (condition_check_r) begin
      if (i_apsr[2] == 1 || i_apsr[3] != i_apsr[0]) 
        o_mode_r <= 2;
      else
        o_mode_r <= 1;
    end
  else
    o_mode_r <= 1;
end

endmodule
