# frozen_string_literal: true

require_relative "lib/seed_migrator/version"

Gem::Specification.new do |s|
  s.name = "seed_migrator"
  s.version = SeedMigrator::VERSION

  s.require_paths = ["lib"]
  s.authors = ["Arthur Shagall", "Zach Belzer", "Peter Maneykowski"]
  s.description = "Provides a clean way to handle updates to seed data post-launch."
  s.email = ["arthur.shagall@gmail.com", "zbelzer@gmail.com", "peter.maneykowski@gmail.com"]
  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
  s.files = %w[README.md seed_migrator.gemspec] + `git ls-files | grep -E '^(lib)'`.split("\n")
  s.homepage = "https://github.com/HornsAndHooves"
  s.summary = "Handle post-release data updates through migrations"

  s.add_dependency "activesupport"
  s.add_dependency "activerecord"
end

