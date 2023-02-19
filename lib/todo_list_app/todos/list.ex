defmodule TodoListApp.Todos.List do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "lists" do
    field :title, :string
    field :archived, :boolean, default: false

    has_many :items, TodoListApp.Todos.Item

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:title, :archived])
    |> validate_required([:title])
    |> unique_constraint(:title)
    |> check_is_list_unarchived()
  end

  def check_is_list_unarchived(changeset) do
    archived = get_field(changeset, :archived)

    if not is_nil(archived) do
      if not archived do
        changeset
      else
        if get_change(changeset, :archived) do
          changeset
          |> add_error(:archived, "Already Archived!")
        else
          changeset
        |> add_error(:archived, "List is Archived!")
        end

      end
    else
      changeset
    end
  end

end
