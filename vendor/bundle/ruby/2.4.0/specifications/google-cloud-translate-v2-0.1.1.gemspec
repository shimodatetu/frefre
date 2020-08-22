# -*- encoding: utf-8 -*-
# stub: google-cloud-translate-v2 0.1.1 ruby lib

Gem::Specification.new do |s|
  s.name = "google-cloud-translate-v2".freeze
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Google LLC".freeze]
  s.date = "2020-06-18"
  s.description = "Cloud Translation can dynamically translate text between thousands of language pairs. Translation lets websites and programs programmatically integrate with the translation service.".freeze
  s.email = "googleapis-packages@google.com".freeze
  s.homepage = "https://github.com/googleapis/google-cloud-ruby".freeze
  s.licenses = ["Apache-2.0".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.4".freeze)
  s.rubygems_version = "2.6.11".freeze
  s.summary = "API Client library for Cloud Translation V2 API".freeze

  s.installed_by_version = "2.6.11" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<faraday>.freeze, ["< 2.0", ">= 0.17.3"])
      s.add_runtime_dependency(%q<google-cloud-core>.freeze, ["~> 1.5"])
      s.add_runtime_dependency(%q<googleapis-common-protos>.freeze, ["< 2.0", ">= 1.3.10"])
      s.add_runtime_dependency(%q<googleapis-common-protos-types>.freeze, ["< 2.0", ">= 1.0.5"])
      s.add_runtime_dependency(%q<googleauth>.freeze, ["~> 0.12"])
      s.add_development_dependency(%q<google-style>.freeze, ["~> 1.24.0"])
      s.add_development_dependency(%q<minitest>.freeze, ["~> 5.14"])
      s.add_development_dependency(%q<minitest-focus>.freeze, ["~> 1.1"])
      s.add_development_dependency(%q<minitest-rg>.freeze, ["~> 5.2"])
      s.add_development_dependency(%q<rake>.freeze, [">= 12.0"])
      s.add_development_dependency(%q<redcarpet>.freeze, ["~> 3.0"])
      s.add_development_dependency(%q<simplecov>.freeze, ["~> 0.18"])
      s.add_development_dependency(%q<yard>.freeze, ["~> 0.9"])
      s.add_development_dependency(%q<yard-doctest>.freeze, ["~> 0.1.13"])
    else
      s.add_dependency(%q<faraday>.freeze, ["< 2.0", ">= 0.17.3"])
      s.add_dependency(%q<google-cloud-core>.freeze, ["~> 1.5"])
      s.add_dependency(%q<googleapis-common-protos>.freeze, ["< 2.0", ">= 1.3.10"])
      s.add_dependency(%q<googleapis-common-protos-types>.freeze, ["< 2.0", ">= 1.0.5"])
      s.add_dependency(%q<googleauth>.freeze, ["~> 0.12"])
      s.add_dependency(%q<google-style>.freeze, ["~> 1.24.0"])
      s.add_dependency(%q<minitest>.freeze, ["~> 5.14"])
      s.add_dependency(%q<minitest-focus>.freeze, ["~> 1.1"])
      s.add_dependency(%q<minitest-rg>.freeze, ["~> 5.2"])
      s.add_dependency(%q<rake>.freeze, [">= 12.0"])
      s.add_dependency(%q<redcarpet>.freeze, ["~> 3.0"])
      s.add_dependency(%q<simplecov>.freeze, ["~> 0.18"])
      s.add_dependency(%q<yard>.freeze, ["~> 0.9"])
      s.add_dependency(%q<yard-doctest>.freeze, ["~> 0.1.13"])
    end
  else
    s.add_dependency(%q<faraday>.freeze, ["< 2.0", ">= 0.17.3"])
    s.add_dependency(%q<google-cloud-core>.freeze, ["~> 1.5"])
    s.add_dependency(%q<googleapis-common-protos>.freeze, ["< 2.0", ">= 1.3.10"])
    s.add_dependency(%q<googleapis-common-protos-types>.freeze, ["< 2.0", ">= 1.0.5"])
    s.add_dependency(%q<googleauth>.freeze, ["~> 0.12"])
    s.add_dependency(%q<google-style>.freeze, ["~> 1.24.0"])
    s.add_dependency(%q<minitest>.freeze, ["~> 5.14"])
    s.add_dependency(%q<minitest-focus>.freeze, ["~> 1.1"])
    s.add_dependency(%q<minitest-rg>.freeze, ["~> 5.2"])
    s.add_dependency(%q<rake>.freeze, [">= 12.0"])
    s.add_dependency(%q<redcarpet>.freeze, ["~> 3.0"])
    s.add_dependency(%q<simplecov>.freeze, ["~> 0.18"])
    s.add_dependency(%q<yard>.freeze, ["~> 0.9"])
    s.add_dependency(%q<yard-doctest>.freeze, ["~> 0.1.13"])
  end
end
