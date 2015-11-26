# hubrelease

Generate release notes from closed issues and merged pull requests, and create a
new release on GitHub.

![Release Notes Example](docs/screenshot.png)

## Installation

Simple install the gem:

    [sudo] gem install hubrelease

## Usage

**Arguments:**

- `--repo` the repo in the format `username/project`
- `--prev` the previous release tag name (must exist on GitHub)
- `--reverts` include revert commits in the release notes
- `—init` create the first release for the repo
- `--new` the new release tag name (must exist on GitHub)
- `--token` your GitHub API token, which you can generate in [your settings page on GitHub](https://github.com/settings/applications)
- `--labels` a comma separated list (`--labels wontfix,question,enhancement`) to add to items
- `--attach` a path to the asset to attach to the release

You can either generate your very first release, or create a new release from a
previous tag and the new release.

Closed issues and pull requests are included in the release notes.

- Issues closed by a pull request are **excluded**
- Issues closed by a commit, but not a pull request are **included**
- All other issues are **excluded**
- Pull requests

### Generate First Release

This will generate the very first release for a repository, you simply skip the
`--prev` option and specify `--init` instead:

    hubrelease --repo zestia/hubrelease --init --new v0.0.1 --token $GITHUB_API_TOKEN

### Generate New Release

This will generate a new release after the first:

    hubrelease --repo zestia/hubrelease --prev v0.1.0 --new v0.2.0 --token $GITHUB_API_TOKEN

This will either create a new release or update an existing release.

## Contribute

Here's the most direct way to get your work merged into the project:

- Fork the project
- Clone down your fork
- Create a feature branch
- Hack away
- If necessary, rebase your commits into logical chunks, without errors
- Push the branch up
- Send a pull request for your branch

##  License

See `LICENSE` for more details.
