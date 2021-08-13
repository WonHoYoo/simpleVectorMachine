module vector_add(
  input clk,
  input rst_n,
  input [31:0] A,
  input [31:0] B,
  output [31:0] C
  );

assign C = result ;

reg [31:0] result;
  always @ ( posedge clk or negedge rst_n ) begin
    if(!rst_n) begin
      result <= 32'h0;
    end else begin
      result  <=  A + B;
    end
  end
endmodule
