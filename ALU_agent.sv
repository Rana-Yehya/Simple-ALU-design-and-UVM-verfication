`include "uvm_macros.svh"

class ALU_agent extends uvm_agent;
	`uvm_component_utils(ALU_agent)
  	uvm_analysis_port#(ALU_transaction) agent_ap_cover;
	uvm_analysis_port#(ALU_transaction) agent_ap_before;
	uvm_analysis_port#(ALU_transaction) agent_ap_after;

	ALU_sequencer		    alu_seqr;
	ALU_driver		       alu_drvr;
	ALU_monitor_before	alu_mon_before;
	ALU_monitor_after	 alu_mon_after;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		agent_ap_before	= new(.name("agent_ap_before"), .parent(this));
		agent_ap_after	= new(.name("agent_ap_after"), .parent(this));
		agent_ap_cover	= new(.name("agent_ap_cover"), .parent(this));
		alu_seqr		= ALU_sequencer::type_id::create(.name("alu_seqr"), .parent(this));
		alu_drvr		= ALU_driver::type_id::create(.name("alu_drvr"), .parent(this));
      alu_mon_before	=  ALU_monitor_before::type_id::create(.name("alu_mon_before"), .parent(this));
		alu_mon_after	 =  ALU_monitor_after::type_id::create(.name("alu_mon_after"), .parent(this));
	endfunction: build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
     	alu_drvr.seq_item_port.connect(alu_seqr.seq_item_export);
		alu_mon_before.mon_ap_before.connect(agent_ap_before);
		alu_mon_after.mon_ap_after.connect(agent_ap_after);

      	alu_mon_before.mon_ap_cover.connect(agent_ap_cover);
	endfunction: connect_phase
endclass: ALU_agent
