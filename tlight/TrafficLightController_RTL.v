//========================================================================
// TrafficLightController_RTL
//========================================================================

`ifndef TRAFFIC_LIGHT_CONTROLLER_RTL_V
`define TRAFFIC_LIGHT_CONTROLLER_RTL_V

`include "tlight/TimerUnit_RTL.v"
`include "tlight/LightUnit_RTL.v"

module TrafficLightController_RTL
(
  input  logic       clk,
  input  logic       rst,

  // East/West Traffic Lights
  output logic       ew_red,
  output logic       ew_yellow,
  output logic       ew_green,

  // North/South Traffic Lights
  output logic       ns_red,
  output logic       ns_yellow,
  output logic       ns_green
);

  //''' DISCUSSION ASSIGNMENT ''''''''''''''''''''''''''''''''''''''''''''
  // Instantiate the light and timer units as separate modules
  //>'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

  // Light Unit

  logic       done;
  logic       go;
  logic [1:0] light_unit_state;

  LightUnit_RTL light_unit
  (
    .clk       (clk),
    .rst       (rst),
    .done      (done),
    .go        (go),
    .ew_red    (ew_red),
    .ew_yellow (ew_yellow),
    .ew_green  (ew_green),
    .ns_red    (ns_red),
    .ns_yellow (ns_yellow),
    .ns_green  (ns_green),
    .state     (light_unit_state)
  );

  `ECE2300_UNUSED( light_unit_state );

  // Timer Unit

  logic [1:0] timer_unit_state;

  TimerUnit_RTL timer_unit
  (
    .clk   (clk),
    .rst   (rst),
    .go    (go),
    .done  (done),
    .state (timer_unit_state)
  );

  `ECE2300_UNUSED( timer_unit_state );

  //<*''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

endmodule

`endif /* TRAFFIC_LIGHT_CONTROLLER_RTL_V */
