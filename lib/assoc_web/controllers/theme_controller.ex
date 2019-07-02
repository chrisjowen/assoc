defmodule AssocWeb.ThemeController do
  use AssocWeb, :controller

  def add(conn, %{"theme" => theme}) do
    with response <- WordAssocClient.search(theme) do
      json(conn, Themes.add(theme, response.body["response"]))
    end
  end

  def index(conn, _params) do
    json(conn, Themes.get())
  end

  def delete(conn, %{"theme" => theme}) do
    with response <- Themes.remove(theme) do
      json(conn, :ok)
    end
  end

end
