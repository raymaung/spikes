defmodule Rumbl.Auth do
  import Plug.Conn

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do

    # get :user_id stored in session
    user_id = get_session(conn, :user_id)

    # get the user from DB
    user = user_id && repo.get(Rumbl.User, user_id)

    # Adding :current_user to conn.assigns
    assign(conn, :current_user, user)
  end
end
