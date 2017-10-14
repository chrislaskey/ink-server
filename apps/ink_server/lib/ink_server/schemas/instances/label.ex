defmodule InkServer.Label.Instance do
  import Ecto.Query, only: [from: 2]

  alias InkServer.Repo
  alias InkServer.Label

  def owner?(id, user_id) do
    case Repo.get_by(Label, %{id: id, user_id: user_id}) do
      nil -> {:error, "Label #{id} not owned by user"}
      label -> {:ok, label}
    end
  end

  def add_counts(labels) do
    for label <- labels, do: add_count(label)
  end

  def add_count(label) do
    query = from l in Label,
      join: n in assoc(l, :notes),
      where: [id: ^label.id],
      limit: 1,
      select: count(n.id)
    count = hd(Repo.all(query))

    Map.put(label, :note_count, count)
  end
end
