library verilog;
use verilog.vl_types.all;
entity cpu is
    generic(
        MEM_DEPTH       : integer := 4096
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        i_mem_do        : in     vl_logic_vector(0 to 1);
        o_mem_di        : out    vl_logic_vector(0 to 1);
        o_mem_addr      : out    vl_logic_vector;
        o_mem_en        : out    vl_logic;
        o_mem_rd_en     : out    vl_logic;
        o_mem_wr_en     : out    vl_logic_vector(0 to 1)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of MEM_DEPTH : constant is 1;
end cpu;
