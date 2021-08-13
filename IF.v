module IF(
  // clock & reset
  input clk,
  input rst_n,

  //AR channel
  output [31:0] ARADDR,
  output        ARVALID,
  output [7:0]  ARLEN,
  output [3:0]  ARSIZE,
  output [2:0]  ARPROT,
  output [3:0]  ARCACHE,
  output [1:0]  ARID,
  input         ARREADY,

  //R channel
  input [31:0] RDATA,
  input [1:0]  RRESP,
  input [1:0]  RID,
  input        RVALID,
  output       RREADY,

  //operand port
  //op_type
  //2'b00 : nothing
  //2'b01 : arithmetic
  //2'b10 : logical
  //2'b11 : reserved
  output [1:0] op_type,
  output [3:0] operand_a,
  output       operand_a_valid,
  output [3:0] operand_b,
  output       operand_b_valid,
  output [3:0] operand_c,
  output       operand_c_valid,
  output [31:0] immediate,
  input         delay,

  // ready signal from the execution state
  input         ex_ready
  );

  //register description
  reg [31:0] addr;
  reg        nxt_arvalid;

  //chekc ar state
  reg [2:0] arstate;
  reg [2:0] nxt_arstate;

  //wire description for internal
  //internal FSM signal
  wire start, fetch, proc;
  wire [31:0] nxt_addr;
  //all external ready
  wire ready;

  //enum
  localparam AR_IDLE  = 0;
  localparam AR_VALID = 1;
  localparam AR_READY = 2;
  localparam R_READY  = 3;
  localparam R_WAIT   = 4;

  assign ARADDR = addr;

  always_ff @ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        addr <= 32'h0;
    end else begin
        if(start)      addr <= BOOT_ADDR;
        else if(fetch) addr <= nxt_addr;
        else           addr <= addr;
    end
  end
  assign ARVALID = nxt_arvalid;

  always_ff @ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        nxt_arvalid <= 32'h0;
    end else begin
        if(start || fetch)      nxt_arvalid <= 1'h1; // when reset release, the address are always valid
        else                    nxt_arvalid <= nxt_arvalid;
    end
  end


  //ready checking for internal fsm
  assign ready = ex_ready || ARREADY;

  always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      arstate <= AR_IDLE;
    end
    else begin
      arstate <= nxt_arstate;
    end
  end

  always@(*) begin
    case(arstate) begin
      AR_IDLE : begin
        if(!rst_n) nxt_arstate = AR_IDLE;
        else nxt_arstate = AR_VALID;
      end
      AR_VALID : begin
        if(ready) nxt_arstate = AR_READY;
        else nxt_arstate = AR_VALID;
      end
      AR_READY : begin
        if(ARREADY) nxt_arstate = R_WAIT;
        else nxt_arstate = AR_READY;
      end
      R_WAIT : begin
        if(RVALID) nxt_arstate = R_READY;
        else nxt_arstate =  R_WAIT;
      end
      R_READY : begin
        if(cnt_ar == 0) nxt_arstate = AR_IDLE;
        else nxt_arstate =  R_READY;
      end
      default : begin
        nxt_arstate = 3'hx;
      end
    end
  end

endmodule
