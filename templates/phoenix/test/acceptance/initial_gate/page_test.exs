defmodule <%= @module_name %>.PageAcceptanceTest do
  use <%= @module_name %>.AcceptanceCase, async: true

  test "GET /page" do
    %{body: body} = get!("page")

    assert body == ~S({"page":{"detail":"This is page."}})
  end
end
