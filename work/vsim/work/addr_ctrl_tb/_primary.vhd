library verilog;
use verilog.vl_types.all;
entity addr_ctrl_tb is
    generic(
        MEM_DEPTH       : integer := 4096
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of MEM_DEPTH : constant is 1;
end addr_ctrl_tb;
