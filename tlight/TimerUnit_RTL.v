//========================================================================
// TimerUnit_RTL
//========================================================================

`ifndef TIMER_UNIT_RTL_V
`define TIMER_UNIT_RTL_V

`include "tlight/Register_2b_RTL.v"

module TimerUnit_RTL
(
  input  logic       clk,
  input  logic       rst,
  input  logic       go,
  output logic       done,
  output logic [1:0] state
);

  //''' SECTION ASSIGNMENT '''''''''''''''''''''''''''''''''''''''''''''''
  // Implement the control FSM for the TimerUnit
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // Your implementation must be divided into three sections shown below.
  // You must use the following binary state encodings.

  // verilator lint_off UNUSEDPARAM
  localparam S0 = 2'b00;
  localparam S1 = 2'b01;
  localparam S2 = 2'b10;
  localparam S3 = 2'b11;
  // verilator lint_on UNUSEDPARAM

  //''' SECTION 1 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // Sequential Logic
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // Do not use an always_ff block in this module. Instead, you must
  // instantiate a Register_2b_RTL for your sequential logic. You should
  // not need to instantiate any other modules.

  //>*''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

  logic [1:0] state_next;

  Register_2b_RTL state_reg
  (
    .clk (clk),
    .rst (rst),
    .en  (1'b1),
    .d   (state_next),
    .q   (state)
  );

  //<*''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

  //''' SECTION 2 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // Next-State Combinational Logic
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // Implement the next-state combinational logic using a single
  // always_comb block with a single casez statement. Do not use any
  // additional assign statements. Do not include any logic that sets the
  // outputs.

  //>*''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

  // Next-state combinational logic

  always_comb begin
    casez ( { state, go } )
      // state go
      {  S0,   1'b0 } : state_next = S0;
      {  S0,   1'b1 } : state_next = S1;
      {  S1,   1'b? } : state_next = S2;
      {  S2,   1'b? } : state_next = S3;
      {  S3,   1'b? } : state_next = S0;
      default: state_next = 'x;
    endcase
  end

  //<*''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

  //''' SECTION 3 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // Output Combinational Logic
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // Implement the output combinational logic using a single always_comb
  // block with a single case statement. Do not use any additional assign
  // statements. Do not include any logic that sets the next state.

  //>*''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

  always_comb begin
    case ( state )
      S0 : done = 0;
      S1 : done = 0;
      S2 : done = 0;
      S3 : done = 1;
      default : done = 'x;
    endcase
  end

  //<*''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

endmodule

`endif /* TIMER_UNIT_RTL_V */

