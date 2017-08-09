module HubRelease
  module Commits
    def self.reverted_commits(base, head)
      @compare ||= HubRelease.client.compare(HubRelease.repo, base, head)

      reverts = @compare.commits.map do |c|
        if REVERT_REGEX.match(c.commit.message)
          c.commit.message
        end
      end.compact.uniq

      reverts
    end

    def self.watched_files_commits(base, head, watched)
      @compare ||= HubRelease.client.compare(HubRelease.repo, base, head)

      files = @compare.files.select { |f| watched.include? f.filename }
      files = files.map { |f| f.filename }

      {
        files: files,
        url: @compare.html_url
      }
    end
  end
end
