//========================================================================
// Register_2b_RTL-test
//========================================================================

`include "ece2300/ece2300-test.v"
`include "tlight/Register_2b_RTL.v"

module Top();

  //----------------------------------------------------------------------
  // Setup
  //----------------------------------------------------------------------

  logic clk;
  logic rst_implicit;

  TestUtilsClkRst t
  (
    .clk (clk),
    .rst (rst_implicit)
  );

  //----------------------------------------------------------------------
  // Instantiate design under test
  //----------------------------------------------------------------------

  logic       rst;
  logic       en;
  logic [1:0] d;
  logic [1:0] q;

  Register_2b_RTL register
  (
    .clk (clk),
    .rst (rst),
    .en  (en),
    .d   (d),
    .q   (q)
  );

  // We have two ways to reset the design under test: (1) the ECE 2300
  // testing framework will automatically reset the design under test
  // before each test case using the rst_implicit signal; and (2) our
  // test cases can also explicitly reset the design under test to enable
  // directed test cases for reset using the rst_explicit signal. So the
  // actual reset used for the design under test is just the OR of these
  // two signals.

  logic rst_explicit;
  assign rst = rst_implicit | rst_explicit;

  //------------------------------------------------------------------------
  // check
  //------------------------------------------------------------------------
  // The ECE 2300 test framework adds a 1 tau delay with respect to the
  // rising clock edge at the very beginning of the test bench. So if we
  // immediately set the inputs this will take effect 1 tau after the clock
  // edge. Then we wait 8 tau, check the outputs, and wait 2 tau which
  // means the next check will again start 1 tau after the rising clock
  // edge.

  task check
  (
    input logic       rst_,
    input logic       en_,
    input logic [1:0] d_,
    input logic [1:0] q_
  );
    if ( !t.failed ) begin
      t.num_checks += 1;

      rst_explicit = rst_;
      en = en_;
      d  = d_;

      #8;

      if ( t.n != 0 )
        $display( "%3d: %b %b %h > %b", t.cycles, rst, en, d, q );

      `ECE2300_CHECK_EQ( q, q_ );

      #2;

    end
  endtask

  //----------------------------------------------------------------------
  // test_case_1_basic
  //----------------------------------------------------------------------

  task test_case_1_basic();
    t.test_case_begin( "test_case_1_basic" );

    //    rst en d      q
    check( 0, 1, 2'b00, 2'b00 );
    check( 0, 1, 2'b01, 2'b00 );
    check( 0, 1, 2'b00, 2'b01 );

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_2_directed_values
  //----------------------------------------------------------------------
  // Test registering different multi-bit values

  task test_case_2_directed_values();
    t.test_case_begin( "test_case_2_directed_values" );

    //    rst en d      q
    check( 0, 1, 2'b00, 2'b00 );
    check( 0, 1, 2'b01, 2'b00 );
    check( 0, 1, 2'b00, 2'b01 );
    check( 0, 1, 2'b10, 2'b00 );
    check( 0, 1, 2'b00, 2'b10 );
    check( 0, 1, 2'b11, 2'b00 );
    check( 0, 1, 2'b00, 2'b11 );
    check( 0, 1, 2'b01, 2'b00 );
    check( 0, 1, 2'b10, 2'b01 );
    check( 0, 1, 2'b11, 2'b10 );
    check( 0, 1, 2'b00, 2'b11 );
    check( 0, 1, 2'b00, 2'b00 );

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_3_directed_enable
  //----------------------------------------------------------------------
  // Test enable input

  task test_case_3_directed_enable();
    t.test_case_begin( "test_case_3_directed_enable" );

    //    rst en d      q
    check( 0, 1, 2'b00, 2'b00 ); // en=1
    check( 0, 1, 2'b11, 2'b00 );
    check( 0, 1, 2'b01, 2'b11 );

    check( 0, 0, 2'b11, 2'b01 ); // en=0
    check( 0, 0, 2'b10, 2'b01 );
    check( 0, 0, 2'b11, 2'b01 );

    check( 0, 1, 2'b11, 2'b01 ); // en=1
    check( 0, 1, 2'b01, 2'b11 );
    check( 0, 1, 2'b00, 2'b01 );

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_4_directed_reset
  //----------------------------------------------------------------------
  // Test various reset conditions

  task test_case_4_directed_reset();
    t.test_case_begin( "test_case_4_directed_reset" );

    //    rst en d      q
    check( 0, 1, 2'b00, 2'b00 );
    check( 0, 1, 2'b01, 2'b00 );
    check( 0, 1, 2'b10, 2'b01 );

    check( 1, 1, 2'b11, 2'b10 ); // rst=1, en=1
    check( 1, 1, 2'b01, 2'b00 );
    check( 1, 1, 2'b10, 2'b00 );

    check( 0, 1, 2'b11, 2'b00 );
    check( 0, 1, 2'b01, 2'b11 );
    check( 0, 1, 2'b10, 2'b01 );

    check( 1, 0, 2'b11, 2'b10 ); // rst=1, en=0
    check( 1, 0, 2'b01, 2'b00 );
    check( 1, 0, 2'b10, 2'b00 );

    check( 0, 0, 2'b11, 2'b00 );
    check( 0, 0, 2'b01, 2'b00 );
    check( 0, 0, 2'b10, 2'b00 );

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // test_case_5_xprop
  //----------------------------------------------------------------------
  // The output is zero for the first check because the ECE 2300 testing
  // framework always resets the design under test before each test case.

  task test_case_5_xprop();
    t.test_case_begin( "test_case_5_xprop" );

    //     rst  en  d   q
    check( 'x, 'x, 'x,  0 );
    check( 'x, 'x, 'x, 'x );
    check( 'x, 'x, 'x, 'x );
    check( 'x, 'x, 'x, 'x );

    t.test_case_end();
  endtask

  //----------------------------------------------------------------------
  // main
  //----------------------------------------------------------------------

  initial begin
    t.test_bench_begin();

    if ((t.n <= 0) || (t.n == 1)) test_case_1_basic();
    if ((t.n <= 0) || (t.n == 2)) test_case_2_directed_values();
    if ((t.n <= 0) || (t.n == 3)) test_case_3_directed_enable();
    if ((t.n <= 0) || (t.n == 4)) test_case_4_directed_reset();
    if ((t.n <= 0) || (t.n == 5)) test_case_5_xprop();

    t.test_bench_end();
  end

endmodule
