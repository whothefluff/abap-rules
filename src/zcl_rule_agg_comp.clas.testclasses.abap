*"* use this source file for your ABAP unit test classes

class _ definition deferred.

class zcl_rule_agg_comp definition local friends _.

"! <p class="shorttext synchronized" lang="EN">Tests</p>
class _ definition
        final
        for testing
        risk level harmless
        duration short.

  private section.

    methods constructor_sets_attr for testing.

    methods check_collects_multiple_errors for testing
              raising
                zcx_static_check_aggr.

    methods check_calls_every_rule for testing
              raising
                zcx_static_check_aggr.

endclass.
class _ implementation.

  method constructor_sets_attr.

    "arrange
    final(some_rules) = value zcl_rule_agg_comp=>t_rules( ( cast #( cl_abap_testdouble=>create( 'ZIF_RULE_COMMAND' ) ) )
                                                          ( cast #( cl_abap_testdouble=>create( 'ZIF_RULE_COMMAND' ) ) ) ).

    "act
    final(o) = new zcl_rule_agg_comp( some_rules ).

    "assert
    cl_abap_unit_assert=>assert_true( xsdbool( o->_rules eq some_rules ) ).

  endmethod.
  method check_collects_multiple_errors.

    "arrange
    final(some_rules) = value zcl_rule_agg_comp=>t_rules( let random_generator = cl_abap_random=>create( cl_abap_random=>seed( ) ) in
                                                          for i = 0 until i gt random_generator->intinrange( low = 2
                                                                                                             high = 50 )
                                                          ( cast #( cl_abap_testdouble=>create( 'ZIF_RULE_COMMAND' ) ) ) ).

    loop at some_rules into final(r).

      cl_abap_testdouble=>configure_call( r )->raise_exception( new zcx_static_check_aggr( value #( ( new zcx_static_check( ) ) ) ) ).

      r->check( ).

    endloop.

    final(o) = cast zif_rule_command( new zcl_rule_agg_comp( some_rules ) ).

    "act
    try.

      o->check( ).

    catch zcx_static_check_aggr into final(e) ##NO_HANDLER.

    endtry.

    "assert
    cl_abap_unit_assert=>assert_equals( exp = lines( some_rules )
                                        act = e->size( ) ).

  endmethod.
  method check_calls_every_rule.

    "arrange
    final(some_rules) = value zcl_rule_agg_comp=>t_rules( let random_generator = cl_abap_random=>create( cl_abap_random=>seed( ) ) in
                                                          for i = 0 until i gt random_generator->intinrange( low = 2
                                                                                                             high = 50 )
                                                          ( cast #( cl_abap_testdouble=>create( 'ZIF_RULE_COMMAND' ) ) ) ).

    loop at some_rules into final(r).

      cl_abap_testdouble=>configure_call( r )->and_expect( )->is_called_once( ).

      r->check( ).

    endloop.

    final(o) = cast zif_rule_command( new zcl_rule_agg_comp( some_rules ) ).

    "act
    o->check( ).

    "assert
    loop at some_rules into final(spy).

      cl_abap_testdouble=>verify_expectations( spy ).

    endloop.

  endmethod.

endclass.
