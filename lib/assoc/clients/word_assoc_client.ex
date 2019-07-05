defmodule WordAssocClient do
  use HTTPoison.Base

  @base_url "https://api.wordassociations.net/associations/v1.0/json/search"
  @api_key  "dce8149a-9262-464d-89fe-1a8fa1f446e1"

  def search(q) do
    get!(q)
  end

  def process_request_url(text) do
    "#{@base_url}/?apikey=#{@api_key}&text=#{text}&lang=en"
  end

  def process_response_body(body) do
    try do
      Poison.decode!(body)
    rescue
      _ -> body
    end

  end
end
