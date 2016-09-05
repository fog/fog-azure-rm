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

########################################################################################################################
######################                                Create Deployment                     ############################
########################################################################################################################

resources.deployments.create(
  name:            'testdeployment',
  resource_group:  resource_group.name,
  template_link:   'https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-azure-dns-new-zone/azuredeploy.json',
  parameters_link: 'https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-azure-dns-new-zone/azuredeploy.parameters.json'
)

########################################################################################################################
######################                    List and Get Deployment                              #########################
########################################################################################################################

deployment = resources.deployments.get(resource_group.name, 'testdeployment')

########################################################################################################################
######################               Destroy Deployment                                  ###############################
########################################################################################################################

deployment.destroy

########################################################################################################################
######################                                   CleanUp                                  ######################
########################################################################################################################

resource_group.destroy
