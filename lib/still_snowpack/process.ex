defmodule Still.Snowpack.Process do
  use GenServer

  import Still.Snowpack.Utils

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def build do
    GenServer.call(__MODULE__, :build, :infinity)
  end

  def init(_) do
    {:ok, %{}, {:continue, :start}}
  end

  def handle_continue(:start, state) do
    if Mix.env() == :prod do
      Still.Compiler.CompilationStage.on_compile(&__MODULE__.build/0)
    else
      {:ok, _} = Still.Node.Process.invoke("start", [configuration()], timeout: :infinity)
    end

    {:noreply, state}
  end

  def handle_call(:build, _from, %{build: build} = state) do
    {:reply, build, state}
  end

  def handle_call(:build, _from, state) do
    {:ok, manifest} = Still.Node.Process.invoke("build", [configuration()])

    {:reply, manifest, state}
  end

  defp configuration do
    %{
      inputPath: get_input_path(),
      outputPath: get_output_path()
    }
  end
end
