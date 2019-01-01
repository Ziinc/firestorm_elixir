defmodule FirestormData.Threads.Thread do
  @moduledoc """
  Schema for forum threads.
  """

  use FirestormData.Data, :model

  alias FirestormData.{
    Posts.Post,
    Threads.Thread,
    Categories.Category
  }

  @type t :: %Thread{
          id: String.t(),
          title: String.t(),
          category: Category.t() | %Ecto.Association.NotLoaded{},
          posts: [Post.t()] | %Ecto.Association.NotLoaded{},
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }
  schema "firestorm_threads_threads" do
    field(:title, :string)
    belongs_to(:category, Category)
    has_many(:posts, Post)

    timestamps()
  end

  def changeset(%__MODULE__{} = thread, attrs \\ %{}) do
    thread
    |> cast(attrs, [:title, :category_id])
    |> validate_required([:title, :category_id])
  end

  def new_changeset(%{thread: thread_attrs, post: post_attrs}) do
    post_changeset =
      %Post{}
      |> cast(post_attrs, [:body, :user_id])
      |> validate_required([:body, :user_id])

    %__MODULE__{}
    |> changeset(thread_attrs)
    |> put_assoc(:posts, [post_changeset])
  end
end
