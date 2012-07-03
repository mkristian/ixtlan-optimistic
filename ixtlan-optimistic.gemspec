# -*- mode: ruby -*-
Gem::Specification.new do |s|
  s.name = 'ixtlan-optimistic'
  s.version = '0.1.0'

  s.summary = 'optimistic find/get on model via updated_at timestamp for datamapper and activerecord'
  s.description = s.summary
  s.homepage = 'http://github.com/mkristian/ixtlan-optimistic'

  s.authors = ['mkristian']
  s.email = ['m.kristian@web.de']

  s.files = Dir['MIT-LICENSE']
  s.licenses << 'MIT-LICENSE'
#  s.files += Dir['History.txt']
  s.files += Dir['README.md']
  s.rdoc_options = ['--main','README.md']
  s.files += Dir['lib/**/*']
  s.files += Dir['spec/**/*']
  s.test_files += Dir['spec/**/*_spec.rb']
  s.add_development_dependency 'minitest', '3.2.0'
  s.add_development_dependency 'dm-timestamps', '1.2.0'
  s.add_development_dependency 'dm-migrations', '1.2.0'
  s.add_development_dependency 'dm-sqlite-adapter', '1.2.0'
  s.add_development_dependency 'rake', '= 0.9.2.2'
end

# vim: syntax=Ruby
