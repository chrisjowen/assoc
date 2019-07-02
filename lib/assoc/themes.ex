defmodule Themes do
    use Agent

    def start_link(_) do
      Agent.start_link(fn -> %{} end, name: __MODULE__)
    end

    def add(theme, [response|_]) do
      related = response["items"]
                |> Enum.map( fn i -> i["item"] end)

      Agent.get_and_update(__MODULE__, fn themes ->
        state = Map.put(themes, theme, related)
        {Map.get(state, theme), state}
      end)
    end

    def get() do
      Agent.get(__MODULE__, fn themes -> themes end)
    end

    def remove(theme) do
      Agent.update(__MODULE__, fn themes ->
        Map.delete(themes, theme)
      end)
    end
  end
