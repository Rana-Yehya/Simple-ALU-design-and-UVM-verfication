`include "uvm_macros.svh"
class ALU_coverage extends uvm_subscriber#(ALU_transaction);
	`uvm_component_utils(ALU_coverage)
	uvm_analysis_export #(ALU_transaction) cover_export;

  	uvm_tlm_analysis_fifo #(ALU_transaction) coverage_fifo;
	ALU_transaction ALU_tx_cg;
  	int total,covered;
		/*
    sequence seq;
      !ALU_tx_cg.a_en && ALU_tx_cg.b_en -> ALU_tx_cg.b_op!=3;
    endsequence

  	a_1 : assert property(seq);
    */

	//Define coverpoints
	covergroup ALU_cg;
      		A_cp: coverpoint ALU_tx_cg.A;
      		B_cp: coverpoint ALU_tx_cg.B;
      		a_en_cp:   coverpoint ALU_tx_cg.a_en;
      		b_en_cp:   coverpoint ALU_tx_cg.b_en;
      		a_op_cp:   coverpoint ALU_tx_cg.a_op {bins bins_Aop[]={[0:6]};}
      		b_op_cp:   coverpoint ALU_tx_cg.b_op;
      //cross a_en_cp, b_en_cp , b_op_cp{illegal_bins  invalid = '{'{0,1,'b11}};}
      		set_b1: cross a_en_cp, b_en_cp , b_op_cp{ignore_bins invalid = set_b1 with (a_en_cp ==0 && b_en_cp==1 && b_op_cp=='b11);}
	endgroup: ALU_cg
	function new( string name, uvm_component parent );
		super.new(name, parent);
      	ALU_tx_cg	= new("ALU_tx");
      	ALU_cg =new;
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
      $display("COVERAGE HAS BEEN BUILT");
      	cover_export	= new("cover_export", this);

   		coverage_fifo	= new("coverage_fifo", this);
	endfunction: build_phase
	function void connect_phase(uvm_phase phase);
      	super.connect_phase(phase);
		cover_export.connect(coverage_fifo.analysis_export);
	endfunction: connect_phase

  	task run_phase(uvm_phase phase);
		forever begin
			coverage_fifo.get(ALU_tx_cg);
			write(ALU_tx_cg);
			//a_1;
		end
	endtask: run_phase

  	virtual function void write(ALU_transaction t);
     // $display("COVERAGE write");
    	//ALU_tx_cg = t;
      //$display("%32x",vif.sig_ciphertext);
      //$display("IN coverage");
      //`uvm_info("ALU_transaction", ALU_tx_cg.sprint(), UVM_LOW);
      //`uvm_info("ALU_transaction", t.sprint(), UVM_LOW);
		this.ALU_cg.sample();
   	endfunction:write
	function void extract_phase(uvm_phase phase);
      $display("IN EXTRACT");
      //`uvm_info("STDOUT: %7.2f coverage achieved.",this.ALU_cg.get_inst_coverage(),UVM_LOW);
      //`uvm_info("%s",this.ALU_cg.get_inst_coverage(),UVM_LOW);
      $display("STDOUT: %3.2f%% coverage achieved.",this.ALU_cg.get_coverage(covered,total));
    endfunction: extract_phase
endclass: ALU_coverage
