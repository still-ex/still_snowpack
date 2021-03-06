# Still.Snowpack

**This is no longer the recommended way to use Snowpack. See the [docs](https://hexdocs.pm/still/getting_started.html) for more information.**

Adds [Snowpack][snowpack] support to [Still][still]. For an example of
a website using this package with [Tailwind](https://tailwindcss.com/) see
[here](https://github.com/gabrielpoca/gabrielpoca.com/tree/bddd8e0df0f38b2417c51aaa25d6e5d00e279460)

## Installation

Add `still_snowpack` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:still_snowpack, "~> 0.1.0"}
  ]
end
```

Fetch the dependencies:

```
mix deps.get
```

Update your config to include `Still.Snowpack.TemplateHelpers` and set the input and output path for snowpack:

```elixir
config :still,
  ...
  template_helpers: [Still.Snowpack.TemplateHelpers],
  ...

config :still_snowpack,
  port: 3001, # optional
  hmr_port: 3002, # optional
  input: Path.join(Path.dirname(__DIR__), "assets"),
  output: Path.join([Path.dirname(__DIR__), "_site", "assets"])
```

Setup an npm package to store your snowpack configuration and the frontend code:

```
mkdir assets
cd assets
npm init -f
```

Add the following dependency to `assets/package.json`:

```json
{
  ...
  "dependencies": {
    ...
    "still_snowpack": "file:../deps/still_snowpack/priv/package",
    ...
  }
}
```

Install the dependencies:

```
npm install
```

Create a file `assets/index.js` with the following contents:

```js
module.exports = require("still_snowpack");
```

Add `Still.Snowpack.Supervisor` to your `Application` and pass the path to the JavaScript file as an argument:

```elixir
defmodule YourModule.Application do
  use Application

  @js_file Path.join(Path.dirname(__DIR__), "../assets/index.js") |> Path.expand()

  def start(_type, _args) do
    children = [
      {Still.Snowpack.Supervisor, @js_file},
      ...
    ]

    opts = [strategy: :one_for_one, name: Still.NodeJS.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
```

_If you don't have `Application`, create a file in `lib/your_module/application.ex` with the contentes above, and update your `mix.exs` with the following:_

```elixir
...
  def application do
    [
      mod: {YourModule.Application, []},
      extra_applications: [:logger]
    ]
  end
...
```

Dont' forget to replace `your_module` and `YourModule` accordingly.

Initialize snowpack and create a folder to store your frontend code:

```
cd assets
npx snowpack init
mkdir src
```

Update `assets/snowpack.config.js` to mount `assets/src`:

```
module.exports = {
  mount: {
    src: "/",
  }
};
```

Put some Javascript in `assets/src`. For instance, in `assets/src/index.js`:

```
console.log("Hello World!");
```

The last step is to import the JavaScript file from a Still template, for
instance, in you `_layout.slime`:

```
html
  head
    = import_js_file("index.js")
  body
    = @children
```

Besides the `import_js_file`, there's also an `import_css_file`.

And it's finished.

[still]: https://stillstatic.io/
[snowpack]: https://www.snowpack.dev/
