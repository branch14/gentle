require File.join(File.dirname(__FILE__), %w(lib gentle version))

Gem::Specification.new do |gem|
  gem.name = 'gentle'
  gem.version = Gentle::VERSION
  
  gem.summary = "a templating engine based on css3 selectors and transformators"
  gem.description = "Gentle lets you use mockups as templates -- no need to even touch the markup."
  
  gem.files = Dir['Rakefile', '{bin,lib}/**/*', 'README', 'LICENSE'] & `git ls-files`.split("\n")
  gem.executables = Dir['bin/*'].map { |f| File.basename(f) }
  
  gem.add_dependency 'nokogiri', '~> 1.4.1'
  
  gem.email = 'phil@branch14.org'
  gem.homepage = 'http://github.com/branch14/' + gem.name
  gem.authors = ['Phil Hofmann']
  
  gem.has_rdoc = true
  gem.rubyforge_project = nil
end
