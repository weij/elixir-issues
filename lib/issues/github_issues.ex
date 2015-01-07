defmodule Issues.GithubIssues do
  
  @user_agent [ {"User-agent", "Elixir weijun@localgravity.com"}]
  @github_url Application.get_env(:issues, :github_url)

  def fetch(user, project) do
    issue_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  def issue_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end

  def handle_response(response) do
    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        { :ok, :jsx.decode(body) }
      {_, %HTTPoison.Response{status_code: _, body: body}} ->
        { :error, body }
    end
  end
end