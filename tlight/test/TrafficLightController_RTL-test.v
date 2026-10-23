//========================================================================
// TrafficLightController_RTL-test
//========================================================================

`include "ece2300/ece2300-test.v"
`include "tlight/TrafficLightController_RTL.v"

module Top();

  //----------------------------------------------------------------------
  // Setup
  //----------------------------------------------------------------------

  logic clk;
  logic rst;

  TestUtilsClkRst t
  (
    .clk (clk),
    .rst (rst)
  );

  //----------------------------------------------------------------------
  // Instantiate design under test
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
  // check
  //----------------------------------------------------------------------
  // The ECE 2300 test framework adds a 1 tau delay with respect to the
  // rising clock edge at the very beginning of the test bench. So if we
  // immediately set the inputs this will take effect 1 tau after the
  // clock edge. Then we wait 8 tau, check the outputs, and wait 2 tau
  // which means the next check will again start 1 tau after the rising
  // clock edge.

  task check
  (
    input logic       ew_red_,
    input logic       ew_yellow_,
    input logic       ew_green_,
    input logic       ns_red_,
    input logic       ns_yellow_,
    input logic       ns_green_
  );
    if ( !t.failed ) begin
      t.num_checks += 1;

      #8;

      if ( t.n != 0 ) begin

        $display( "%3d: {%b,%b,%b} {%b,%b,%b}", t.cycles,
                   ew_red, ew_yellow, ew_green, ns_red,
                   ns_yellow, ns_green );

      end

      `ECE2300_CHECK_EQ( ew_red,    ew_red_    );
      `ECE2300_CHECK_EQ( ew_yellow, ew_yellow_ );
      `ECE2300_CHECK_EQ( ew_green,  ew_green_  );
      `ECE2300_CHECK_EQ( ns_red,    ns_red_    );
      `ECE2300_CHECK_EQ( ns_yellow, ns_yellow_ );
      `ECE2300_CHECK_EQ( ns_green,  ns_green_  );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );

    //     -east/west- north/south
    //     red yel gre red yel gre

    check( 0,  0,  1,  1,  0,  0  );
    check( 0,  0,  1,  1,  0,  0  );
    check( 0,  0,  1,  1,  0,  0  );
    check( 0,  0,  1,  1,  0,  0  );

    check( 0,  1,  0,  1,  0,  0  );

    check( 1,  0,  0,  0,  0,  1  );
    check( 1,  0,  0,  0,  0,  1  );
    check( 1,  0,  0,  0,  0,  1  );
    check( 1,  0,  0,  0,  0,  1  );

    check( 1,  0,  0,  0,  1,  0  );

    check( 0,  0,  1,  1,  0,  0  );
    check( 0,  0,  1,  1,  0,  0  );
    check( 0,  0,  1,  1,  0,  0  );
    check( 0,  0,  1,  1,  0,  0  );

    check( 0,  1,  0,  1,  0,  0  );

    check( 1,  0,  0,  0,  0,  1  );
    check( 1,  0,  0,  0,  0,  1  );
    check( 1,  0,  0,  0,  0,  1  );
    check( 1,  0,  0,  0,  0,  1  );

    check( 1,  0,  0,  0,  1,  0  );

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin();

    if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();

    t.test_bench_end();
  end

endmodule
