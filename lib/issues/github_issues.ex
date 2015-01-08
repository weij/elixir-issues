defmodule Issues.GithubIssues do
  
  require Logger

  @user_agent Application.get_env(:issues, :user_agent)
  @github_url Application.get_env(:issues, :github_url)

  def fetch(user, project) do
    Logger.info "Fetching user #{user}'s project #{project}"

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
        Logger.info "Successful response"
        { :ok, :jsx.decode(body) }
      {_, %HTTPoison.Response{status_code: status, body: body}} ->
        Logger.error "Error #{status} returned"
        { :error, body }
    end
  end
end