//========================================================================
// tlight-sim
//========================================================================
// Author : Christopher Batten (Cornell)
// Date   : October 23, 2026

`include "ece2300/ece2300-misc.v"
`include "tlight/TrafficLightController_RTL.v"

module Top();

  //----------------------------------------------------------------------
  // Clock/Reset
  //----------------------------------------------------------------------

  // verilator lint_off BLKSEQ
  logic clk;
  initial clk = 1'b1;
  always #5 clk = ~clk;
  // verilator lint_on BLKSEQ

  logic rst;

  //----------------------------------------------------------------------
  // Instantiate traffic light controller
  //----------------------------------------------------------------------

  logic        ew_red;
  logic        ew_yellow;
  logic        ew_green;
  logic        ns_red;
  logic        ns_yellow;
  logic        ns_green;

  TrafficLightController_RTL light_control_unit
  (
    .clk       (clk),
    .rst       (rst),
    .ew_red    (ew_red),
    .ew_yellow (ew_yellow),
    .ew_green  (ew_green),
    .ns_red    (ns_red),
    .ns_yellow (ns_yellow),
    .ns_green  (ns_green)
  );

  //----------------------------------------------------------------------
  // Perform the simulation
  //----------------------------------------------------------------------

  integer c;
  string  ew_str;
  string  west_str;
  string  ns_red_str;
  string  ns_yellow_str;
  string  ns_green_str;

  initial begin

    // Process command line arguments

    if ( $test$plusargs( "help" ) ) begin
      $display("");
      $display(" tlight-sim");
      $display("");
      $finish;
    end

    #1;

    // Reset sequence

    rst = 1;
    #10;
    rst = 0;

    // Simulate up to 100 cycles

    for ( int cycles = 0; cycles < 100; cycles = cycles+1 ) begin

      // Traffic light strings in red/yellow/green order (ANSI colors)

      case ( {ew_red,ew_yellow,ew_green} )
        { 1'b0, 1'b0, 1'b1 } : ew_str = "○ ○ \x1b[32m●\x1b[0m";
        { 1'b0, 1'b1, 1'b0 } : ew_str = "○ \x1b[33m●\x1b[0m ○";
        { 1'b1, 1'b0, 1'b0 } : ew_str = "\x1b[31m●\x1b[0m ○ ○";
        default : ew_str = "???";
      endcase

      // West lamps run green/yellow/red, with red on the right.

      case ( {ew_red,ew_yellow,ew_green} )
        { 1'b0, 1'b0, 1'b1 } : west_str = "\x1b[32m●\x1b[0m ○ ○";
        { 1'b0, 1'b1, 1'b0 } : west_str = "○ \x1b[33m●\x1b[0m ○";
        { 1'b1, 1'b0, 1'b0 } : west_str = "○ ○ \x1b[31m●\x1b[0m";
        default : west_str = "???";
      endcase

      // North/south lamps are stacked; north has red at the bottom.

      ns_red_str    = "○";
      ns_yellow_str = "○";
      ns_green_str  = "○";

      case ( {ns_red,ns_yellow,ns_green} )
        { 1'b0, 1'b0, 1'b1 } : ns_green_str  = "\x1b[32m●\x1b[0m";
        { 1'b0, 1'b1, 1'b0 } : ns_yellow_str = "\x1b[33m●\x1b[0m";
        { 1'b1, 1'b0, 1'b0 } : ns_red_str    = "\x1b[31m●\x1b[0m";
        default : begin
          ns_red_str    = "?";
          ns_yellow_str = "?";
          ns_green_str  = "?";
        end
      endcase

      // Display output

      $display("");
      $display("                |     :     |                ");
      $display("                |     :     |                ");
      $display("                |     :     |                ");
      $display("                |     :     |                ");
      $display("              %s |     :     |                ",ns_green_str);
      $display("              %s |     :     |                ",ns_yellow_str);
      $display("              %s |   N :     | %s        ",ns_red_str,ew_str);
      $display(" ---------------'           '--------------- ");
      $display("                                             ");
      $display("                             E               ");
      $display(" - - - - - - - -             - - - - - - - - ");
      $display("               W                             ");
      $display("                                             ");
      $display(" ---------------.           .--------------- ");
      $display("          %s |     : S   | %s              ",west_str,ns_red_str);
      $display("                |     :     | %s              ",ns_yellow_str);
      $display("                |     :     | %s              ",ns_green_str);
      $display("                |     :     |                ");
      $display("                |     :     |                ");
      $display("                |     :     |                ");
      $display("                |     :     |                ");
      $display("");

      // Advance time

      #10;

      // Wait for key press

      $display( "Press enter for toggle the clock." );
      $display( "Enter q then press enter to quit." );

      c = $fgetc( 'h8000_0000 );
      if ( c == "q" )
        $finish;

      // Redraw the console

      for ( int i = 0; i < 26; i++ ) begin
        $write("\x1b[A");
      end

    end

    $finish;
  end

endmodule

