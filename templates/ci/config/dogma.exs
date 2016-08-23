use Mix.Config
alias Dogma.Rule

config :dogma,
  rule_set: Dogma.RuleSet.All,
  override: [
    %Rule.LineLength{ max_length: 120 },
    %Rule.TakenName{ enabled: false }, # TODO: https://github.com/lpil/dogma/issues/201
    %Rule.InfixOperatorPadding{ enabled: false }
  ],
  exclude: [
    ~r(\Adeps/),
    ~r(\Alib/<%= @application_name %>/tasks.ex), # TODO: https://github.com/lpil/dogma/issues/221
  ]
