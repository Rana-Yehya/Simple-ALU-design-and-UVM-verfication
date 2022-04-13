
`include "uvm_macros.svh"
`include "ALU_coverage.sv"
class ALU_env extends uvm_env;
	`uvm_component_utils(ALU_env)

	ALU_agent alu_agent;
	ALU_scoreboard alu_sb;
	ALU_coverage alu_cover;


  	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
      	alu_agent	= ALU_agent::type_id::create(.name("alu_agent"), .parent(this));
      	alu_sb		= ALU_scoreboard::type_id::create(.name("alu_sb"), .parent(this));
      	alu_cover		= ALU_coverage::type_id::create(.name("alu_cover"), .parent(this));
	endfunction: build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		alu_agent.agent_ap_before.connect(alu_sb.sb_export_before);
      	alu_agent.agent_ap_after.connect(alu_sb.sb_export_after);
       	alu_agent.agent_ap_cover.connect(alu_cover.cover_export);
	endfunction: connect_phase
endclass: ALU_env
