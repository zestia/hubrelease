module HubRelease
  module Releases
    def self.output(issues, reverts, labels)
      puts generate_body(issues, reverts, labels)
    end

    def self.create_or_update(tag, issues, reverts, labels, attachments, prerelease)
      release = HubRelease.client.release_for_tag(HubRelease.repo, tag)
      raise Octokit::NotFound if release.id.nil?
      update(release, tag, generate_body(issues, reverts, labels), attachments, prerelease)
    rescue Octokit::NotFound
      create(tag, generate_body(issues, reverts, labels), attachments, prerelease)
    end

    def self.generate_body(issues, reverts, labels)
      return "New Release" if issues.empty? and reverts.empty?

      body = issues.map do |i|
        str = "* [##{i.number}](#{i.html_url}) - #{i.title}"

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

      body += "\n" if reverts.size > 0
      body += reverts.map do |r|
        "* #{r.split("\n")[0]}"
      end.join("\n")

      body
    end

    def self.create(tag, body, attachments, prerelease)
      puts "Creating release #{tag}..."
      release = HubRelease.client.create_release(HubRelease.repo, tag, {
        name: tag,
        body: body,
        prerelease: prerelease,
      })
      puts release.html_url

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

    def self.update(release, tag, body, attachments, prerelease)
      puts "Updating release #{tag}..."
       HubRelease.client.update_release(release.url, {
        name: tag,
        body: body,
        prerelease: prerelease,
      })
      puts release.html_url

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
