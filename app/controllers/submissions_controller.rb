class SubmissionsController < ApplicationController

  def inbound
    begin
      submission = JSON.parse(params[:q])
      repo = submission["repository"]
      title = submission["title"]
      description = submission["description"]
      meta = submission["meta"]

      access_token = token_for(repo)
      client = Octokit::Client.new(:access_token => access_token)
      new_issue = client.create_issue("cityofaustin/#{repo}", "#{title}", "#{description} \n #{meta}")  
      status = client.last_response.status

      if status == 201
        issue_url = new_issue.url
        issue_url.slice!("api.")
        issue_url.slice!("repos/")
        response_status = "success"
        response_body = "Your feedback has been received."
      else
        response_status = "error"
        response_body = "We encountered an error with your submission"
      end

      render json: {
        status: response_status,
        body: response_body,
        url: issue_url
      }
    rescue => exception
      render json: {
        status: "error",
        body: exception.message,
      }
    end
  end

  private

    def token_for(repository)
      return "#{ENV["GITHUB_FEEDBACK_TOKEN"]}"
    end

end
