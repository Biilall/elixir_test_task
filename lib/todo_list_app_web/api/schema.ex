defmodule TodoListAppWeb.Api.Schema do
  @moduledoc """
  Absinthe GraphQLSchema
  """

  use Absinthe.Schema
  alias TodoListApp.Todos

  object :todo_item do
    field :id, non_null(:id)
    field :content, non_null(:string)
    field :list_id, non_null(:integer)

    field :is_completed, non_null(:boolean) do
      resolve(fn %{completed: completed}, _, _ ->
        {:ok, !(completed)}
      end)
    end
  end

  object :todo_list do
    field :id, non_null(:id)
    field :title, non_null(:string)
    field :archived, non_null(:boolean)
    field :items, non_null(list_of(:todo_item))
  end

  mutation do
    field :create_todo_item, :todo_item do
      arg(:content, non_null(:string))
      arg(:list_id, non_null(:integer))

      resolve(fn %{content: _content, list_id: _list_id}=attrs, _ ->
        Todos.create_item(attrs)
      end)
    end

    field :create_todo_list, :todo_list do
      arg(:title, non_null(:string))

      resolve(fn %{title: title}, _ ->
        Todos.create_list(%{title: title})
      end)
    end

    field :delete_todo_list, :boolean do
      arg(:id, non_null(:id))

      resolve(fn %{id: id}, _ ->

        try do
          list =
            Todos.get_list!(id)
            Todos.delete_list(list)
          {:ok, true}
        rescue
          Ecto.NoResultsError ->
            {:error,"No result found"}
        end
      end)
    end

    field :update_todo_item, :todo_item do
      arg(:id, non_null(:id))
      arg(:content, non_null(:string))

      resolve(fn %{id: id, content: content}, _ ->
        try do
          todo = Todos.get_item!(id)
          Todos.update_item(todo, %{content: content})
        rescue
          Ecto.NoResultsError ->
            {:error,"No result found"}
        end


      end)
    end

    field :update_todo_list, :todo_list do
      arg(:id, non_null(:id))
      arg(:title, non_null(:string))

      resolve(fn %{id: id, title: title}, _ ->

        try do
            list = Todos.get_list!(id)
            Todos.update_list(list, %{title: title})
        rescue
          Ecto.NoResultsError ->
            {:error,"No result found"}
        end


      end)
    end

    field :toggle_todo_item, :todo_item do
      arg(:id, non_null(:id))

      resolve(fn %{id: item_id}, _ ->
        Todos.toggle_item_by_id(item_id)
      end)
    end

    field :toggle_todo_list, :todo_list do
      arg(:id, non_null(:id))

      resolve(fn %{id: item_id}, _ ->
        Todos.toggle_list_by_id(item_id)
      end)
    end
  end

  query do

    field :todo_lists, non_null(list_of(:todo_list)) do
      resolve(fn _, _ ->
        {:ok, Todos.list_todo_lists()}
      end)
    end

    field :get_list, non_null(:todo_list) do
      arg(:id, non_null(:id))

      resolve(fn %{id: id}, _ ->
        try do
          {:ok, Todos.get_list!(id)}
        rescue
          Ecto.NoResultsError ->
            {:error,"No result found"}
        end
      end)
    end

    field :get_item, non_null(:todo_item) do
      arg(:id, non_null(:id))

      resolve(fn %{id: id}, _ ->
        try do
          {:ok, Todos.get_item!(id)}
        rescue
          Ecto.NoResultsError ->
            {:error,"No result found"}
        end

      end)
    end
  end
end
