`include "uvm_macros.svh"

class ALU_transaction extends uvm_sequence_item;
	rand bit[4:0] A,B;
	rand bit[1:0] b_op;
  	rand bit[2:0] a_op;
  	rand bit a_en,b_en;

  	bit [5:0] C;

  constraint OP_A{a_op!= 'b111;}
  constraint OP_B{(a_en==0 && b_en==1) -> b_op !='b11;}

	function new(string name = "");
		super.new(name);
	endfunction: new

  `uvm_object_utils_begin(ALU_transaction)
		`uvm_field_int(A, UVM_ALL_ON)
  		`uvm_field_int(B, UVM_ALL_ON)
  		`uvm_field_int(a_op, UVM_ALL_ON)
  		`uvm_field_int(b_op, UVM_ALL_ON)
  		`uvm_field_int(b_en, UVM_ALL_ON)
  		`uvm_field_int(a_en, UVM_ALL_ON)
  		`uvm_field_int(C, UVM_ALL_ON)
	`uvm_object_utils_end
endclass: ALU_transaction

class ALU_sequence extends uvm_sequence#(ALU_transaction);
	`uvm_object_utils(ALU_sequence)

  int i=0;

	function new(string name = "");
		super.new(name);
	endfunction: new

	task body();
		ALU_transaction ALU_tx;

      repeat(60)begin
		ALU_tx = ALU_transaction::type_id::create(.name("ALU_tx"), .contxt(get_full_name()));

    	i++;
    	$display ("Value of repetition is  %d",i);
		start_item(ALU_tx);
		assert(ALU_tx.randomize());
        //$display("IN SEQUENCER");
        //`uvm_info("ALU_transaction", ALU_tx.sprint(), UVM_LOW);
		finish_item(ALU_tx);
		//$display("End");
		end
	endtask: body
endclass: ALU_sequence

typedef uvm_sequencer#(ALU_transaction) ALU_sequencer;
