require 'fog/azurerm'
require 'yaml'

azure_credentials = YAML.load_file(File.expand_path('credentials/azure.yml', __dir__))

compute = Fog::Compute::AzureRM.new(
  tenant_id: azure_credentials['tenant_id'],
  client_id: azure_credentials['client_id'],
  client_secret: azure_credentials['client_secret'],
  subscription_id: azure_credentials['subscription_id']
)

begin
  ########################################################################################################################
  ######################                      List virtual machine sizes                            ######################
  ########################################################################################################################

  puts 'List of virtual machine sizes:'
  virtual_machine_sizes = compute.virtual_machine_sizes(location: LOCATION)
  virtual_machine_sizes.each do |virtual_machine_size|
    puts "- #{virtual_machine_size.name}"
  end

  puts 'Integration Test for virtual machine size ran successfully!'
rescue StandardError
  puts 'Integration Test for virtual machine size is failing!'
end
