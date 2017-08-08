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

      changed = @compare.commits.map do |c|
        commit = HubRelease.client.commit(HubRelease.repo, c.sha)
        require 'pp'
        pp commit
        files = commit.files.select { |f| watched.include? f.filename }

        files = files.map do |f|
          {
            filename: f.filename,
            date: commit.commit.committer.date,
            url: commit.html_url,
          }
        end
      end.flatten

      changed = changed.group_by { |c| c[:filename] }
      changed.each do |k, v|
        changed[k] = changed[k].sort_by { |f| f[:date] }.reverse
      end

      changed
    end
  end
end
