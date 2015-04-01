require "octokit"

module HubRelease
  class Generator
    CLOSE_REGEX = /(((close|resolve)(s|d)?)|fix(e(s|d))?) #(\d+)/i

    def initialize(options)
      @client = Octokit::Client.new access_token: options[:token]
      @repo = options[:repo]
      @base_tag = options[:prev]
      @head_tag = options[:new]
    end

    def generate
      base_ref = fetch_base_tag
      head_ref = fetch_head_tag

      issues = fetch_issues(base_ref.tagger.date, head_ref.tagger.date)

      issues = exclude_closed_by_pull_request(issues)
      issues = exclude_non_merged_pull_requests(issues)
      issues = include_closed_by_commit(issues)

      body = generate_release_body(issues)

      create_or_update_release(body)
    end

    def fetch_base_tag
      base = @client.ref @repo, "tags/#{@base_tag}"
      @client.get base.object.url
    rescue Octokit::NotFound
      abort "Could not find base tag #{@base_tag} - make sure the tag has been pushed"
    end

    def fetch_head_tag
      head = @client.ref @repo, "tags/#{@head_tag}"
      @client.get head.object.url
    rescue Octokit::NotFound
      abort "Could not find head tag #{@head_tag} - make sure the tag has been pushed"
    end

    def fetch_issues(since, before)
      issues = @client.issues @repo, { state: "closed", since: since.iso8601 }
      issues = issues.select { |i| i.closed_at <= before }
    end

    def exclude_closed_by_pull_request(issues)
      exclude_ids = issues.map do |issue|
        if issue.pull_request
          if match = CLOSE_REGEX.match(issue.body)
            match[7].to_i
          end
        end
      end.compact.uniq

      issues.select do |issue|
        !exclude_ids.include?(issue.number)
      end
    end

    def exclude_non_merged_pull_requests(issues)
      exclude_ids = issues.map do |issue|
        if issue.pull_request
          pr = @client.get issue.pull_request.url

          unless pr.merged_at
            issue.number
          end
        end
      end.compact.uniq

      issues.select do |issue|
        !exclude_ids.include?(issue.number)
      end
    end

    def include_closed_by_commit(issues)
      compare = @client.compare @repo, @base_tag, @head_tag

      include_ids = compare.commits.map do |commit|
        if match = CLOSE_REGEX.match(commit.commit.message)
          match[7].to_i
        end
      end.compact.uniq

      issues.select do |issue|
        include_ids.include?(issue.number) || issue.pull_request
      end
    end

    def generate_release_body(issues)
      issues.map do |issue|
        "[#{issue.number}](#{issue.html_url}) - #{issue.title}"
      end.join("\n")
    end

    def create_or_update_release(body)
      release = @client.release_for_tag @repo, @head_tag
      raise Octokit::NotFound if release.id.nil?

      puts "Updating release #{@head_tag}..."

      @client.update_release release.url, name: @head_tag, body: body
      puts release.html_url
    rescue Octokit::NotFound
      puts "Creating release #{@head_tag}..."

      release = @client.create_release @repo, @head_tag, name: @head_tag, body: body
      puts release.html_url
    end
  end
end
