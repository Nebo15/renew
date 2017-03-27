defmodule Sample.Web.ChangesetView do
  @moduledoc """
  Changeset validation errors are passed to EView.
  This module is added to prevent Phoenix generator to add it's own version.
  """
  use Sample.Web, :view
  alias EView.Views.ValidationError

  def render("error.json", assigns) do
    ValidationError.render("422.json", assigns)
  end
end
