require 'ostruct'

require 'octokit'

module Pulley
  class Credentials
    # Find credentials in current repo or global config
    def load
      load_from_repo || load_from_local_config || load_from_user_config || {}
    end

    private

    def load_from_repo
      user = `git config github.username`.strip
      password = `git config gitnub.password`.strip
      repo = `git config github.repo`.strip
      if !user.empty? and !password.empty? and !repo.empty?
        {username: user, password: password, repository: repo}
      end
    end

    def load_from_local_config
      read_from_file('config/pulley.yml')
    end

    def load_from_user_config
      read_from_file(File.expand_path('~/.pulley.yml'))
    end

    def read_from_file filename
      if File.exist?(filename)
        YAML.load(File.read(filename))
      end
    end
  end

  class Github
    def connect username, password, repo
      @repo = repo
      @connection = Ocotkit::Client.new(login: username, password: password,
                                        auto_traversal: true)
    end

    def pull_requests
      @connection.pull_requests(@repo)
    end
  end

  class CLI
    def display_all_pull_requests reqs
      decorated_reqs = reqs.map{|r| decorate_pull_request(r) }
      puts decorated_reqs.to_json
    end

    private

    def decorate_pull_request req
      relevant_fields(req)
    end

    def relevant_fields req
      {number: req[:number],
       title: req[:title],
       body: req[:body],
       branch: req[:head][:label],
       author: req[:head][:user][:login],
       user: req[:user][:login]}
    end
  end

end
