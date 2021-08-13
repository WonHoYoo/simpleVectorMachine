//Function Unit
//Related to Integer Operation

module FV #(
  //generate adder number
  parameter add_num = 1;
  //generate multiplier number
  parameter mul_num = 1;
  )(
  input clk,
  input rst_n,
  input [3:0] Op,
  input  [add_num-1:0][31:0] A_ADD,
  input  [add_num-1:0][31:0] B_ADD,
  output [add_num-1:0][31:0] C_ADD,

  input  [mul_num-1:0][31:0] A_MUL,
  input  [mul_num-1:0][31:0] B_MUL,
  output [mul_num-1:0][31:0] C_MUL
  );



  genvar idx;


  generate for (idx=0; idx < add_num; idx++) begin : gen_add
    vector_add vAdd
    (
      .clk,
      .rst_n,
      .A(A_ADD[idx]),
      .B(B_ADD[idx]),
      .C(C_ADD[idx])
    );
  end

  generate for (idx=0; idx < mul_num; idx++) begin : gen_mul
    vector_mul vMul
    (
      .clk,
      .rst_n,
      .A(A_MUL[idx]),
      .B(B_MUL[idx]),
      .C(C_MUL[idx])
    );
  end

endmodule
