# Rumbl

To start your Phoenix app:

  1. Install dependencies with `mix deps.get`
  2. Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  3. Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).


# Start in IEX mode

* `iex -S mix phoenix.server`
  * Make sure `phoenix.server` is not running to avoid port conflict

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: http://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

# Notes

## Chapter 1 - Introducing Phoenix

### Scaling by Forgetting
* Solve scalability problem by treating each tiny piece of a user interaction as an identical request
    * Application doesn't save the state, simply looks up the user and the context of the conversation of user session
    * Cost: Developer must keep track of the state of each request

### Processes and Channels
* Elixir uses *lightweight* processes; not operating system process
    * Can create hundreds of thousands of processes without breaking a sweat
    * Lightweight means connections can be conversations
      * aka *channels*

#### Channels
* Different frameworks are beginnign to support channels
* But only Elixir gurantees isolation and concurrency
    * *Isolation* guarantees that if a bug affects one channel, all other channels continue running
    * *Concurrency* means one channel can never block another one
    * This key advantage means that the UI never becomes unresponsive because the user started a heavy action

## Chapter 2

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

## Chapter 3 - Controllers, Views, and Templates

* **view** is a module con- taining rendering functions that convert data into a format the end user will consume, like HTML or JSON
    * modules responsible for rendering

* **template** is a function on that module, compiled from a file con- taining a raw markup language and embedded Elixir code to process substi- tutions and loops
    * web pages or fragments that allow both static markup and native code to build response pages


### Using Helpers

* `link` Function
    * `$ iex -S mix`
    * `> Phoenix.HTML.Link.link("Home", to: "/")`
* `use Rumbl.Web, :view` at the beginning of each view file
    * `:view` is a method in `web.ex`
    * `web.ex` is **not** a place to attach own functions
        * keep it skinny and easy to understand
        * use `import` to define own functions

### Showing Users

* Requestion `/users/:id` for example
    * router add `:id` part from URL to `conn`, and `:show` as action name
    * Plug breaks out `params` part of the `conn` for action

### Naming Conventions

* View module, ie `UserView` is inferred from its controller name, ie. `UserController`
* Template folder name ie. `templates/user` is inferred from the view name
* Phoenix uses **Singular** name to avoid pluralization rules

### Nesting Templates

* `<%= render "user.html", user: @user %>` in the template to use partial view
* Rendering view in *iex*
    * `view = Rumbl.UserView.render("user.html", user: user)` 
    * `Phoenix.HTML.safe_to_string(view)`

* `Phoenix.View.render(Rumbl.UserView, "user.html", user: user)`
    * to render in one line
* `Phoenix.View.render_to_string(Rumbl.UserView, "user.html", user: user)`

### Layouts

* layouts are regular views with templates
* Each template receives `@view_module` and `@view_template`
    * see inside `app.html.eex`
* `render` in controller has `:layout` option
    * if not specified it uses default value

## Chapter 4 - Ecto and Changesets

### Understanding Ecto

* a wrapper that’s primarily intended for **relational databases**
* *changesets* to holds all changes to perform on the database


#### Ecto Setup

* Ecto is an Elixir library just like any other.
* Configure in `config/dev.exs`:
* In `rumbl/repo.ex`, enable `use Ecto.Repo, otp_app: :rumbl` 
* In `rumbl/lib/rumbl.ex`, enable `supervisor(Rumbl.Repo, []),`
* `$ mix ecto.create`
    * create underlying database

#### Defining the User Schema and Migration

* Define schema in `web/models/user.ex` using its own DSL
* `$ mix ecto.gen.migration create_user` to gernate migration script
* `$ mix ecto.migrate` to run migration scripts


#### What is a Model in Phoenix?

> **model** is the layer of functions that supports our business rules rather than the data that flows through those functions.
* If controller is to transform *request* to *response* according to communication protocol then model is transform *data* according to business requirement
* *schema* the native form of data
* *struct* is the data
* *struct* is **NOT** *model*

#### Building Forms
>```ruby
def changeset(model, params \\ :empty) do
  model    |> cast(params, ~w(name username), [])    |> validate_length(:username, min: 1, max: 20)
end
```

* `name` and `username` are required
* `[]` no optional field
* `cast` rejects everything else and returns `Ecto.Changeset`
* 

## Chapter 5 - Authenticating Users

### Preparing for Authentication

* Use `comeonin`
* Application is a collection of modules

```ruby
def registration_changeset(model, params) do
  model    |> changeset(params)    |> cast(params, ~w(password), [])    |> validate_length(:password, min: 6, max: 100)
    |> put_pass_hash()end

defp put_pass_hash(changeset) do
  case changeset do    %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
      put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))    _ ->      changeset  end
end
```
* Pass through normal `changeset`
* Verify `password` field exists
* Validate password length
* Add `password_hash` of `changeset`

### The Antomy of a Plug

* two kinds of plugs
    * module plugs
    * function plugs
    * Both request intrface is the same `conn`
    * All plugs take `conn` and return `conn`
        *   `conn` = `connection` = `Plug.Conn`

#### Module Plugs

```ruby
defmodule NothingPlug do
  def init(opts) do    opts  end  def call(conn, _opts) do
    conn  end
end
```

* provide *two* functions with some configurations
    * `init`
        * heavy lifting to transform options
        * happen at compile time
        * Plug uses the result of `init` as second argument to call
    * `call`
        * work horse
        * want it to do as little work as possible
* specify module plug by providing module name
    * `plug Plug.Logger`

#### Function plugs

* single function
* specify by the name of function as an atom
    * `plug :protect_from_forgery`

#### `Plug.Conn` Fields

* `host`: host name ie `www.pragprop.com`
* `method`: request method ie `GET`
* `path_info`: Path, List of Segments, ie. `["admin", "users"]`
* `req_headers`: Request headers; ie. `[{"content-type", "text/plain"}]`
* `scheme`: Request protocol as an atom, ie `:https`
* Many more such as *query strings*, *remote address*, *port* and etc.
* `cookies`: Request cookies
* `params`: Request parameters
* `assigns`: User defined map containing anything you want
* `halted`: *Halted* Flag, ie. due to *failed authorization*
* `state`: Connection state, ie. `:set`, `:sent`
* `resp_body`: Initially empty string, will contain HTTP response
* `resp_cookies`: Outbound cookies
* `resp_headers`: headers following HTTP Specifications
* `status`: response code ie `200`, `300`
* Private fields reserved for adapter and frameworks
    * `adapter`: Adapter information
    * `private`: the private use of frameworks

Initially, `conn` is mostly empty and filled out progressively by different plugs in the piepline. 

#### Writing an Authentication Plug

```ruby
authentication/listings/rumbl/web/controllers/auth.exdefmodule Rumbl.Auth do
  import Plug.Conn  def init(opts) do
    Keyword.fetch!(opts, :repo)  end  def call(conn, repo) do    user_id = get_session(conn, :user_id)    user = user_id && repo.get(Rumbl.User, user_id)
    assign(conn, :current_user, user)  end
end
```

#### Writing an Authentication Plug

* Create Plug in `web/controllers/...`
* Add the plug in `ewb/route.ex`

#### Restricting Access

#### Plug Macro TLDR

```ruby
plug :oneplug Twoplug :three, some: :option
```
will expand to

```ruby

case one(conn, []) do  %{halted: true} = conn -> conn
  conn ->    case Two.call(conn, Two.init([])) do 
      %{halted: true} = conn -> conn
      conn ->        case three(conn, some: :option) do
          %{halted: true} = conn -> conn
          conn -> conn        end
    endend

```

#### Presenting User Account Links

* Every thing in `conn.assigns` is available in *view*
    * ie `@current_user` in View is coming from `conn.assigns.current_user`

    
#### Wrapping Up

* Add `comeonin` dependency
* Built authentication layer
* Built the associated changesets to handle validation of passwords
* Implemented a module plug to load user from session and made it part of the browser pipeline
* Implemented a function plug