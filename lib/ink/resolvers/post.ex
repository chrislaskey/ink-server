defmodule Ink.Resolver.Post do
  import Ecto.Query, only: [where: 2]

  alias Ink.Repo
  alias Ink.Post
  alias Ink.Post.Instance, as: PostInstance
  alias Ink.Label.Instance, as: LabelInstance

  def all(_args, %{context: %{current_user: %{id: user_id}}}) do
    {:ok, Repo.get_by(Post, user_id: user_id)}
  end

  def all_user_posts(_args, %{context: %{current_user: %{id: id}}}) do
    posts = Post
      |> where(user_id: ^id)
      |> Repo.all

    {:ok, posts}
  end

  def all_user_posts(_args, _info), do: {:error, "Not Authorized"}

  def find(%{uid: uid}, _info) do
    case Repo.get_by(Post, uid: uid) do
      nil -> {:error, "Post #{uid} not found"}
      post -> {:ok, post}
    end
  end

  def find_by_secret(%{uid: uid, secret: secret}, _info) do
    case Repo.get_by(Post, %{secret: secret, uid: uid}) do
      nil -> {:error, "Post #{uid} not found"}
      post -> {:ok, post}
    end
  end

  def create(params, _info) do
    %Post{}
    |> Post.changeset(Post.add_secret(params))
    |> Repo.insert
    |> Post.add_uid
    |> Repo.update
  end

  def update(%{uid: uid, post: post_params}, _info) do
    Repo.get_by!(Post, uid: uid)
    |> Post.update_changeset(post_params)
    |> Repo.update
  end

  def delete(%{uid: uid}, _info) do
    post = Repo.get_by!(Post, uid: uid)
    Repo.delete(post)
  end

  def add_label(
    %{label_id: label_id, uid: uid},
    %{context: %{current_user: %{id: user_id}}}
  ) do
    with {:ok, label} <- LabelInstance.owner?(label_id, user_id),
         {:ok, post} <- PostInstance.owner?(uid, user_id) do
      params = %{
        labels: [ label | PostInstance.labels(post) ]
      }

      post
      |> Repo.preload([:labels, :user])
      |> Post.label_changeset(params)
      |> Repo.update
    else
      {:error, reason} -> {:error, reason}
    end
  end

  def remove_label(
    %{label_id: label_id, uid: uid},
    %{context: %{current_user: %{id: user_id}}}
  ) do
    with {:ok, label} <- LabelInstance.owner?(label_id, user_id),
         {:ok, post} <- PostInstance.owner?(uid, user_id) do
      params = %{
        labels: List.delete(PostInstance.labels(post), label)
      }

      post
      |> Repo.preload([:labels, :user])
      |> Post.label_changeset(params)
      |> Repo.update
    else
      {:error, reason} -> {:error, reason}
    end
  end
end
