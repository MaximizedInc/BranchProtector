# Using the example from https://docs.github.com/en/developers/webhooks-and-events/webhooks/configuring-your-server-to-receive-payloads
# yay now I get to check out octokit, oh gosh I haven't used ruby in soooooo long :P

require 'octokit'
require 'sinatra'
require 'json'

enable :logging
github_api_token               = ENV['GITHUB_API_TOKEN']
github_notification_repository = ENV['GITHUB_CREATE_REPOSITORY']
github_host_fqdn               = ENV['GITHUB_HOST']
github_api_endpoint            = "https://api.github.com/"

Octokit.configure do |c|
  c.api_endpoint = github_api_endpoint
  c.access_token = github_api_token
end

# Needed so that the webhook setup passes
post '/' do
  200
end


# when a new repo is created, update the branch protection on main

post '/create-repository-event' do
  begin
    github_event = request.env['HTTP_X_GITHUB_EVENT']
    if github_event == "repository"
      request.body.rewind
      parsed = JSON.parse(request.body.read)
      action = parsed['action']

      if action == 'created'
      	# protect the new repo
      	full_name = parsed['repository']['full_name']
      	client = Octokit::Client.new
      	client.protect_branch(full_name, 'main', {:required_status_checks => nil,
      											  :enforce_admins => true, 
      											  :required_pull_request_reviews => nil,
      											  :restrictions => nil
      											  })      	

      	return 201,"Repository created and protected: #{full_name}"
      end
    end
    return 418, "Nooooooooope"
  rescue => e
    status 500
    "exception encountered #{e}"
  end
 end


# create an issue in the `github_notification_repository` (MaximizedInc/AdminNotifs) set by environment variable

post '/notify-admin' do 
	begin
		github_event = request.env['HTTP_X_GITHUB_EVENT']
    	if github_event == "branch_protection_rule"
    		request.body.rewind
      		parsed = JSON.parse(request.body.read)
     		action = parsed['action']

     		if action == 'created'
        		# create a new issue in the repository configured above
        		full_name = parsed['repository']['full_name']
        		client = Octokit::Client.new
        		client.create_issue(github_notification_repository, "Repository created: #{full_name}", "@maxaguirre5 please review this at #{github_notification_repository}")

        		return 201,"Max has been alerted about the new repo: #{full_name}"
        	end
        end
        return 418, "Nooooooooope"
  rescue => e
    status 500
    "exception encountered #{e}"
  end
end