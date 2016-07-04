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

network = Fog::Network::AzureRM.new(
    tenant_id: azureCredentials['tenant_id'],
    client_id: azureCredentials['client_id'],
    client_secret: azureCredentials['client_secret'],
    subscription_id: azureCredentials['subscription_id']
)

########################################################################################################################
######################                                 Prerequisites                              ######################
########################################################################################################################

rg = rs.resource_groups.create(
    :name => 'TestRG-TM',
    :location => 'eastus'
)

########################################################################################################################
######################                         Create Traffic Manager Profile                     ######################
########################################################################################################################

tm = network.traffic_manager_profiles.create(
    name: 'test-tmp',
    resource_group: 'TestRG-TM',
    traffic_routing_method: 'Performance',
    relative_name: 'testapp',
    ttl: '30',
    protocol: 'http',
    port: '80',
    path: '/monitorpage.aspx',
)

########################################################################################################################
######################                        Create Traffic Manager Endpoint                    ######################
########################################################################################################################

ep = network.traffic_manager_end_points.create(
    name: 'myendpoint',
    traffic_manager_profile_name: 'test-tmp',
    resource_group: 'TestRG-TM',
    type: 'external',
    target: 'test-app.com',
    endpoint_location: 'eastus'
)

########################################################################################################################
######################                   Get and Destroy Traffic Manager Endpoint                ######################
########################################################################################################################

ep = network.traffic_manager_end_points(resource_group: 'TestRG-TM', traffic_manager_profile_name: 'test-tmp').get('myendpoint')
ep.destroy

########################################################################################################################
######################                    Get and Destroy Traffic Manager Profile                 ######################
########################################################################################################################

tmp = network.traffic_manager_profiles(resource_group: 'TestRG-TM').get('test-tmp')
tmp.destroy

########################################################################################################################
######################                                   CleanUp                                  ######################
########################################################################################################################

rg = rs.resource_groups.get('TestRG-TM')
rg.destroy
