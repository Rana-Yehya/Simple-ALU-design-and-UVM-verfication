`include "uvm_macros.svh"
import "DPI-C" function byte  test (input  byte  A,B,rst_n,alu_en,a_en,b_en,b_op,a_op);
class ALU_monitor_before extends uvm_monitor;
	`uvm_component_utils(ALU_monitor_before)

	uvm_analysis_port#(ALU_transaction) mon_ap_before;
  	uvm_analysis_port#(ALU_transaction) mon_ap_cover;
  	virtual ALU_if vif;
   	ALU_transaction ALU_tx;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		ALU_tx = new("ALU_tx");
		void'(uvm_resource_db#(virtual ALU_if)::read_by_name
			(.scope("ifs"), .name("ALU_if"), .val(vif)));

		mon_ap_before = new(.name("mon_ap_before"), .parent(this));
      	mon_ap_cover = new(.name("mon_ap_cover"), .parent(this));
	endfunction: build_phase

	task run_phase(uvm_phase phase);
    	//ALU_tx = ALU_transaction::type_id::create(.name("ALU_tx"), .contxt(get_full_name()));
		integer counter = 0;

		forever begin
			@(posedge vif.sig_clk)
			begin

              if(counter==4)//7
				begin
                    ALU_tx.A= vif.sig_A  ;
                  	ALU_tx.B = vif.sig_B ;
                    ALU_tx.a_en = vif.sig_a_en ;
                    ALU_tx.b_en = vif.sig_b_en ;
                    ALU_tx.a_op = vif.sig_a_op ;
                    ALU_tx.b_op = vif.sig_b_op ;
					ALU_tx.C = vif.sig_C;
					//$display("The output of DUT :");
					//$display("%32x",vif.sig_ciphertext);
                  	//$display("IN MONITOR BEFORE");
                  	//`uvm_info("ALU_transaction", ALU_tx.sprint(), UVM_LOW);
					mon_ap_before.write(ALU_tx);
                  	mon_ap_cover.write(ALU_tx);
                   counter = 0;
				end
                else begin
                	counter=counter+1;
                  //$display("at count %d. C = %d",counter,vif.sig_C);
                end
            end
		end
	endtask: run_phase

endclass: ALU_monitor_before

class ALU_monitor_after extends uvm_monitor;
	`uvm_component_utils(ALU_monitor_after)

	uvm_analysis_port#(ALU_transaction) mon_ap_after;
	virtual ALU_if vif;
	//For C function
	ALU_transaction ALU_do;

	function new(string name, uvm_component parent);
		super.new(name, parent);
      	//inst = new();
		//ALU_cg = new;
		ALU_do= new;
      	//ALU_tx_cg=new;
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

	void'(uvm_resource_db#(virtual ALU_if)::read_by_name
          (.scope("ifs"), .name("ALU_if"), .val(vif)));
		mon_ap_after= new(.name("mon_ap_after"), .parent(this));
	endfunction: build_phase

	task run_phase(uvm_phase phase);
		integer counter=0 ;
			forever begin
			@(posedge vif.sig_clk)
			begin
              if(counter==4) //7
				begin
                   counter = 0;

                  	ALU_do.A= vif.sig_A  ;
                  	ALU_do.B = vif.sig_B ;
                    ALU_do.a_en = vif.sig_a_en ;
                    ALU_do.b_en = vif.sig_b_en ;
                    ALU_do.a_op = vif.sig_a_op ;
                    ALU_do.b_op = vif.sig_b_op ;

                  	// FUNCTION
                  	ALU_do.C = test(vif.sig_A,vif.sig_B ,vif.sig_rst_n,vif.sig_alu_en,vif.sig_a_en,vif.sig_b_en,vif.sig_b_op,vif.sig_a_op);
					mon_ap_after.write(ALU_do);
				end
                else counter=counter+1;
			end
            end
              endtask: run_phase

endclass: ALU_monitor_after
