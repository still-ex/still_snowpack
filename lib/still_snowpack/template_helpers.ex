defmodule Still.Snowpack.TemplateHelpers do
  import Still.Snowpack.Utils

  def import_css_file(name) do
    if Mix.env() == :prod do
      url = get_relative_output_path(name)

      """
      <link rel="stylesheet" href="/#{url}" />
      """
    else
      """
      <link rel="stylesheet" href="http://localhost:#{port()}/#{name}" />
      """
    end
  end

  def import_js_file(name) do
    if Mix.env() == :prod do
      url = get_relative_output_path(name)

      """
      <script src="/#{url}" type="module"></script>
      """
    else
      """
      <script>
        window.HMR_WEBSOCKET_URL = 'ws://localhost:3002';
      </script>
      <script src="http://localhost:#{port()}/#{name}" type="module"></script>
      """
    end
  end
end
