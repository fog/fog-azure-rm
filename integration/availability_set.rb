########################################################################################################################
######################                            Driver Code From Samawia                        ######################
########################################################################################################################

require 'fog/azurerm'
require 'yaml'

########################################################################################################################
######################                   Services object required by all actions                  ######################
######################                              Keep it Uncommented!                          ######################
########################################################################################################################

azureCredentials = YAML.load_file('credentials/azure.yml')

rs = Fog::Resources::AzureRM.new(
    tenant_id: azureCredentials['tenant_id'],
    client_id: azureCredentials['client_id'],
    client_secret: azureCredentials['client_secret'],
    subscription_id: azureCredentials['subscription_id']
)

compute = Fog::Compute::AzureRM.new(
    tenant_id: azureCredentials['tenant_id'],
    client_id: azureCredentials['client_id'],
    client_secret: azureCredentials['client_secret'],
    subscription_id: azureCredentials['subscription_id']
)


########################################################################################################################
######################                                 Prerequisites                              ######################
########################################################################################################################

rg = rs.resource_groups.create(
    :name => 'TestRG-AS',
    :location => 'eastus'
)

########################################################################################################################
######################                             Create Availability Set                        ######################
########################################################################################################################

avail_set = compute.availability_sets.create(
    :name => 'test-availability-set',
    :location => 'eastus',
    :resource_group => 'TestRG-AS'
)

########################################################################################################################
######################                       Get and Delete Availability Set                      ######################
########################################################################################################################

avail_set = compute.availability_sets(:resource_group => 'TestRG-AS').get('test-availability-set')
avail_set.destroy

########################################################################################################################
######################                                   CleanUp                                  ######################
########################################################################################################################

rg = rs.resource_groups.get('TestRG-AS')
rg.destroy