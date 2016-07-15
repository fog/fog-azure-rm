lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fog/azurerm/version'

Gem::Specification.new do |spec|
  spec.name          = 'fog-azure-rm'
  spec.version       = Fog::AzureRM::VERSION
  spec.authors       = ['Shaffan Chaudhry', 'Samawia Moin', 'Adnan Khalil', 'Zeeshan Arshad', 'Haider Ali']
  spec.summary       = "Module for the 'fog' gem to support Azure Resource Manager cloud services."
  spec.description   = "This library can be used as a module for 'fog' or as standalone provider
                        to use the Azure Resource Manager cloud services in applications.."
  spec.files         = Dir['{lib}/**/*.rb', 'bin/*', 'LICENSE', '*.md']
  spec.require_paths = ['lib']
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.8.4'
  spec.add_development_dependency 'simplecov', '~> 0.11.2'
  spec.add_development_dependency 'codeclimate-test-reporter'
  spec.add_dependency 'fog-core', '~> 1.27'
  spec.add_dependency 'fog-json', '~> 1.0'
  spec.add_dependency 'fog-xml', '~> 0.1'
  spec.add_dependency 'rest-client', '~> 1.8'
  spec.add_dependency 'azure_mgmt_compute', '~> 0.2.1'
  spec.add_dependency 'azure_mgmt_resources', '~> 0.2.1'
  spec.add_dependency 'azure_mgmt_storage', '~> 0.2.1'
  spec.add_dependency 'azure_mgmt_network', '~> 0.2.1'
  spec.add_dependency 'azure-storage', '0.10.2.preview'
end
