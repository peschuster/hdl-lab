library verilog;
use verilog.vl_types.all;
entity addr_ctrl is
    generic(
        MEM_DEPTH       : integer := 4096
    );
    port(
        rst             : in     vl_logic;
        i_mode          : in     vl_logic_vector(1 downto 0);
        i_pc            : in     vl_logic_vector(31 downto 0);
        i_alu_addr      : in     vl_logic_vector(31 downto 0);
        i_mem_addr      : in     vl_logic_vector(31 downto 0);
        o_addr          : out    vl_logic_vector;
        o_pc            : out    vl_logic_vector(31 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of MEM_DEPTH : constant is 1;
end addr_ctrl;
