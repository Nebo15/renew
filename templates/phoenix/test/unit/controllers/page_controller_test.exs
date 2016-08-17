defmodule <%= @module_name %>.PageControllerTest do
  use <%= @module_name %>.ConnCase

  test "GET /page", %{conn: conn} do
    conn = get conn, "/page"
    assert response(conn, 200) =~ ~S({"page":{"detail":"This is page."}})
  end
end
