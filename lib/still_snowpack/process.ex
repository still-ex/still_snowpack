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
    {:ok, %{manifest: nil}, {:continue, :start}}
  end

  def handle_continue(:start, state) do
    if Mix.env() == :prod do
      Still.after_compile(&__MODULE__.build/0)
    else
      {:ok, _} = Still.Node.Process.invoke("start", [configuration()], timeout: :infinity)
    end

    {:noreply, state}
  end

  def handle_call(:build, _from, %{manifest: manifest} = state) when not is_nil(manifest) do
    {:reply, manifest, state}
  end

  def handle_call(:build, _from, state) do
    {:ok, manifest} = Still.Node.Process.invoke("build", [configuration()], timeout: :infinity)

    {:reply, manifest, %{state | manifest: manifest}}
  end

  defp configuration do
    %{
      inputPath: get_input_path(),
      outputPath: get_output_path(),
      port: port(),
      hmrPort: config(:hmr_port, 3002)
    }
  end
end
