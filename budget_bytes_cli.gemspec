# coding: utf-8

require_relative "./lib/budget_bytes_cli/version"

Gem::Specification.new do |spec|
  spec.name          = "budget-bytes-cli"
  spec.version       = BudgetBytesCli::VERSION
  spec.authors       = ["Larry Weinstein"]
  spec.email         = ["lawrence.e.weinstein@gmail.com"]

  spec.summary       = %q{A CLI interface for Budget Bytes, a recipe blog.}
  spec.description   = %q{Currently in Beta, please report bugs to the author.}
  spec.homepage      = "https://github.com/Larry-42/budget-bytes-cli"
  spec.license       = "MIT"

  spec.files = ["lib/budget_bytes_cli.rb", "lib/budget_bytes_cli/cli.rb", "lib/budget_bytes_cli/category-scraper.rb", "lib/budget_bytes_cli/category.rb", "lib/budget_bytes_cli/recipe.rb", "lib/budget_bytes_cli/array-prompter.rb", "config/environment.rb"]

  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.executables << "budget-bytes-cli"

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "nokogiri"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "launchy"
end
