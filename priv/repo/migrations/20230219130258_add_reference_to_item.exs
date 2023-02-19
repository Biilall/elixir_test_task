defmodule TodoListApp.Repo.Migrations.AddReferenceToItem do
  use Ecto.Migration

  def change do
    alter table(:items) do
      add :list_id, references(:lists, on_delete: :delete_all)
    end
  end
end
