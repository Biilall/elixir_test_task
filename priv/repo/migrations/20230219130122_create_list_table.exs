defmodule TodoListApp.Repo.Migrations.CreateListTable do
  use Ecto.Migration

  def change do
    create table(:lists) do
      add :title, :string, null: false
      add :archived, :boolean

      timestamps()
    end

    create unique_index(:lists, [:title])

  end
end
