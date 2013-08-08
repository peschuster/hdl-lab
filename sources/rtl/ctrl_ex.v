module ctrl_ex (
  clk,
  rst,
  
  i_alu_sel_r,
  i_ir_cache,
  
  o_alu_sel,
  o_ir_mem,
  o_stall_r
);

input   logic         clk, rst;
input   logic[2:0]    i_alu_sel_r;
input   logic[15:0]   i_ir_cache;

output  logic[2:0]    o_alu_sel;
output  logic[15:0]   o_ir_mem;
output  logic         o_stall_r;
        logic[1:0]    cnt;
        
assign o_alu_sel = i_alu_sel_r;

//Stall-control-logic
always_ff @(posedge clk) begin
  if(rst)
    o_stall_r <= 0;
  else begin
    casez (i_ir_cache[15:11])
      9'b01101: begin // LDR
        //2 Stalls
      end
      9'b01100: begin // STR
        //2 Stalls
      end
      
      default: begin
        //kein Stall
      end
    endcase
  end
end


//Output ir_cache (instruction in mem-phase)
always_ff @(posedge clk) begin
  if(rst)
    o_ir_mem <= 0;
  else
    o_ir_mem <= i_ir_cache;
end

endmodule
