
`include "uvm_macros.svh"

class ALU_test extends uvm_test;
		`uvm_component_utils(ALU_test)

		ALU_env alu_env;

		function new(string name, uvm_component parent);
			super.new(name, parent);
		endfunction: new

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
          	alu_env = ALU_env::type_id::create(.name("alu_env"), .parent(this));
		endfunction: build_phase

		task run_phase(uvm_phase phase);
			ALU_sequence alu_seq;
			phase.raise_objection(.obj(this));
          	alu_seq = ALU_sequence::type_id::create(.name("alu_seq"), .contxt(get_full_name()));
          assert(alu_seq.randomize());
          	alu_seq.start(alu_env.alu_agent.alu_seqr);
			phase.drop_objection(.obj(this));
		endtask: run_phase
endclass: ALU_test
