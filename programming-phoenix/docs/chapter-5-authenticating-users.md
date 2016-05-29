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
