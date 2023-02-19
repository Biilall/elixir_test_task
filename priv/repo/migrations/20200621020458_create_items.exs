defmodule TodoListApp.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :content, :string, null: false
      add :completed, :boolean

      timestamps()
    end

  end
end
