module vector_mul(
  input clk,
  input rst_n,
  input [31:0] A,
  input [31:0] B,
  output [31:0] C
  );

  always @ (posedge clk or negedge rst_n) begin
    if(!rst_n)begin
      C <= 32'h0;
    end else begin
      C <= A * B;
    end
    end


endmodule
