# -*- encoding: utf-8 -*-
# stub: autosize 2.4.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "autosize".freeze
  s.version = "2.4.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Jack Moore".freeze, "Adrian Rangel".freeze]
  s.date = "2017-07-26"
  s.description = "Autosize is a small, stand-alone script to automatically adjust textarea height to fit text.".freeze
  s.email = ["adrian.rangel@gmail.com".freeze]
  s.homepage = "http://www.jacklmoore.com/autosize/".freeze
  s.licenses = ["MIT".freeze]
  s.rubyforge_project = "autosize".freeze
  s.rubygems_version = "2.6.11".freeze
  s.summary = "This gem allows you to use Autosize plugin".freeze

  s.installed_by_version = "2.6.11" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
    else
      s.add_dependency(%q<rake>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>.freeze, [">= 0"])
  end
end
