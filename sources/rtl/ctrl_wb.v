module ctrl_wb (
  clk,
  rst,
  
  i_ir_wb,
  o_addr_rd_r,
  o_registers_rd_en
);

input   logic         clk, rst;
input   logic[15:0]   i_ir_wb;

output  logic         o_registers_rd_en;
output  logic[3:0]    o_addr_rd_r;



always_ff @(posedge clk) begin

  if (rst) begin
      o_addr_rd_r <= 0;
      o_registers_rd_en <= 0;
    end
  else
    begin

      casez (i_ir_wb[15:7])
        9'b0001110??: begin // ADD
            o_addr_rd_r <= i_ir_wb[2:0];
            o_registers_rd_en <= 1;
          end
        9'b101100001: begin // SUB SP
            o_addr_rd_r <= 13;
            o_registers_rd_en <= 1;
          end
        9'b00100????: begin // MOV IMM
            o_addr_rd_r <= i_ir_wb[10:8];
            o_registers_rd_en <= 1;
          end
        9'b01000110?: begin // MOV REG
            o_addr_rd_r <= i_ir_wb[2:0];
            o_registers_rd_en <= 1;
          end
        9'b01101????: begin // LDR
            o_addr_rd_r <= i_ir_wb[2:0];
            o_registers_rd_en <= 1;
          end
        default:     begin // error
            o_addr_rd_r <= 0;
            o_registers_rd_en <= 0;
          end
      endcase
    end
end


endmodule
