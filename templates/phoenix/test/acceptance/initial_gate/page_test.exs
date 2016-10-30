defmodule <%= @module_name %>.PageAcceptanceTest do
  use <%= @module_name %>.AcceptanceCase, async: true

  test "GET /page" do
    %{body: body} = get!("page")

    # This assertion checks our API struct that is described in Nebo #15 API Manifest.
    assert %{
      "meta" => %{
        "url" => "http://localhost:4001/page",
        "type" => "object",
        "request_id" => _,
        "code" => 200
      },
      "data" => %{
        "page" => %{
          "detail" => "This is page."
        },
        "type" => "page"
      }
    } = body |> Poison.decode!
  end
end
