library verilog;
use verilog.vl_types.all;
entity ir_cache_ctrl is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        stall           : in     vl_logic;
        i_data          : in     vl_logic_vector(15 downto 0);
        o_data          : out    vl_logic_vector(15 downto 0)
    );
end ir_cache_ctrl;
