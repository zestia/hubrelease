module HubRelease
  module Issues
    CLOSE_REGEX = /(((close|resolve)(s|d)?)|fix(e(s|d))?) #(\d+)/i

    def self.fetch(since = nil)
      params = { state: "closed" }
      params[:since] = since.iso8601 unless since.nil?
      HubRelease.client.issues(HubRelease.repo, params)
    end

    def self.filter_closed_after(issues, date)
      issues.select { |i| i.closed_at <= date }
    end

    def self.filter_closed_by_pull_request(issues)
      ids = issues.map do |i|
        if i.pull_request
          if match = CLOSE_REGEX.match(i.body)
            match[7].to_i
          end
        end
      end.compact.uniq

      issues.select { |i| !ids.include?(i.number) }
    end

    def self.filter_non_merged_pull_requests(issues)
      ids = issues.map do |i|
        if i.pull_request
          pr = HubRelease.client.get(i.pull_request.url)

          unless pr.merged_at
            i.number
          end
        end
      end.compact.uniq

      issues.select { |i| !ids.include?(i.number) }
    end

    def self.filter_non_commit_closed(issues, base, head)
      compare = HubRelease.client.compare(HubRelease.repo, base, head)

      ids = compare.commits.map do |c|
        if match = CLOSE_REGEX.match(c.commit.message)
          match[7].to_i
        end
      end.compact.uniq

      issues.select { |i| ids.include?(i.number) || i.pull_request }
    end
  end
end