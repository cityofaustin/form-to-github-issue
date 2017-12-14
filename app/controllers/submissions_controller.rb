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
        response_body = "Your feedback has been received. You can stay updated on github at #{issue_url}"
      else
        response_status = "error"
        response_body = "We encountered an error with your submission"
      end

      render json: {
        status: response_status,
        body: response_body,
      }
    rescue
      render json: {
        status: "error",
        body: "Your submission could not be processed.",
      }
    end
  end

  private

    def token_for(repository)
      feedback_bot = ["api-github-issue"]

      if feedback_bot.include?(repository)
        return "#{ENV["GITHUB_FEEDBACK_TOKEN"]}"
      else
        return false
      end
    end

end
