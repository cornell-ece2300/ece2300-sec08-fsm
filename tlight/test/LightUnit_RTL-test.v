//========================================================================
// LightUnit_RTL-test
//========================================================================

`include "ece2300/ece2300-test.v"
`include "tlight/LightUnit_RTL.v"

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

  logic        done;
  logic        go;
  logic        ew_red;
  logic        ew_yellow;
  logic        ew_green;
  logic        ns_red;
  logic        ns_yellow;
  logic        ns_green;
  logic  [1:0] state;

  LightUnit_RTL light_control_unit
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
    .state     (state)
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

  string state_str;

  localparam EWG = 2'b00;
  localparam EWY = 2'b01;
  localparam NSG = 2'b10;
  localparam NSY = 2'b11;

  task check
  (
    input logic       done_,
    input logic       go_,
    input logic       ew_red_,
    input logic       ew_yellow_,
    input logic       ew_green_,
    input logic       ns_red_,
    input logic       ns_yellow_,
    input logic       ns_green_,
    input logic [1:0] state_
  );
    if ( !t.failed ) begin
      t.num_checks += 1;

      done = done_;

      #8;

      if ( t.n != 0 ) begin

        case ( state )
          EWG : state_str = "EWG";
          EWY : state_str = "EWY";
          NSG : state_str = "NSG";
          NSY : state_str = "NSY";
          default: state_str = "???";
        endcase

        $display( "%3d: %b > %b {%b,%b,%b} {%b,%b,%b} (%s)", t.cycles,
                   done, go, ew_red, ew_yellow, ew_green, ns_red,
                   ns_yellow, ns_green, state_str );

      end

      `ECE2300_CHECK_EQ( go,        go_        );
      `ECE2300_CHECK_EQ( ew_red,    ew_red_    );
      `ECE2300_CHECK_EQ( ew_yellow, ew_yellow_ );
      `ECE2300_CHECK_EQ( ew_green,  ew_green_  );
      `ECE2300_CHECK_EQ( ns_red,    ns_red_    );
      `ECE2300_CHECK_EQ( ns_yellow, ns_yellow_ );
      `ECE2300_CHECK_EQ( ns_green,  ns_green_  );
      `ECE2300_CHECK_EQ( state,     state_     );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );

    //             -east/west- north/south
    //    done go  red yel gre red yel gre
    check( 1,  1,  0,  0,  1,  1,  0,  0,  EWG  );
    check( 0,  0,  0,  1,  0,  1,  0,  0,  EWY  );
    check( 1,  1,  1,  0,  0,  0,  0,  1,  NSG  );
    check( 0,  0,  1,  0,  0,  0,  1,  0,  NSY  );

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_2_always_done
  //----------------------------------------------------------------------

  task test_case_2_always_done();
    t.test_case_begin( "test_case_2_always_done" );

    //             -east/west- north/south
    //    done go  red yel gre red yel gre
    check( 1,  1,  0,  0,  1,  1,  0,  0,  EWG  );
    check( 1,  0,  0,  1,  0,  1,  0,  0,  EWY  );
    check( 1,  1,  1,  0,  0,  0,  0,  1,  NSG  );
    check( 1,  0,  1,  0,  0,  0,  1,  0,  NSY  );

    check( 1,  1,  0,  0,  1,  1,  0,  0,  EWG  );
    check( 1,  0,  0,  1,  0,  1,  0,  0,  EWY  );
    check( 1,  1,  1,  0,  0,  0,  0,  1,  NSG  );
    check( 1,  0,  1,  0,  0,  0,  1,  0,  NSY  );

    check( 1,  1,  0,  0,  1,  1,  0,  0,  EWG  );
    check( 1,  0,  0,  1,  0,  1,  0,  0,  EWY  );
    check( 1,  1,  1,  0,  0,  0,  0,  1,  NSG  );
    check( 1,  0,  1,  0,  0,  0,  1,  0,  NSY  );

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_3_long_not_done
  //----------------------------------------------------------------------

  task test_case_3_long_not_done();
    t.test_case_begin( "test_case_3_long_not_done" );

    //             -east/west- north/south
    //    done go  red yel gre red yel gre
    check( 0,  1,  0,  0,  1,  1,  0,  0,  EWG  );
    check( 0,  1,  0,  0,  1,  1,  0,  0,  EWG  );
    check( 0,  1,  0,  0,  1,  1,  0,  0,  EWG  );
    check( 1,  1,  0,  0,  1,  1,  0,  0,  EWG  );
    check( 0,  0,  0,  1,  0,  1,  0,  0,  EWY  );

    check( 0,  1,  1,  0,  0,  0,  0,  1,  NSG  );
    check( 0,  1,  1,  0,  0,  0,  0,  1,  NSG  );
    check( 0,  1,  1,  0,  0,  0,  0,  1,  NSG  );
    check( 1,  1,  1,  0,  0,  0,  0,  1,  NSG  );
    check( 0,  0,  1,  0,  0,  0,  1,  0,  NSY  );

    check( 0,  1,  0,  0,  1,  1,  0,  0,  EWG  );

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin();

    if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();
    if ((t.n <= 0) || (t.n == 2)) test_case_2_always_done();
    if ((t.n <= 0) || (t.n == 3)) test_case_3_long_not_done();

    t.test_bench_end();
  end

endmodule
