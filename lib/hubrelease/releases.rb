module HubRelease
  module Releases
    def self.output(issues, reverts, labels, watched)
      puts generate_body(issues, reverts, labels, watched)
    end

    def self.create_or_update(tag, issues, reverts, labels, attachments, prerelease, draft, watched)
      releases = HubRelease.client.list_releases(HubRelease.repo)
      release = releases.find { |r| r.name == tag }

      raise Octokit::NotFound if release.nil?

      update(release, tag, generate_body(issues, reverts, labels, watched), attachments, prerelease, draft)
    rescue Octokit::NotFound
      create(tag, generate_body(issues, reverts, labels, watched), attachments, prerelease, draft)
    end

    def self.generate_body(issues, reverts, labels, watched)
      return "New Release" if issues.empty? and reverts.empty? and watched.empty?

      body = "## Changes\n"

      body += issues.map do |i|
        str = "* [##{i.number}](#{i.html_url}) - #{i.title}"
        str += " (@#{i.user.login})" if i.pull_request

        unless labels.empty?
          labels_to_inc = i.labels.map do |l|
            if labels.include?(l.name)
              "_#{l.name}_"
            end
          end.compact

          str += " (#{labels_to_inc.join(", ")})" if labels_to_inc.size > 0
        end

        str
      end.join("\n")

      body += "\n\n" if reverts.size > 0
      body += reverts.map do |r|
        "* #{r.split("\n")[0]}"
      end.join("\n")

      body += "\n\n## Watched File Changes\n" if watched[:files].size > 0
      body += "\nChanges: #{watched[:url]}\n" if watched[:files].size > 0
      body += watched[:files].map do |file|
        "* #{file}"
      end.join("\n")

      body
    end

    def self.create(tag, body, attachments, prerelease, draft)
      puts "Creating release #{tag}..."

      release = HubRelease.client.create_release(HubRelease.repo, tag, {
        name: tag,
        tag_name: tag,
        body: body,
        prerelease: prerelease,
        draft: draft,
      })

      puts release.html_url

      upload_attachments(release, attachments)
    end

    def self.update(release, tag, body, attachments, prerelease, draft)
      puts "Updating release #{tag}..."

       HubRelease.client.update_release(release.url, {
        name: tag,
        tag_name: tag,
        body: body,
        prerelease: prerelease,
        draft: draft,
      })

      puts release.html_url

      upload_attachments(release, attachments)
    end

    def self.upload_attachments(release, attachments)
      if attachments.size > 0
        attachments.each do |a|
          begin
            HubRelease.client.upload_asset(release.url, a)
          rescue Octokit::MissingContentType
            HubRelease.client.upload_asset(release.url, a, :content_type => "application/octet-stream")
          end
        end
      end
    end
  end
end
