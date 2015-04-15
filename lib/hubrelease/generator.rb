module HubRelease
  module Generator
    class << self
      def generate(options)
        HubRelease.client = Octokit::Client.new access_token: options[:token]
        HubRelease.repo = options[:repo]

        @output = options[:output]
        @base_tag = options[:prev]
        @head_tag = options[:new]

        if options[:init]
          generate_first
        else
          generate_new
        end
      end

      def generate_first
        current = before_date(@head_tag)

        issues = HubRelease::Issues.fetch
        issues = filter_issues(issues, current)

        if @output
          HubRelease::Releases.output(issues)
        else
          HubRelease::Releases.create_or_update(@head_tag, issues)
        end
      end

      def generate_new
        since = since_date(@base_tag)
        current = before_date(@head_tag)

        issues = HubRelease::Issues.fetch(since)
        issues = filter_issues(issues, current)

        if @output
          HubRelease::Releases.output(issues)
        else
          HubRelease::Releases.create_or_update(@head_tag, issues)
        end
      end

      def since_date(tag)
        base_ref = fetch_tag_ref(tag)
        base_ref.tagger ? base_ref.tagger.date : base_ref.author.date
      end

      def before_date(tag)
        head_ref = fetch_tag_ref(tag)
        head_ref.tagger ? head_ref.tagger.date : head_ref.author.date
      end

      def fetch_tag_ref(tag)
        ref = HubRelease.client.ref(HubRelease.repo, "tags/#{tag}")
        HubRelease.client.get(ref.object.url)
      rescue Octokit::NotFound
        abort "Could not fetch tag reference #{tag}"
      end

      def filter_issues(issues, current)
        issues = HubRelease::Issues.filter_closed_after(issues, current)
        issues = HubRelease::Issues.filter_closed_by_pull_request(issues)
        issues = HubRelease::Issues.filter_non_merged_pull_requests(issues)
        issues = HubRelease::Issues.filter_non_commit_closed(issues, @base_tag || "master", @head_tag)
        issues = HubRelease::Issues.filter_merged_pull_requests_after_tag(issues, @base_tag || "master", @head_tag)
      end
    end
  end
end
