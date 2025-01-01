"! <p class="shorttext synchronized" lang="EN">Rule Composite - Sequential</p>
"!
"! <p>
"! Iterates through rules. If one fails, exception bubbles up and
"! execution <strong>stops</strong>. Subsequent rules in this sequence are
"! <strong>skipped</strong>.
"! </p>
class zcl_rule_seq_comp definition
                        public
                        create public.

  public section.

    interfaces: zif_rule_command.

    types t_rules type sorted table of ref to zif_rule_command with unique key table_line.

    methods constructor
              importing
                i_rules type zcl_rule_seq_comp=>t_rules.

  protected section.

    data _rules type zcl_rule_seq_comp=>t_rules.

endclass.
class zcl_rule_seq_comp implementation.

  method constructor.

    _rules = i_rules.

  endmethod.
  method zif_rule_command~check.

    loop at _rules into final(rule).

      rule->check( ).

    endloop.

    return me.

  endmethod.

endclass.
