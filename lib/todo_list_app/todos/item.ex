defmodule TodoListApp.Todos.Item do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :completed, :boolean, default: false
    field :content, :string

    belongs_to :list, TodoListApp.Todos.List
    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:content, :completed, :list_id])
    |> validate_required([:content])
    |> cast_assoc(:list)
    |> check_is_list_unarchived()
  end

  def check_is_list_unarchived(changeset) do
    list = get_field(changeset, :list)

    if not is_nil(list) do
      if not list.archived do
        changeset
      else
        changeset
        |> add_error(:list, "List is Archived!")
      end
    else
      changeset
    end
  end

end
