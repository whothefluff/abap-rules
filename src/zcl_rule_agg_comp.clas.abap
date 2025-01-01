"! <p class="shorttext synchronized" lang="EN">Rule Composite - Aggregate</p>
"!
"! <p>
"! Iterates through rules <strong>collecting</strong> all errors without
"! stopping
"! </p>
class zcl_rule_agg_comp definition
                        public
                        create public.

  public section.

    interfaces: zif_rule_command.

    types t_rules type sorted table of ref to zif_rule_command with unique key table_line.

    methods constructor
              importing
                i_rules type zcl_rule_agg_comp=>t_rules.

  protected section.

    data _rules type zcl_rule_agg_comp=>t_rules.

endclass.
class zcl_rule_agg_comp implementation.

  method constructor.

    _rules = i_rules.

  endmethod.
  method zif_rule_command~check.

    data(errors) = value zcx_static_check_aggr=>t_list( ).

    loop at _rules into final(rule).

      try.

        rule->check( ).

      catch zcx_static_check_aggr into final(e).

        errors = value #( base errors
                          ( lines of e->untyped_list( ) ) ).

      endtry.

    endloop.

    return cond #( when errors is initial
                   then me
                   else throw zcx_static_check_aggr( errors ) ).

  endmethod.

endclass.
