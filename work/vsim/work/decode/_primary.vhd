library verilog;
use verilog.vl_types.all;
entity decode is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        i_ir            : in     vl_logic_vector(15 downto 0);
        i_apsr          : in     vl_logic_vector(3 downto 0);
        o_addrrn_r      : out    vl_logic_vector(3 downto 0);
        o_addrrd_r      : out    vl_logic_vector(3 downto 0);
        o_addrrt_r      : out    vl_logic_vector(3 downto 0);
        o_imm_r         : out    vl_logic_vector(31 downto 0);
        o_mode_r        : out    vl_logic_vector(1 downto 0);
        o_alusel_r      : out    vl_logic_vector(2 downto 0)
    );
end decode;
