## Chapter 2 The Lay of the Land

* Elixir package manager
    * `mix local.hex` 
* Installing Phoenix from Archive
    * `mix archive.install https://github.com/phoenixframework/archives/raw//master/phoenix_new.ez`

### Creating a Throwaway Project

* create a new phoenix project
    * `mix phoenix.new hello`
    * `cd hello`
    * `mix ecto.create`
    * `mix phoenix.server`
* start phoenix in Interactive Shell
    * `iex -S mix phoenix.server`

### Mapping Request URL to Response
```ruby
scope "/", Hello do
    pipe_through :browser    get "/", PageController, :index
end
```

* `web/router.ex` defines routes
* Pattern match the scope, ie. `scope "/", Hello do ...`
* `pipe_through :browser` macro to handles some house keeping for all common browser-style requests.
* `get "/", PageController, :index` to controlelr to the controller and action 

#### `/controllers/hello_controller.ex`
```ruby
defmodule Hello.HelloController do
    use Hello.Web, :controller    def world(conn, _params) do
        render conn, "world.html"    end
end
```

* Elixir adding specific functionality to a module
    * `use Hello.Web, :controller` add Phoenix Controller API

#### `hello/web/views/hello_view.ex`

```ruby
defmodule Hello.HelloView do
    use Hello.Web, :viewend
```

#### `web/templates/hello/world.html.eex`
```
<h1>From template: Hello world!</h1>
```
* `eex` extension denotes a template
* layout view defined at `web/views/layout_view.ex`
* layout template defined at `web/templates/layout/app.html.eex`

### Going Deeper: The Request Pipeline

* Typical web applications are just big functions
    * Each web request is a functional call taking URL as argument and response a formatted string
* Phoenix encourages breaking big functions down into smaller ones and place to explicitly register each smaller functions
    * All these functions together with the plug library

* Plug Library
    * a specification for building applications that connect to the web
    * `Plub.Conn` a common data structure consumed and produced by each plug
    * `conn` --> `Plug` --> `conn`
    
### Phoenix File Structure

* `config`
    * Phoenix Configurations
    * `config.exs`
        * master application wide configuration file
        * contains a single end point `YourFooApp.EndPoint`
            * Point to `lib/hello/endpoint.ex`
    * `dev.exs`, `prod.exs` and `test.exs`
        * environment specific configuration file
    * `prod.secret.exs`
        * Keep out of version control
        * For secrets production passwords
        * To be populated by deployment tasks  
    * `MIX_ENV` is environment variable to swich environment
    *  
* `lib`
    *  Supervision trees and long running processes
    *  *PubSub* , *Database Connection pool* and etc
    *  `lib/hello/endpoint.ex`
        *  Define a end point - can have multiple end points
        *  Define a series of `Plug` which transform into a series of piped functions
        *  the last Plug is `YourFooProject.Router`
            *  giving the control over to the router
* `test`
    * tests
* `web`
    * web-related - models, views, templates and controllers
    * when *code reloading* is turned on, `web` is reloaded
    * `router.ex`
        * Two parts - *pipe lines* and *route table*
        * Pipe Line
            * a pipe line is a bigger plug
        * Route Table
            * `scope` then `pipe_through :browser` then to the router
            * router triggers the controller

#### `mix.exs`

* Project configuration file - like `GemFile`
* Basic information and dependencies
* `mix.lock` includes specific libraries versions
* Each mix has `lib` and `lib/foo-hello.ex` for starting and stopping and supervising


### Controllers, Views and Templates

* Controllers
    * Gateway for the bulk of a traditional web application
* Two top level files `router.ex` and `web.ex` 
* `web.ex`
    * contains some glue code that define the over all application structure

```ruby
connection                # Plug.Conn |> endpoint              # lib/hello/endpoint.ex |> browser               # web/router.ex |> HelloController.world # web/controllers/hello_controller.ex
 |> HelloView.render(     # web/views/hello_view.ex        "world.html")     # web/templates/hello/world.html.eex
```
