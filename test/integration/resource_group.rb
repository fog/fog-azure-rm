require 'fog/azurerm'
require 'yaml'

########################################################################################################################
######################                   Services object required by all actions                  ######################
######################                              Keep it Uncommented!                          ######################
########################################################################################################################

azure_credentials = YAML.load_file('credentials/azure.yml')

resource = Fog::Resources::AzureRM.new(
  tenant_id: azure_credentials['tenant_id'],
  client_id: azure_credentials['client_id'],
  client_secret: azure_credentials['client_secret'],
  subscription_id: azure_credentials['subscription_id']
)
resource_group_name = "RG-#{current_time}"

begin

  ########################################################################################################################
  ######################                   Check Resource Group Exists?                             ######################
  ########################################################################################################################

  if !resource.resource_groups.check_resource_group_exists(resource_group_name)
    puts "Resource Group doesn't exist."
  end

  ########################################################################################################################
  ######################                    Create Resource Group                                   ######################
  ########################################################################################################################

  resource_group = resource.resource_groups.create(
    name: resource_group_name,
    location: 'eastus'
  )

  puts "Created resource group #{resource_group.name}"
  ########################################################################################################################
  ######################           Get All Resource Groups in a Subscription                        ######################
  ########################################################################################################################

  resource_groups = resource.resource_groups
  puts 'List resource groups:'
  resource_groups.each do |a_resource_group|
    puts a_resource_group.name
  end

  resource_group = resource_groups.get(resource_group_name)
  puts "Get resource group: #{resource_group.name}"

  ########################################################################################################################
  ######################                           Destroy Resource Group                           ######################
  ########################################################################################################################

  puts "Deleted resource group: #{resource_group.destroy}"
rescue
  puts 'Integration Test for resource group is failing'
  resource_group.destroy unless resource_group.nil?
end
