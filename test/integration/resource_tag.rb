require 'fog/azurerm'
require 'yaml'

########################################################################################################################
######################                   Services object required by all actions                  ######################
######################                              Keep it Uncommented!                          ######################
########################################################################################################################

azure_credentials = YAML.load_file('credentials/azure.yml')

resources = Fog::Resources::AzureRM.new(
  tenant_id: azure_credentials['tenant_id'],
  client_id: azure_credentials['client_id'],
  client_secret: azure_credentials['client_secret'],
  subscription_id: azure_credentials['subscription_id']
)

network = Fog::Network::AzureRM.new(
  tenant_id: azure_credentials['tenant_id'],
  client_id: azure_credentials['client_id'],
  client_secret: azure_credentials['client_secret'],
  subscription_id: azure_credentials['subscription_id']
)

########################################################################################################################
######################                                 Prerequisites                              ######################
########################################################################################################################

begin
  resource_group = resources.resource_groups.create(
    name: 'TestRG-RT',
    location: LOCATION
  )

  resource_id = network.public_ips.create(
    name: 'mypubip',
    resource_group: 'TestRG-RT',
    location: LOCATION,
    public_ip_allocation_method: 'Static'
  ).id

  ########################################################################################################################
  ######################                                Tag Resource                          ############################
  ########################################################################################################################

  tag_resource = resources.tag_resource(
    resource_id,
    'test-key',
    'test-value'
  )
  puts "Tagged resource: #{tag_resource}"

  ########################################################################################################################
  ######################                    List Resources in a Tag                       #########################
  ########################################################################################################################

  resources = resources.azure_resources(tag_name: 'test-key', tag_value: 'test-value')
  puts 'List resources in a tag:'
  resources.each do |resource|
    puts resource.name
  end

  resource = resources.azure_resources(tag_name: 'test-key').get(resource_id)
  puts "Get resource in a tag: #{resource.name}"

  ########################################################################################################################
  ######################               Remove Tag from a Resource                   ###############################
  ########################################################################################################################

  resource = resources.delete_resource_tag(
    resource_id,
    'test-key',
    'test-value'
  )
  puts "Removed tag from a resource: #{resource}"
  ########################################################################################################################
  ######################                                   CleanUp                                  ######################
  ########################################################################################################################

  resource_group.destroy
rescue
  puts 'Integration Test for tagging a resource is failing'
  resource_group.destroy unless resource_group.nil?
end
