defmodule Ink.Label.Instance do

  alias Ink.Repo
  alias Ink.Label

  def owner?(id, user_id) do
    case Repo.get_by(Label, %{id: id, user_id: user_id}) do
      nil -> {:error, "Label #{id} not owned by user"}
      label -> {:ok, label}
    end
  end

end
