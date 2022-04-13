
interface ALU_if;
	logic	sig_clk;
	logic	sig_rst_n;
  	logic 	sig_alu_en;

  	logic[4:0] sig_A;
  	logic[4:0] sig_B;
  	logic[5:0] sig_C;

  	logic sig_a_en;
  	logic sig_b_en;

  	logic [2:0]sig_a_op;
  	logic [1:0]sig_b_op;


endinterface: ALU_if
