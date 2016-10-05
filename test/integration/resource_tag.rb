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

resource_group = resources.resource_groups.create(
  name: 'TestRG-RT',
  location: 'eastus'
)

resource_id = network.public_ips.create(
    name: 'mypubip',
    resource_group: 'TestRG-RT',
    location: 'eastus',
    public_ip_allocation_method: 'Static'
).id

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
