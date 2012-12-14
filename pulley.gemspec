Gem::Specification.new do |s|
  s.name = 'pulley'
  s.version = '0.0.4'
  s.date = '2012-12-11'

  s.summary = 'A CLI tool for working with Github Pull Requests'
  s.description = 'Pulley will turn pull requests into a json stream on STDOUT for piping through other programs, it can be piped back in with the --publish flag to persist changes to github.'

  s.authors = ['Todd Willey (xtoddx)']
  s.email = 'xtoddx@gmail.com'
  s.homepage = 'http://github.com/xtoddx/pulley'

  s.require_paths = %w[lib]
  s.executables = %w[pulley]

  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w[README.md]

  s.add_dependency('octokit', '~> 1.19.0')

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {spec,tests}/*`.split("\n")
end
