require_relative "lib/sqids/rails/version"

Gem::Specification.new do |spec|
  spec.name = "sqids-rails"
  spec.version = Sqids::Rails::VERSION
  spec.authors = ["Tony Burns"]
  spec.email = ["tony@tonyburns.net"]
  spec.homepage = "https://github.com/tbhb/sqids-rails"
  spec.summary = "Short, unique, and human-readable IDs for ActiveRecord models with Sqids."
  spec.description = spec.summary
  spec.license = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/tbhb/sqids-rails"
  spec.metadata["changelog_uri"] = "https://github.com/tbhb/sqids-rails/blob/main/sqids-rails/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "LICENSE.txt", "Rakefile", "README.md"]
  end

  spec.required_ruby_version = ">= 3.1"

  spec.add_dependency "rails", ">= 6.1.0"
  spec.add_dependency "sqids", "~> 0.2"

  spec.add_development_dependency "appraisal"
end
