defmodule <%= @module_name %>.ErrorView do
  @moduledoc """
  Place your error views here.
  """

  use <%= @module_name %>.Web, :view

  def render("404.json", _assigns) do
    render_error(404, "Page not found")
  end

  def render("500.json", _assigns) do
    render_error(500, "Internal server error")
  end

  def render("400.json", %{errors: errors}) do
    %{meta: %{code: 400}, errors: %{code: 400, error: "bad_request", details: errors}}
  end

  def render("400.json", %{reason: reason}) do
    %{meta: %{code: 400}, errors: %{code: 400, error: "bad_request", details: reason.exception.message}}
  end

  def render("401.json", %{errors: reason}) do
    %{meta: %{code: 401}, errors: %{code: 401, error: reason}}
  end

  def render("422.json", %{changeset: changeset}) do
    err = Ecto.Changeset.traverse_errors(changeset, fn
      msg -> render_detail(msg)
    end)

    render_validation_err "request_validation_failed", err
  end

  def render("422.json", %{type: type, param: param, msg: msg}) do
    render_validation_err type, %{entry_type: "field", entry_id: param, validation_message: msg}
  end

  defp render_detail({message, values}) do
    Enum.reduce values, message, fn {k, v}, acc ->
      String.replace(acc, "%{#{k}}", to_string(v))
    end
  end

  defp render_detail(message) do
    message
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.json", assigns
  end

  def render_validation_err(type, err) do
    %{meta: %{code: 422}, errors: %{code: 422, type: type, invalid: [err]}}
  end

  def render_error(code, err) do
    %{meta: %{code: code, error: err}}
  end
end
