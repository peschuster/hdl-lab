module ctrl_wb (
//  clk,
//  rst,
  
//  i_stall,
  i_ir_wb,
  
  o_rd_sel
);

//input   logic         clk, rst;
input   logic[15:0]   i_ir_wb;
//input   logic         i_stall;

output  logic         o_rd_sel;

always_comb begin
  casez (i_ir_wb[15:11])
    5'b01101: begin // LDR
      o_rd_sel <= 1;
    end
    5'b01001: begin // LDR (Literal to PC)
      o_rd_sel <= 1;
    end
    default:     begin // every other command
      o_rd_sel <= 0;  
    end
  endcase
end

endmodule
