//========================================================================
// TimerUnit_RTL-test
//========================================================================

`include "ece2300/ece2300-test.v"
`include "tlight/TimerUnit_RTL.v"

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

  logic        go;
  logic        done;
  logic  [1:0] state;

  TimerUnit_RTL timer_unit
  (
    .clk   (clk),
    .rst   (rst),
    .go    (go),
    .done  (done),
    .state (state)
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

  localparam S0 = 2'b00;
  localparam S1 = 2'b01;
  localparam S2 = 2'b10;
  localparam S3 = 2'b11;

  task check
  (
    input logic       go_,
    input logic       done_,
    input logic [1:0] state_
  );
    if ( !t.failed ) begin
      t.num_checks += 1;

      go = go_;

      #8;

      if ( t.n != 0 ) begin

        case ( state )
          S0 : state_str = "S0";
          S1 : state_str = "S1";
          S2 : state_str = "S2";
          S3 : state_str = "S2";
          default: state_str = "??";
        endcase

        $display( "%3d: %b > %b (%s)", t.cycles,
                   go, done, state_str );

      end

      `ECE2300_CHECK_EQ( done,  done_ );
      `ECE2300_CHECK_EQ( state, state_ );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );

    //     go  done state
    check( 1,  0,   S0 );
    check( 0,  0,   S1 );
    check( 0,  0,   S2 );
    check( 0,  1,   S3 );

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_2_always_go
  //----------------------------------------------------------------------

  task test_case_2_always_go();
    t.test_case_begin( "test_case_2_always_go" );

    //     go  done state
    check( 1,  0,   S0 );
    check( 1,  0,   S1 );
    check( 1,  0,   S2 );
    check( 1,  1,   S3 );

    check( 1,  0,   S0 );
    check( 1,  0,   S1 );
    check( 1,  0,   S2 );
    check( 1,  1,   S3 );

    check( 1,  0,   S0 );
    check( 1,  0,   S1 );
    check( 1,  0,   S2 );
    check( 1,  1,   S3 );

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_3_long_not_go
  //----------------------------------------------------------------------

  task test_case_3_long_not_go();
    t.test_case_begin( "test_case_3_long_not_go" );

    //     go  done state
    check( 0,  0,   S0 );
    check( 0,  0,   S0 );
    check( 0,  0,   S0 );
    check( 0,  0,   S0 );

    check( 1,  0,   S0 );
    check( 0,  0,   S1 );
    check( 0,  0,   S2 );
    check( 0,  1,   S3 );

    check( 0,  0,   S0 );
    check( 0,  0,   S0 );
    check( 0,  0,   S0 );
    check( 0,  0,   S0 );

    check( 1,  0,   S0 );
    check( 0,  0,   S1 );
    check( 0,  0,   S2 );
    check( 0,  1,   S3 );

    check( 0,  0,   S0 );

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin();

    if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();
    if ((t.n <= 0) || (t.n == 2)) test_case_2_always_go();
    if ((t.n <= 0) || (t.n == 3)) test_case_3_long_not_go();

    t.test_bench_end();
  end

endmodule
