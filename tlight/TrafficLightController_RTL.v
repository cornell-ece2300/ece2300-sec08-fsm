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

endmodule

`endif /* TRAFFIC_LIGHT_CONTROLLER_RTL_V */
