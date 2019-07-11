defmodule WordAssocClient do
  use HTTPoison.Base

  @base_url "https://api.wordassociations.net/associations/v1.0/json/search"
  @api_key  "cbbdc56d-e124-42ee-823f-178d670034f2"

  # https://api.wordassociations.net/associations/v1.0/json/search/?apikey=dce8149a-9262-464d-89fe-1a8fa1f446e1&text=cat&lang=en

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
