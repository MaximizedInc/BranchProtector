# BranchProtector
### So like what is this?

Wanna make sure your new repos have their default branches protected by default? 
Wanna also get a notification when this happens? 

Well, you're in luck. Check out this bad boi right here.

### This project uses:
 
* Github's [delete repository event code](https://github.com/github/platform-samples/tree/master/hooks/ruby/delete-repository-event)
* [Ruby](https://www.ruby-lang.org/en/)
* [Octokit](https://github.com/octokit/octokit.rb)
* [Sinatra](http://sinatrarb.com/)

### So uh, how does a gal like me get this puppy up and runnin'?

1. Be a member of a GitHub Organization.
2. Make sure you have a [Personal Access Token.](https://docs.github.com/en/enterprise-server@3.5/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) that grants repo read/write
3. [Set up your server](https://docs.github.com/en/developers/webhooks-and-events/webhooks/configuring-your-server-to-receive-payloads)
4. [Create a webhook that listens to repostory events and points at your server.](https://docs.github.com/en/developers/webhooks-and-events/webhooks/creating-webhooks)
5. [Create a webhook that listens to branch protection events and points at your server.](https://docs.github.com/en/developers/webhooks-and-events/webhooks/creating-webhooks)
6. Install gems - `bundle install`.
7. Configure `server.rb` & environment variables.
* GITHUB_HOST - the domain of the GitHub Enterprise instance. e.g. github.example.com.
* GITHUB_API_TOKEN - a Personal Access Token that has the ability to create an issue in the notification repository.
* GITHUB_NOTIFICATION_REPOSITORY - the repository in which to create the notification issue. e.g. github.example.com/administrative-notifications. Should be in the form of :owner/:repository.
8. Run server.rb
9. Create a new repo in your organization.
10. [Throw a party for the whole office](https://www.youtube.com/watch?v=97rVX0u-pyc)!

### Pssssssst -- this is a demo
The branch protection set in this project isn't a, well... _best practice_. Consider updating the `client.protect_branch` call in the `post '/create-repository-event'` section to fit your needs. You could also switch up the `post '/notify-admin'` messaging to notify people who you actually know! 
