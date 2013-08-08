library verilog;
use verilog.vl_types.all;
entity testbench is
    generic(
        MEM_DEPTH       : integer := 4096;
        ADDR_WIDTH      : vl_notype;
        filename        : string  := "../../sources/software/count32.bin"
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of MEM_DEPTH : constant is 1;
    attribute mti_svvh_generic_type of ADDR_WIDTH : constant is 3;
    attribute mti_svvh_generic_type of filename : constant is 2;
end testbench;
