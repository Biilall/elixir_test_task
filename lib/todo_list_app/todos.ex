defmodule TodoListApp.Todos do
  @moduledoc """
  The Todos context.
  """

  import Ecto.Query, warn: false
  alias TodoListApp.Repo

  alias TodoListApp.Todos.Item
  alias TodoListApp.Todos.List
  alias TodoListAppWeb.Utils

  @doc """
  Returns the list of items.

  ## Examples

      iex> list_items()
      [%Item{}, ...]

  """
  def list_items do
    Repo.all(Item)
  end

  def list_todo_lists do
    Repo.all(List)
  end

  @doc """
  Gets a single item.

  Raises `Ecto.NoResultsError` if the Item does not exist.

  ## Examples

      iex> get_item!(123)
      %Item{}

      iex> get_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_item!(id), do: Repo.get!(Item, id)

  def get_list!(id), do: Repo.get!(List, id) |> Repo.preload(:items)

  @doc """
  Creates a item.

  ## Examples

      iex> create_item(%{field: value})
      {:ok, %Item{}}

      iex> create_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_item(attrs \\ %{}) do
    changeset = %Item{}
    |> Item.changeset(attrs)

    case Repo.insert(changeset) do
      {:ok, item} ->
        {:ok, item}
      {:error, _changeset} ->
        {:error, "could not be created!"}
    end
  end

  def create_list(attrs \\ %{}) do

    changeset =
    %List{}
    |> List.changeset(attrs)

    case Repo.insert(changeset) do
      {:ok, list} ->
        {:ok, list}

      {:error, _changeset} ->
        {:error, "could not be created!"}
    end
  end

  @doc """
  Updates a item.

  ## Examples

      iex> update_item(item, %{field: new_value})
      {:ok, %Item{}}

      iex> update_item(item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_item(%Item{} = item, attrs) do
    item
    |> Repo.preload(:list)
    |> Item.changeset(attrs)
    |> Repo.update()
  end

  def update_list(%List{} = list, attrs) do
    changeset =
      list
      |> List.changeset(attrs)

    case Repo.update(changeset) do
      {:ok, updated} ->
        updated
      {:error, changeset} ->
        errors = Utils.format_changeset_errors(changeset)
       {:error, errors}
    end
  end

  @doc """
  Deletes a item.

  ## Examples

      iex> delete_item(item)
      {:ok, %Item{}}

      iex> delete_item(item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_item(%Item{} = item) do
    Repo.delete(item)
  end

  def delete_list(%List{} = list) do
    Repo.delete(list)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking item changes.

  ## Examples

      iex> change_item(item)
      %Ecto.Changeset{data: %Item{}}

  """
  def change_item(%Item{} = item, attrs \\ %{}) do
    Item.changeset(item, attrs)
  end

  def change_list(%List{} = list, attrs \\ %{}) do
    List.changeset(list, attrs)
  end



  def toggle_item(%Item{completed: false} = item) do
    update_item(item, %{completed: true})
  end

  def toggle_item(%Item{} = item) do
    update_item(item, %{completed: false})
  end

  def toggle_item_by_id(todo_item_id) when is_binary(todo_item_id) or is_integer(todo_item_id) do
    case Repo.get(Item, todo_item_id) |> Repo.preload(:list) do
      nil ->
        {:ok, nil}
      %Item{} = item ->
        toggle_item(item)
    end
  end

  def toggle_list(%List{archived: false} = list) do
    update_list(list, %{archived: true})
  end

  def toggle_list(%List{} = list) do
    update_list(list, %{archived: false})
  end

  def toggle_list_by_id(todo_list_id) when is_binary(todo_list_id) or is_integer(todo_list_id) do
    case Repo.get(List, todo_list_id) do
      nil ->
        {:ok, nil}
      %List{} = list ->
        toggle_list(list)
    end
  end

end
