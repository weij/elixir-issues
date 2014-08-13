defmodule Issues.GithubIssues do
  
  @user_agent [ {"User-agent", "Elixir weijun@localgravity.com"}]
  
  def fetch(user, project) do
    issue_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  def issue_url(user, project) do
    "https://api.github.com/repos/#{user}/#{project}/issues"
  end

  def handle_response( %{status_code: 200, body: body} ) do
    { :ok, :jsx.decode(body) }
  end
  
  def handle_response( %{status_code: _, body: body} ), do: { :error, body }  
  
end