defmodule Ink.Resolver.Post do
  import Ecto.Query, only: [where: 2]

  alias Ink.Repo
  alias Ink.CurrentUser
  alias Ink.Post
  alias Ink.Post.Instance, as: PostInstance
  alias Ink.Label.Instance, as: LabelInstance

  def all(_params, info) do
    posts = Post
      |> where(user_id: ^CurrentUser.id info)
      |> Repo.all
      |> Repo.preload([:labels])

    {:ok, posts}
  end

  def find(%{uid: uid}, info) do
    case Repo.get_by(Post, uid: uid, user_id: CurrentUser.id info) do
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

  def create(params, info) do
    params = params
             |> CurrentUser.add(info)
             |> Post.add_secret

    %Post{}
    |> Post.changeset(params)
    |> Repo.insert
    |> Post.add_uid
    |> Repo.update
  end

  def update(%{uid: uid, post: post_params}, info) do
    params = CurrentUser.add(post_params, info)

    Repo.get_by!(Post, uid: uid)
    |> Post.update_changeset(params)
    |> Repo.update
  end

  def delete(%{uid: uid}, info) do
    post = Repo.get_by!(Post, uid: uid, user_id: CurrentUser.id info)

    Repo.delete(post)
  end

  def add_label(%{label_id: label_id, uid: uid}, info) do
    with {:ok, label} <- LabelInstance.owner?(label_id, CurrentUser.id info),
         {:ok, post} <- PostInstance.owner?(uid, CurrentUser.id info) do
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

  def remove_label(%{label_id: label_id, uid: uid}, info) do
    with {:ok, label} <- LabelInstance.owner?(label_id, CurrentUser.id info),
         {:ok, post} <- PostInstance.owner?(uid, CurrentUser.id info) do
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
