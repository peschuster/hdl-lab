module mem_ctrl (
  rst,
  clk,

  i_cpu_addr,
  i_cpu_data,
  i_mem_data,
  i_wr_mode,
  i_rd_mode,
  
  o_cpu_data,
  o_mem_addr,
  o_mem_data,
  o_en,
  o_rd_en,
  o_wr_en
);


//stores this many halfwords (1halfword=16bit=2Byte)
parameter	MEM_DEPTH	= 2**12;

//addresses this many Bytes (1Byte = 8bit)
localparam	ADDR_WIDTH	= $clog2(MEM_DEPTH*2);


localparam [1:0]
  MODE_NONE = 0,
  MODE_16   = 1,
  MODE_32   = 2,
  MODE_8    = 3;



input   logic rst,clk;

input   logic [ADDR_WIDTH-1:0]  i_cpu_addr;
input   logic [31:0]            i_cpu_data;
input   logic [15:0]            i_mem_data;  

input   logic [1:0]             i_wr_mode;
input   logic [1:0]             i_rd_mode;

output  logic [ADDR_WIDTH-1:0]  o_mem_addr;
output  logic [15:0]            o_mem_data;
output  logic [31:0]            o_cpu_data;

output  logic                   o_en, o_rd_en;
output  logic[1:0]              o_wr_en;

logic                   read_32, write_32, addr_32_en;
logic [15:0]            data_wr_32, data_rd_32;
logic [ADDR_WIDTH-1:0]  addr_32, addr_buf;
logic [15:0]            mem_di;
logic [1:0]             rd_mode_buf;
logic [15:0]            mem_do;

//Reset
assign o_en = ~rst;
assign o_rd_en = ~rst;


//Byte swap (Big, little endian)
assign mem_do = {i_mem_data[7:0],i_mem_data[15:8]};            
assign o_mem_data = {mem_di[7:0],mem_di[15:8]};

//Data to memory for load/store-instruction
assign mem_di = (write_32 == 1) ? data_wr_32 : i_cpu_data[15:0];

//
assign o_mem_addr = addr_32_en == 1 ? addr_32 : i_cpu_addr;


//Buffering rd_mode / cpu_addr
always_ff @(posedge clk) begin
  rd_mode_buf <= i_rd_mode;
  addr_buf    <= i_cpu_addr;
end

//Store instruction: Setting write_32 flag, buffering cpu_data
always_ff @(posedge clk) begin
  if(write_32 == 1)
    write_32 = 0;
  else if(i_wr_mode == MODE_32) begin  
    write_32 = 1;
    data_wr_32 = i_cpu_data[31:16];
  end
  else 
    write_32 = 0;
end

//32 bit read/write instruction: Control (increment) the address
always_ff @(posedge clk) begin
  if(addr_32_en == 1)
    addr_32_en = 0;
  else if(i_wr_mode == MODE_32 || i_rd_mode == MODE_32) begin  
    addr_32_en = 1;
    addr_32 = i_cpu_addr + 2;
  end
  else 
    addr_32_en = 0;
end

//Buffering bits[15:0] (the first halfword) for the load register instruction.
always_ff @(posedge clk) begin
  if(i_rd_mode == MODE_32)
    data_rd_32 = mem_do;
end

//Setting cpu_data after one cycle (after rd_mode_buf was set). 
always_comb begin
  if (rd_mode_buf == MODE_32) begin
    o_cpu_data = { mem_do, data_rd_32 };
  end
  else if (rd_mode_buf == MODE_8) begin
    o_cpu_data = addr_buf[0] == 1 ? mem_do[7:0] : mem_do[15:8];
  end
  else begin
    o_cpu_data = mem_do;
  end
end

//Write Mode: Which byte shall be overwritten?
always_comb begin
  case(i_wr_mode)
    MODE_NONE: begin 
      o_wr_en = 2'b00;
    end
    MODE_16: begin
      o_wr_en = 2'b11;
    end
    MODE_32: begin
      o_wr_en = 2'b11;
    end
    MODE_8: begin 
      o_wr_en = (i_cpu_addr[0] == 1) ? 2'b01 : 2'b10;
    end
  endcase
end



endmodule
