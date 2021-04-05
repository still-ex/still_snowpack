defmodule Still.Snowpack.Supervisor do
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(file) do
    children = [
      {Still.Node.Process, [file: file]},
      Still.Snowpack.Process
    ]

    opts = [strategy: :one_for_one]
    Supervisor.init(children, opts)
  end
end
