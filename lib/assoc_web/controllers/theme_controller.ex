defmodule AssocWeb.ThemeController do
  use AssocWeb, :controller

  def multi(conn, %{ "file" => file}) do
    content = File.read!(file.path)
    content
      |> String.split(~r{[\r]*\n})
      |> Enum.each(&addTheme/1)
    json(conn, :ok)
  end
  def add(conn, %{"theme" => theme}) do
    with words <- addTheme(theme) do
      json(conn, words)
    end
  end

  defp addTheme(theme) do
    with response <- WordAssocClient.search(theme) do
      Themes.add(theme, response.body["response"])
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

  def clear(conn, _) do
    with response <- Themes.clear() do
      json(conn, :ok)
    end
  end

end
