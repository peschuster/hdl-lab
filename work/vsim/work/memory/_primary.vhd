library verilog;
use verilog.vl_types.all;
entity memory is
    generic(
        MEM_DEPTH       : integer := 4096
    );
    port(
        clk             : in     vl_logic;
        en              : in     vl_logic;
        rd_en           : in     vl_logic;
        wr_en           : in     vl_logic_vector(0 to 1);
        addr            : in     vl_logic_vector;
        din             : in     vl_logic_vector(0 to 1);
        dout            : out    vl_logic_vector(0 to 1)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of MEM_DEPTH : constant is 1;
end memory;
