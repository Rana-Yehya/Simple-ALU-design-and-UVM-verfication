`include "uvm_macros.svh"

`uvm_analysis_imp_decl(_before)
`uvm_analysis_imp_decl(_after)

class ALU_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(ALU_scoreboard)

	uvm_analysis_export #(ALU_transaction) sb_export_before;
  	uvm_analysis_export #(ALU_transaction) sb_export_after;

	uvm_tlm_analysis_fifo #(ALU_transaction) before_fifo;
	uvm_tlm_analysis_fifo #(ALU_transaction) after_fifo;

	ALU_transaction transaction_before;
	ALU_transaction transaction_after;

	function new(string name, uvm_component parent);
		super.new(name, parent);

		transaction_before	= new("transaction_before");
		transaction_after	= new("transaction_after");
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		sb_export_before	= new("sb_export_before", this);
		sb_export_after		= new("sb_export_after", this);

   		before_fifo		= new("before_fifo", this);
		after_fifo		= new("after_fifo", this);
	endfunction: build_phase

	function void connect_phase(uvm_phase phase);
		sb_export_before.connect(before_fifo.analysis_export);
		sb_export_after.connect(after_fifo.analysis_export);
	endfunction: connect_phase

	task run();
		forever begin
			before_fifo.get(transaction_before);
			after_fifo.get(transaction_after);

			compare();
		end
	endtask: run
  int i=0;
	virtual function void compare();
	  $display ("Compare has begun ");
	  //$display ("%32x",transaction_before.ciphertext);
	  //$display ("%32x",transaction_after.ciphertext);
      if(transaction_before.C == transaction_after.C &&
       	 transaction_before.A == transaction_after.A &&
         transaction_before.B == transaction_after.B &&
         transaction_before.b_op == transaction_after.b_op &&
         transaction_before.a_op == transaction_after.a_op &&
         transaction_before.a_en == transaction_after.a_en &&
         transaction_before.b_en == transaction_after.b_en) begin
			`uvm_info("compare", {"Test: OK!"}, UVM_LOW);
		end else begin
			`uvm_error("compare", {"Test: Fail!"});
		end

	endfunction: compare
endclass: ALU_scoreboard
