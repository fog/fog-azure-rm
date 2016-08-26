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

########################################################################################################################
######################                                 Prerequisites                              ######################
########################################################################################################################

resource_group = resources.resource_groups.create(
  name: 'TestRG-ZN',
  location: 'eastus'
)

# Will remove this hardcoded string when other services will be updated too
resource_id = "/subscriptions/#{azure_credentials['subscription_id']}/resourceGroups/TestRG-ZN/providers/Microsoft.Network/virtualNetworks/testvnet"

########################################################################################################################
######################                                Tag Resource                          ############################
########################################################################################################################

resources.tag_resource(
  resource_id,
  'test-key',
  'test-value'
)

########################################################################################################################
######################                    List Resources in a Tag                       #########################
########################################################################################################################

resources.azure_resources(tag_name: 'test-key', tag_value: 'test-value')

resources.azure_resources(tag_name: 'test-key').get(resource_id)

########################################################################################################################
######################               Remove Tag from a Resource                   ###############################
########################################################################################################################

resources.delete_resource_tag(
  resource_id,
  'test-key',
  'test-value'
)

########################################################################################################################
######################                                   CleanUp                                  ######################
########################################################################################################################

resource_group.destroy
