defmodule TodoListApp.AutoCleanup do
  use GenServer

  alias TodoListApp.Repo
  import Ecto.Query
  alias TodoListApp.Todos
  alias TodoListApp.Todos.List

  def start_link(_default) do
    GenServer.start_link(__MODULE__, %{})
  end

  @impl true
  def init(socket) do
    schedule_work()
    {:ok, socket}
  end

  def handle_info({:work, msg}, state) do

    updated_date = Timex.shift(Timex.now(), days: -1)

    from(l in List, where: not l.archived, where: l.updated_at <= ^updated_date)
    |> Repo.update_all(set: [archived: true])
    {:noreply, state}
  end

  @impl true

  defp schedule_work() do
    Process.send_after(self(), {:work, "auto_cleanup"}, 300000)
  end
end
