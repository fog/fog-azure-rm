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

traffic_manager = Fog::TrafficManager::AzureRM.new(
  tenant_id: azure_credentials['tenant_id'],
  client_id: azure_credentials['client_id'],
  client_secret: azure_credentials['client_secret'],
  subscription_id: azure_credentials['subscription_id']
)

########################################################################################################################
######################                                 Prerequisites                              ######################
########################################################################################################################

resources.resource_groups.create(
  name: 'TestRG-TM',
  location: 'eastus'
)

########################################################################################################################
######################                         Create Traffic Manager Profile                     ######################
########################################################################################################################

traffic_manager.traffic_manager_profiles.create(
  name: 'test-tmp',
  resource_group: 'TestRG-TM',
  traffic_routing_method: 'Performance',
  relative_name: 'testapp',
  ttl: '30',
  protocol: 'http',
  port: '80',
  path: '/monitorpage.aspx'
)

########################################################################################################################
######################                        Create Traffic Manager Endpoint                    ######################
########################################################################################################################

traffic_manager.traffic_manager_end_points.create(
  name: 'myendpoint',
  traffic_manager_profile_name: 'test-tmp',
  resource_group: 'TestRG-TM',
  type: 'externalEndpoints',
  target: 'test-app.com',
  endpoint_location: 'eastus'
)

########################################################################################################################
######################                   Get and Destroy Traffic Manager Endpoint                ######################
########################################################################################################################

end_point = traffic_manager.traffic_manager_end_points.get('TestRG-TM', 'test-tmp', 'myendpoint', 'externalEndpoints')
end_point.destroy

########################################################################################################################
######################                    Get and Update Traffic Manager Profile                 ######################
########################################################################################################################

traffic_manager_profile = traffic_manager.traffic_manager_profiles.get('TestRG-TM', 'test-tmp')
traffic_manager_profile.update(traffic_routing_method: 'Weighted',
                               ttl: '35',
                               protocol: 'https',
                               port: '90',
                               path: '/monitorpage1.aspx')

########################################################################################################################
######################                    Get and Destroy Traffic Manager Profile                 ######################
########################################################################################################################

traffic_manager_profile = traffic_manager.traffic_manager_profiles.get('TestRG-TM', 'test-tmp')
traffic_manager_profile.destroy

########################################################################################################################
######################                                   CleanUp                                  ######################
########################################################################################################################

resource_group = resources.resource_groups.get('TestRG-TM')
resource_group.destroy
