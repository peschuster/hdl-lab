library verilog;
use verilog.vl_types.all;
entity registers is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        i_addr_rn       : in     vl_logic_vector(3 downto 0);
        i_addr_rd       : in     vl_logic_vector(3 downto 0);
        i_addr_rt       : in     vl_logic_vector(3 downto 0);
        i_rd            : in     vl_logic_vector(31 downto 0);
        i_rd_wr_en      : in     vl_logic;
        o_rn_r          : out    vl_logic_vector(31 downto 0);
        o_rt_r          : out    vl_logic_vector(31 downto 0);
        i_pc            : in     vl_logic_vector(31 downto 0);
        o_pc_r          : out    vl_logic_vector(31 downto 0)
    );
end registers;
