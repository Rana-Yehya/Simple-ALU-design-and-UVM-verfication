// Code your testbench here
// or browse Examples
`include "ALU_pkg.sv"
//`include "design.sv"
`include "ALU_if.sv"
module testbench();

	import uvm_pkg::*;
    import ALU_pkg::*;


	//Interface declaration
  	ALU_if vif();
	//Connects the Interface to the DUT

  	design dut(.clk(vif.sig_clk),
            .rst_n(vif.sig_rst_n),
            .alu_en(vif.sig_alu_en),
            .a_en(vif.sig_a_en),
			.b_en(vif.sig_b_en),
            .A(vif.sig_A),
           	.B(vif.sig_B),
           	.C(vif.sig_C),
           	.a_op(vif.sig_a_op),
           	.b_op(vif.sig_b_op));
	initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
        #10000
        $finish;
	end
	initial begin
      	//Registers the Interface in the configuration block so that other blocks can use it
      uvm_resource_db#(virtual ALU_if)::set(.scope("ifs"), .name("ALU_if"), .val(vif));

		//Executes the test
      run_test("ALU_test");
	end

	//Variable initialization
	initial begin
		vif.sig_clk <= 1'b1;
	end

	//Clock generation
	always
		#5 vif.sig_clk = ~vif.sig_clk;
endmodule
