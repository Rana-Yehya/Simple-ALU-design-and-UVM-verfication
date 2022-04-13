`include "uvm_macros.svh"

class ALU_driver extends uvm_driver#(ALU_transaction);
	`uvm_component_utils(ALU_driver)

	virtual ALU_if vif;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		void'(uvm_resource_db#(virtual ALU_if)::read_by_name
			(.scope("ifs"), .name("ALU_if"), .val(vif)));
	endfunction: build_phase

	task run_phase(uvm_phase phase);
		drive();
	endtask: run_phase

	virtual task drive();
		ALU_transaction ALU_tx;
		integer states   = 0 , rounds =0,counter=0 ;
		bit [1:0] FSM = 2'b00;
    	vif.sig_rst_n =1;
        vif.sig_alu_en = 1;
        vif.sig_A = 0;
        vif.sig_B = 0;

		vif.sig_a_en=0;
		vif.sig_b_en=0;

    vif.sig_a_op=0;
    vif.sig_b_op=0;

		forever begin


			@(posedge vif.sig_clk)
			begin
                  if(counter==0)  // instead of counter = 0 it will be reset = 1 cause that's where our design begins
                  begin

                      seq_item_port.get_next_item(ALU_tx); // Taking the next randmozied set of values from the sequencer
                      //$display("new sq %x %x ",AES_tx.key,AES_tx.message);
                      //`uvm_info("alu_driver", ALU_tx.sprint(), UVM_LOW);
                  end
				  if (counter ==1) begin
                    //$display("HERE");
                    	vif.sig_rst_n    = 1'b1;
					     counter +=1;
                    vif.sig_alu_en = 1;
					end
					else if(counter == 0) begin
					 vif.sig_rst_n   = 1'b0;

//           $display (" what is inside your driver" );
//           $display ("_________________");
// 		       $display ("%16x",AES_tx.nonce);
// 		       $display ("%32x",AES_tx.key);
// 		       $display ("%32x",AES_tx.message);
// 		       $display ("_________________");


                  vif.sig_A = ALU_tx.A;
                  vif.sig_B = ALU_tx.B;
                  vif.sig_a_en = ALU_tx.a_en;
                  vif.sig_b_en = ALU_tx.b_en;
                  vif.sig_a_op = ALU_tx.a_op;
                  vif.sig_b_op = ALU_tx.b_op;
                      //$display("IN DRIVER");
                  //`uvm_info("ALU_transaction", ALU_tx.sprint(), UVM_LOW);
				  counter +=1;
				  end
              else if (counter ==4) begin//7
					seq_item_port.item_done();
              		counter =0;
              end
                else counter +=1;
			end
        end
	endtask: drive


endclass: ALU_driver
