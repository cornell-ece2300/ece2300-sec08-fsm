//========================================================================
// Register_2b_RTL
//========================================================================

`ifndef REGISTER_2B_RTL_V
`define REGISTER_2B_RTL_V

`include "ece2300/ece2300-misc.v"

module Register_2b_RTL
(
  input  logic       clk,
  input  logic       rst,
  input  logic       en,
  input  logic [1:0] d,
  output logic [1:0] q
);

  always_ff @( posedge clk ) begin
    if ( rst )
      q <= 2'b0;
    else if ( !rst && en )
      q <= d;
    else if ( !rst && !en )
      q <= q;
    else
      q <= 'x;
  end

endmodule

`endif /* REGISTER_2B_RTL_V */

