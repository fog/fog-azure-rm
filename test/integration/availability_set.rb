require 'fog/azurerm'
require 'yaml'

########################################################################################################################
######################                   Services object required by all actions                  ######################
######################                              Keep it Uncommented!                          ######################
########################################################################################################################

azure_credentials = YAML.load_file('credentials/azure.yml')

rs = Fog::Resources::AzureRM.new(
  tenant_id: azure_credentials['tenant_id'],
  client_id: azure_credentials['client_id'],
  client_secret: azure_credentials['client_secret'],
  subscription_id: azure_credentials['subscription_id']
)

compute = Fog::Compute::AzureRM.new(
  tenant_id: azure_credentials['tenant_id'],
  client_id: azure_credentials['client_id'],
  client_secret: azure_credentials['client_secret'],
  subscription_id: azure_credentials['subscription_id']
)

########################################################################################################################
######################                               Resource names                                #####################
########################################################################################################################

time = current_time
resource_group_name = "AS-RG-#{time}"
availability_set_name = "AS#{time}@%%$%$#"

########################################################################################################################
######################                                 Prerequisites                              ######################
########################################################################################################################

begin
  resource_group = rs.resource_groups.create(
    name: resource_group_name,
    location: LOCATION
  )

  ########################################################################################################################
  ######################                             Create Availability Set                        ######################
  ########################################################################################################################

  avail_set = compute.availability_sets.create(
    name: availability_set_name,
    location: LOCATION,
    resource_group: resource_group_name
  )
  puts "Created availability set: #{avail_set.name}"

  ########################################################################################################################
  ######################                       List Availability Sets                               ######################
  ########################################################################################################################
  puts 'List availability sets:'
  compute.availability_sets(resource_group: resource_group_name).each do |availability_set|
    puts availability_set.name
  end

  ########################################################################################################################
  ######################                       Get and Delete Availability Set                      ######################
  ########################################################################################################################

  avail_set = compute.availability_sets.get(resource_group_name, availability_set_name)
  puts "Get availability set: #{avail_set.name}"
  puts "Deleted availability set: #{avail_set.destroy}"

  ########################################################################################################################
  ######################                                   CleanUp                                  ######################
  ########################################################################################################################

  rg = rs.resource_groups.get(resource_group_name)
  rg.destroy
rescue
  puts 'Integration Test for availability set is failing'
  resource_group.destroy unless resource_group.nil?
end
