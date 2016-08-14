%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["lib/", "www/"]
      },
      checks: [
        {Credo.Check.Design.TagTODO, exit_status: 0}
      ]
    }
  ]
}
