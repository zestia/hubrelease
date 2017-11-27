# hubrelease

**DEPRECATED**: hubrelease has been deprecated in favour of
[releasekit][releasekit]. Which is a functional rewrite using Go over Ruby.

Generate release notes from closed issues and merged pull requests. Then create
a new release, or update an existing release on GitHub.

[releasekit]: https://github.com/tombell/releasekit

## Installation

Install the gem:

    [sudo] gem install hubrelease

## Usage

### Arguments

**Required:**

- `--token` your GitHub API token, which you can generate in [your settings page on GitHub](https://github.com/settings/applications)
- `--repo` the repo in the format `username/project`

**Release Type:**

- `--init` create the first release for the repo
- `--prev` the previous release tag name (must exist on GitHub)
- `--new` the new release tag name (must exist on GitHub)
- `--master` use `master` as the ref for the next release, use instead of `--new`

**Optional:**

- `--prerelease` mark the release as pre-release on GitHub
- `--attach` a path to the asset to attach to the release
- `--labels` a comma separated list (`--labels wontfix,question,enhancement`) to add to items
- `--reverts` include revert commits in the release notes
- `--watch` a file path to watch for changes in commits
- `--output` print the release notes instead of creating a release on GitHub

### Release Types

You can do any of the following:

- Generate your very first release
- Generate a new release from a previous tag, and new tag
- Generate release notes from a previous tag, to a branch or master

Closed issues and pull requests are included in the release notes.

- Issues closed by a pull request are **excluded**
- Issues closed by a commit, but not a pull request are **included**
- All other issues are **excluded**
- Pull requests

### Generating an Initial Release

This will generate the very first release for a repository, you skip the
`--prev` option and specify `--init` instead:

    hubrelease --repo zestia/hubrelease --token $GITHUB_API_TOKEN --init --new v0.0.1

### Generating a New Release

This will generate a new release after the first:

    hubrelease --repo zestia/hubrelease --prev v0.1.0 --new v0.2.0 --token $GITHUB_API_TOKEN

This will either create a new release or update an existing release.

### Generating Release Notes for Master

This will generate a new release notes between the given tag ref and `master`:

    hubrelease --repo zestia/hubrelease --token $GITHUB_API_TOKEN --prev v0.1.0 --master

This will always output the release notes, and never create/update releases on
GitHub.

### Generating Release Notes for a Branch

This will generate a new release notes between the given tag ref and the branch:

    hubrelease --repo zestia/hubrelease --token $GITHUB_API_TOKEN --prev v0.1.0 --branch my-feature

This will always output the release notes, and never create/update releases on
GitHub.

### Labels

If you specify any number of labels, the issues/commits marked with those labels
will include them in the release notes.

### Attachments

If you specify any number of attachments, they will be uploaded and included in
the release.

### Reverts

If you specify to include reverts, this will include any commits starting with
"Revert" in the release notes.

### Watched Files

If you specify any number of files to watch, any changes to those files in the
range of the commits will be included at the end of the release. It will list
each commit they changed, with the most recent first

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
