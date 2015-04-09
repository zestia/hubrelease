module HubRelease
  module Releases
    def self.output(issues)
      puts generate_body(issues)
    end

    def self.create_or_update(tag, issues)
      release = HubRelease.client.release_for_tag(HubRelease.repo, tag)
      raise Octokit::NotFound if release.id.nil?
      update(release, tag, generate_body(issues))
    rescue Octokit::NotFound
      create(tag, generate_body(issues))
    end

    def self.generate_body(issues)
      return "New Release" if issues.empty?

      issues.map do |i|
        "[##{i.number}](#{i.html_url}) - #{i.title}"
      end.join("\n")
    end

    def self.create(tag, body)
      puts "Creating release #{tag}..."
      release = HubRelease.client.create_release(HubRelease.repo, tag, {
        name: tag,
        body: body,
      })
      puts release.html_url
    end

    def self.update(release, tag, body)
      puts "Updating release #{tag}..."
       HubRelease.client.update_release(release.url, tag, {
        name: tag,
        body: body,
      })
      puts release.html_url
    end
  end
end
