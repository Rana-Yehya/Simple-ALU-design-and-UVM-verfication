// Code your design here
module design(clk,rst_n,alu_en,a_en,b_en,A,B,C,a_op,b_op);


///////////////////////////////////////////////////////
/*               Inputs and outputs                  */
///////////////////////////////////////////////////////
	input wire clk,rst_n,alu_en,a_en,b_en;
  	input wire [4:0] A;
  	input wire [4:0] B;
   	input wire [1:0] b_op;
   	input wire [2:0] a_op;
   	output reg [5:0] C;

///////////////////////////////////////////////////////
/*               Registers and states                */
///////////////////////////////////////////////////////

  reg[2:0] state;
  reg[2:0] state_next;
  localparam [2:0]idle = 0,
              control = 1,
              state_a = 2,
              state_b_1 = 3,
              state_b_2 = 4;
   //          0       1       2         3           4
   reg [4:0] A_reg,B_reg;
   reg en;
///////////////////////////////////////////////////////
/*               Procedual blocks                    */
///////////////////////////////////////////////////////

  always@(posedge clk,rst_n)
  begin
    if(!rst_n)
     begin
         A_reg<=0;
         B_reg<=0;
         state<=idle;
         en<=0;
         C<=0;

     end
    else
     begin
         A_reg<=A;      // A>B ? A : B
         B_reg<=B;      // A<B ? A : B
         state<=state_next;
         en<=alu_en;
     end
  end
  always@(*)
  begin
      state_next = state;
      case(state)
      idle:
      begin
        // Check alu_en
        if(en == 1)
          state_next<=control;
        else
          state_next<=idle;
      end
      control:
      begin
        // Control the next states based on a_en and b_en
        if(a_en == 1 && b_en ==0)       // a_op
           state_next<=state_a;
        else if(b_en == 1 && a_en == 0)    // b_op (SET 1)
           state_next<=state_b_1;
        else if(b_en == 1 && a_en == 1)    // b_op (SET 2)
           state_next<=state_b_2;
        else
           state_next<=control;
      end
      state_a:
      begin

        case(a_op)
          0:
              C <= add(A_reg , B_reg);
          1:
              C <= sub(A_reg , B_reg);
          2:
              C <= A_reg ^ B_reg;
          3,4:
              C <= A_reg & B_reg;
          5:
              C <= A_reg || B_reg;
          6:
              C <= ~(A_reg ^ B_reg);
          default:
              C <= 0;
        endcase
        state_next <= idle;
      end
      state_b_1:
        begin
        case(b_op)
          0:
              C <= ~(A_reg & B_reg);
          1,2:
              C <= add(A_reg , B_reg);

          default:
              C <= 0;
        endcase
        state_next <= idle;
      end
      state_b_2:
      begin
        case(b_op)
          0:
              C <= A_reg ^ B_reg;
          1:
              C <= ~(A_reg ^ B_reg);
          2:
              C <= sub(A_reg , 1);
          3:
              C <= add(B_reg , 2);
        endcase
        state_next <= idle;
      end
    endcase

  end

    function [5:0] sub;
        input [4:0] in1;
        input [4:0] in2;
        //sign= (in1[4]==in2[4]) ? in1[4] : (in1[3:0]>in2[3:0] ? in1[4]:in2[4]);
        //add =(in1[4]==in2[4]) ? {sign,{1'b0,A}-B}:{sign,{1'b0,A}+(~B)+1'b1};
        reg sign;
        begin
        sign =  ~in2[4];
        sub = add(in1,{sign,in2[3:0]});

        end
    endfunction

    function [5:0] add;
        input [4:0] in1;
        input [4:0] in2;
        reg [3:0] A;
        reg [3:0] B;
        reg sign;
        begin
           A = (in1[3:0]>=in2[3:0])? in1[3:0] : in2[3:0];

           B = (in1[3:0]<in2[3:0])? in1[3:0] : in2[3:0];

           sign= (in1[4]==in2[4]) ? in1[4] : (in1[3:0]>in2[3:0] ? in1[4]:in2[4]);

           //add =(in1[4]==in2[4]) ? {sign,{1'b0,A}+B}:{sign,{1'b0,A}+(~B)+1'b1};
           add = (in1[4]==in2[4]) ? {sign,{1'b0,A}+B}:{sign,{1'b0,A}+(~B)+1'b1};
       end
    endfunction
endmodule
