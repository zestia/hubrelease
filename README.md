# hubrelease

Generate a new release on GitHub containing closed issues and pull requests.

## Installation

Simple install the gem:

    [sudo] gem install hubrelease

## Usage

**Note** currently `hubrelease` requires a previous tag to have been pushed to
determine how to find the closed issues and pull requests.

**Arguments:**

  * `--repo` the repo in the format `username/project`
  * `--prev` the previous release tag name (must exist on GitHub)
  * `--new` the new release tag name (must exist on GitHub)
  * `--token` your GitHub API token, which you can generate in [your settings page on GitHub](https://github.com/settings/applications).

Once you have the required arguments, you can simply run:

    hubrelease --repo zestia/hubrelease --prev v0.1.0 --new v0.2.0 --token $GITHUB_API_TOKEN

This will either create a new release or update an existing release. The release
will include a list of closed issues and pull requests.

The included issues and pull requests are based on certain criterea:

  * Issues closed by a pull request are **excluded**
  * Issues closed by a commit, but not a pull request are **included**
  * All other issues are **excluded**
  * Pull requests

## Contribute

Here's the most direct way to get your work merged into the project:

  * Fork the project
  * Clone down your fork
  * Create a feature branch
  * Hack away
  * If necessary, rebase your commits into logical chunks, without errors
  * Push the branch up
  * Send a pull request for your branch

## License

See `LICENSE` for more details.
