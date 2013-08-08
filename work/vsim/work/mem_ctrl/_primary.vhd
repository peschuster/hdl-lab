library verilog;
use verilog.vl_types.all;
entity mem_ctrl is
    generic(
        MEM_DEPTH       : integer := 4096
    );
    port(
        rst             : in     vl_logic;
        clk             : in     vl_logic;
        i_cpu_addr      : in     vl_logic_vector;
        i_cpu_data      : in     vl_logic_vector(31 downto 0);
        i_mem_data      : in     vl_logic_vector(15 downto 0);
        i_wr_mode       : in     vl_logic_vector(1 downto 0);
        i_rd_mode       : in     vl_logic_vector(1 downto 0);
        o_cpu_data      : out    vl_logic_vector(31 downto 0);
        o_mem_addr      : out    vl_logic_vector;
        o_mem_data      : out    vl_logic_vector(15 downto 0);
        o_en            : out    vl_logic;
        o_rd_en         : out    vl_logic;
        o_wr_en         : out    vl_logic_vector(1 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of MEM_DEPTH : constant is 1;
end mem_ctrl;
