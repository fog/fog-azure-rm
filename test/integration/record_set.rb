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

dns = Fog::DNS.new(
  provider: 'AzureRM',
  tenant_id: azure_credentials['tenant_id'],
  client_id: azure_credentials['client_id'],
  client_secret: azure_credentials['client_secret'],
  subscription_id: azure_credentials['subscription_id']
)

########################################################################################################################
######################                                 Prerequisites                              ######################
########################################################################################################################

rs.resource_groups.create(
  name: 'TestRG-RS',
  location: 'eastus'
)

dns.zones.create(
  name: 'test-zone.com',
  resource_group: 'TestRG-RS'
)

########################################################################################################################
######################                      Create CNAME Type Record Set in a Zone                 ######################
########################################################################################################################

dns.record_sets.create(
  name: 'TestRS1',
  resource_group: 'TestRG-RS',
  zone_name: 'test-zone.com',
  records: ['test.fog.com'],
  type: 'CNAME',
  ttl: 60
)

########################################################################################################################
######################                        Create A Type Record Set in a Zone                   ######################
########################################################################################################################

dns.record_sets.create(
  name: 'TestRS2',
  resource_group: 'TestRG-RS',
  zone_name: 'test-zone.com',
  records: %w(1.2.3.4 1.2.3.3),
  type: 'A',
  ttl: 60
)

########################################################################################################################
######################                Get And Destroy CNAME Type Record Set in a Zone             ######################
########################################################################################################################

rs = dns.record_sets(resource_group: 'TestRG-RS', zone_name: 'test-zone.com').get('TestRS1', 'CNAME')
rs.destroy

########################################################################################################################
######################                  Get And Destroy A Type Record Set in a Zone               ######################
########################################################################################################################

rs = dns.record_sets(resource_group: 'TestRG-RS', zone_name: 'test-zone.com').get('TestRS2', 'A')
rs.destroy

########################################################################################################################
######################                                   CleanUp                                  ######################
########################################################################################################################

zone = dns.zones.get('test-zone.com', 'TestRG-RS')
zone.destroy

rg = rs.resource_groups.get('TestRG-RS')
rg.destroy
