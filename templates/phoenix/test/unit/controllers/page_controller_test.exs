defmodule <%= @module_name %>.PageControllerTest do
  use <%= @module_name %>.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert response(conn, 200) =~ ~S({"page":{"detail":"This is page."}})
  end
end
