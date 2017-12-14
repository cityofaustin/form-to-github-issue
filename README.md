# Form-to-Github Microservice

Receives requests from the [Form Dispatcher](https://github.com/cityofaustin/form-dispatcher) and creates a GitHub issue via the GitHub API.

## Params

| Parameter     | Description                              |
| ------------- | ---------------------------------------- |
| `repository`  | The name of a repository you want to create an issue for<br />(The repository  must be under the City of Austin organization and the relevant _machine user_ must be added as a collaborator on that repository.) |
| `title`       | The title of the GitHub issue.           |
| `description` | The user-submitted description           |
| `meta`        | Metadata collected on the client-side such as browser, OS, and device<br />(Optional) |

## Response

The app will return one of two JSON responses to the Form Dispatcher, which will then be returned to the browser. Failures and responses will each have a `status` ("success" or "error"), `title`, and `body` value. Successful responses will also include a `url` parameter which will contain the URL for the newly-created issue.

## Metadata collection

The original feature spec stipulated that browser/os/device data should be included in the form submission. This is handled via the `meta` parameter, the value of which is appended to the bottom of the GitHub issue body.

## GitHub Integration

The API uses a [_machine user_](https://developer.github.com/v3/guides/managing-deploy-keys/#machine-users) to authenticate API requests. The first implementation uses the [coa-feedback-bot](https://github.com/coa-feedback-bot) account.

To authenticate a new machine user:

1. Create a new account on Github (this is your machine user)
2. Create an Access Token (this will be how you make API requests as the machine user)
3. Add the machine user as a collaborator on the repo(s) you want to create issues for with that machine user
4. Add a new array in the `token_for` method in `submissions_controller.rb`  to indicate which repositories use the machine user for authentication, and add that array to the lookups that tie the supplied `repository` parameter to a corresponding machine user.

## Quickstart

### Environment Variables

Store your desired _machine user_ access token(s) as environment variables, and add them to the relevant array(s) in the `token_for(repository)` method in `submissions_controller.rb`.

Used in conjunction with the Form Dispatcher, the application runs locally on port 3003.

```
$ bundle install
$ rails s -p 3003
```

## Environments

### Production

URL: [https://coa-test-form-github-issue.heroku.com/](https://coa-test-form-github-issue.heroku.com/)

### Local

URL: https://localhost:3003/
