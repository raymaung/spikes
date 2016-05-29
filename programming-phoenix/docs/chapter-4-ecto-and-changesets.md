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
