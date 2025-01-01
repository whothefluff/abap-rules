"! <p class="shorttext synchronized" lang="EN">Rule Command</p>
"!
"! <p>
"!   Encapsulates check requests fully
"! </p>
interface zif_rule_command public.

  methods check
            returning
              value(r_self) type ref to zif_rule_command
            raising
              zcx_static_check_aggr.

endinterface.
