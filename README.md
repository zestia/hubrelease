# hubrelease

Generate release notes from closed issues and merged pull requests, then create
a new release on GitHub.

## Installation

Install the gem:

    [sudo] gem install hubrelease

## Usage

**Arguments:**

- `--attach` a path to the asset to attach to the release
- `--init` create the first release for the repo
- `--labels` a comma separated list (`--labels wontfix,question,enhancement`) to add to items
- `--master` use `master` as the ref for the next release
- `--new` the new release tag name (must exist on GitHub)
- `--output` print the release notes instead of creating a release on GitHub
- `--prerelease` mark the release as pre-release on GitHub
- `--prev` the previous release tag name (must exist on GitHub)
- `--repo` the repo in the format `username/project`
- `--reverts` include revert commits in the release notes
- `--token` your GitHub API token, which you can generate in [your settings page on GitHub](https://github.com/settings/applications)
- `--watch` a file path to watch for changes in commits

You can either generate your very first release, or create a new release from a
previous tag and the new release.

Closed issues and pull requests are included in the release notes.

- Issues closed by a pull request are **excluded**
- Issues closed by a commit, but not a pull request are **included**
- All other issues are **excluded**
- Pull requests

### Generate First Release

This will generate the very first release for a repository, you skip the
`--prev` option and specify `--init` instead:

    hubrelease --repo zestia/hubrelease --init --new v0.0.1 --token $GITHUB_API_TOKEN

### Generate With Master

This will generate a new release notes between the given tag ref and `master`:

    hubrelease --repo zestia/hubrelease --prev v0.1.0 --master --token $GITHUB_API_TOKEN

This will always output the release note.

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
