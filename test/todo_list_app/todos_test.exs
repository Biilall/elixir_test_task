defmodule TodoListApp.TodosTest do
  use TodoListApp.DataCase

  alias TodoListApp.Todos

  describe "items" do
    alias TodoListApp.Todos.Item

    @valid_attrs %{completed: true, content: "some content"}
    @update_attrs %{completed: false, content: "some updated content"}
    @invalid_attrs %{completed: nil, content: nil}
    @valid_list_attrs %{title: "test list"}


    def item_fixture(attrs \\ %{}) do
      list = create_list()
      attrs = Map.put(attrs, :list_id, list.id)

      {:ok, item} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Todos.create_item()

      item
    end

    def create_list(attrs \\ %{}) do
      {:ok, list} =
        attrs
        |> Enum.into(@valid_list_attrs)
        |> Todos.create_list()

      list
    end

    test "list_items/0 returns all items" do
      item = item_fixture()
      assert Todos.list_items() == [item]
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert Todos.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      assert {:ok, %Item{} = item} = Todos.create_item(@valid_attrs)
      assert item.completed == true
      assert item.content == "some content"
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, "could not be created!"} = Todos.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      assert {:ok, %Item{} = item} = Todos.update_item(item, @update_attrs)
      assert item.completed == false
      assert item.content == "some updated content"
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = Todos.update_item(item, @invalid_attrs)
      assert item == Todos.get_item!(item.id)
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = Todos.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Todos.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture() |> Repo.preload(:list)
      assert %Ecto.Changeset{} = Todos.change_item(item)
    end
  end
end
