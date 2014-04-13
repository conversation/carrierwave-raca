
Gem::Specification.new do |gem|
  gem.name          = 'carrierwave-raca'
  gem.version       = '0.1.0'
  gem.authors       = ['James Healy']
  gem.email         = ['james.healy@thecovnersation.edu.au']
  gem.description   = %q{Use raca for Rackspace cloud files support in CarrierWave}
  gem.summary       = %q{A slimmer alternative to using Fog for Cloud files support in CarrierWave}
  gem.homepage      = 'https://github.com/conversation/carrierwave-raca'

  gem.files         =  Dir.glob("{lib}/**/*") + ["README.markdown"]

  gem.add_dependency 'carrierwave', '>= 0.7'
  gem.add_dependency 'raca',        '>= 0.3.0', '< 1.0'

  gem.add_development_dependency 'rspec', '~> 2.14'
  gem.add_development_dependency 'rake', '~> 10.0'
end
