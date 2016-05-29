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
