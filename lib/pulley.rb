require 'ostruct'

require 'octokit'

module Pulley
  class Credentials
    # Find credentials in current repo or global config
    def self.load
      load_from_repo || load_from_local_config || load_from_user_config || {}
    end

    private

    def self.load_from_repo
      user = `git config github.username`.strip
      password = `git config github.password`.strip
      repo = `git config github.repository`.strip
      if !user.empty? and !password.empty? and !repo.empty?
        {username: user, password: password, repository: repo}
      end
    end

    def self.load_from_local_config
      read_from_file('config/pulley.yml')
    end

    def self.load_from_user_config
      read_from_file(File.expand_path('~/.pulley.yml'))
    end

    def self.read_from_file filename
      if File.exist?(filename)
        YAML.load(File.read(filename))
      end
    end
  end

  class Github
    def initialize username, password, repo
      @repo = repo
      @connection = Octokit::Client.new(login: username, password: password,
                                        auto_traversal: true)
    end

    def pull_requests
      @connection.pull_requests(@repo)
    end

    def update_pull_request number, title, body
      @connection.update_pull_request(@repo, number, title, body)
    end
  end

  class CLI
    def self.display_pull_requests reqs
      decorated_reqs = reqs.map{|r| decorate_pull_request(r) }
      puts decorated_reqs.to_json
    end

    private

    def self.decorate_pull_request req
      relevant_fields(req)
    end

    def self.relevant_fields req
      {number: req[:number],
       title: req[:title],
       body: req[:body],
       branch: req[:head][:label].split(':').last,
       author: req[:head][:user] ? req[:head][:user][:login] : nil,
       user: req[:user][:login]}
    end
  end

  class Publisher
    def initialize client
      @client = client
    end

    def publish_updates reqs
      reqs.each do |req|
        next unless req['modified']
        @client.update_pull_request(req['number'], req['title'], req['body'])
      end
    end
  end

end
