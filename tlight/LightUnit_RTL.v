//========================================================================
// LightUnit_RTL
//========================================================================

`ifndef LIGHT_UNIT_RTL_V
`define LIGHT_UNIT_RTL_V

`include "tlight/Register_2b_RTL.v"

module LightUnit_RTL
(
  input  logic       clk,
  input  logic       rst,

  input  logic       done,
  output logic       go,

  // East/West Traffic Lights
  output logic       ew_red,
  output logic       ew_yellow,
  output logic       ew_green,

  // North/South Traffic Lights
  output logic       ns_red,
  output logic       ns_yellow,
  output logic       ns_green,

  // Testing Output
  output logic [1:0] state
);

  //''' SECTION ASSIGNMENT '''''''''''''''''''''''''''''''''''''''''''''''
  // Implement the control FSM for the LightUnit
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // Your implementation must be divided into three sections shown below.
  // You must use the following binary state encodings.

  // verilator lint_off UNUSEDPARAM
  localparam EWG = 2'b00;
  localparam EWY = 2'b01;
  localparam NSG = 2'b10;
  localparam NSY = 2'b11;
  // verilator lint_on UNUSEDPARAM

  //''' SECTION 1 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // Sequential Logic
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // Do not use an always_ff block in this module. Instead, you must
  // instantiate a Register_2b_RTL for your sequential logic. You should
  // not need to instantiate any other modules.

  //''' SECTION 2 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // Next-State Combinational Logic
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // Implement the next-state combinational logic using a single
  // always_comb block with a single casez statement. Do not use any
  // additional assign statements. Do not include any logic that sets the
  // outputs.

  //''' SECTION 3 ''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // Output Combinational Logic
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // Implement the output combinational logic using a single always_comb
  // block with a single case statement. You must use the provided
  // set_outputs task to set the outputs based on the current state. Do
  // not use any additional assign statements. Do not include any logic
  // that sets the next state.

  task automatic set_outputs
  (
    input logic go_,
    input logic ew_red_,
    input logic ew_yellow_,
    input logic ew_green_,
    input logic ns_red_,
    input logic ns_yellow_,
    input logic ns_green_
  );
    go        = go_;
    ew_red    = ew_red_;
    ew_yellow = ew_yellow_;
    ew_green  = ew_green_;
    ns_red    = ns_red_;
    ns_yellow = ns_yellow_;
    ns_green  = ns_green_;
  endtask

endmodule

`endif /* LIGHT_UNIT_RTL_V */
