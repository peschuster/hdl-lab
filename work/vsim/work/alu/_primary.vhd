library verilog;
use verilog.vl_types.all;
entity alu is
    port(
        i_imm           : in     vl_logic_vector(31 downto 0);
        i_rn            : in     vl_logic_vector(31 downto 0);
        i_sel           : in     vl_logic_vector(2 downto 0);
        o_result_r      : out    vl_logic_vector(31 downto 0);
        o_apsr_r        : out    vl_logic_vector(3 downto 0)
    );
end alu;
