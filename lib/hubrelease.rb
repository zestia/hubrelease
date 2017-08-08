require "octokit"

require "hubrelease/generator"
require "hubrelease/issues"
require "hubrelease/commits"
require "hubrelease/releases"
require "hubrelease/version"

module HubRelease
  class << self
    attr_reader :client, :repo

    def client=(client)
      @client = client
    end

    def repo=(repo)
      @repo = repo
    end
  end
end
