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

azure_sql_service = Fog::Sql::AzureRM.new(
  tenant_id: azure_credentials['tenant_id'],
  client_id: azure_credentials['client_id'],
  client_secret: azure_credentials['client_secret'],
  subscription_id: azure_credentials['subscription_id']
)

########################################################################################################################
######################                                 Prerequisites                              ######################
########################################################################################################################

resources.resource_groups.create(
  name: 'TestRG-SQL',
  location: LOCATION
)

########################################################################################################################
######################                         Create Sql Server                                  ######################
########################################################################################################################
# begin
server_name = rand(0...999_99)

azure_sql_service.sql_servers.create(
  name: server_name,
  resource_group: 'TestRG-SQL',
  location: LOCATION,
  version: '2.0',
  administrator_login: 'testserveradmin',
  administrator_login_password: 'db@admin=123'
)

########################################################################################################################
######################                        Create Sql Database                                 ######################
########################################################################################################################
database_name = rand(0...999_99)

azure_sql_service.sql_databases.create(
  resource_group: 'TestRG-SQL',
  location: LOCATION,
  server_name: server_name,
  name: database_name
)

########################################################################################################################
######################                   Get Sql Database                                         ######################
########################################################################################################################

sleep 60
database = azure_sql_service.sql_databases.get('TestRG-SQL', server_name, database_name)
# rescue
#   resource_group = resources.resource_groups.get('TestRG-SQL')
#   resource_group.destroy
# end
Fog::Logger.debug "GET Database: #{database.name}"

########################################################################################################################
######################                        List Sql Database                                   ######################
########################################################################################################################

databases = azure_sql_service.sql_databases(resource_group: 'TestRG-SQL', server_name: server_name)
databases.each do |a_database|
  Fog::Logger.debug "List Databases: #{a_database.name}"
end

########################################################################################################################
######################                   Get and Destroy Sql Database                             ######################
########################################################################################################################

database = azure_sql_service.sql_databases.get('TestRG-SQL', server_name, database_name)
database.destroy

########################################################################################################################
######################                        Create Sql Firewall Rule                            ######################
########################################################################################################################

azure_sql_service.firewall_rules.create(
  resource_group: 'TestRG-SQL',
  server_name: server_name,
  name: 'test-rule-name',
  start_ip: '10.10.10.10',
  end_ip: '10.10.10.11'
)

########################################################################################################################
######################                   Get Sql Firewall Rule                                    ######################
########################################################################################################################

firewall_rule = azure_sql_service.firewall_rules.get('TestRG-SQL', server_name, 'test-rule-name')
Fog::Logger.debug "GET Firewall Rule: #{firewall_rule.name}"

########################################################################################################################
######################                        List Sql Firewall Rules                             ######################
########################################################################################################################

firewall_rules = azure_sql_service.firewall_rules(resource_group: 'TestRG-SQL', server_name: server_name, name: 'test-rule-name')
firewall_rules.each do |a_firewall_rule|
  Fog::Logger.debug "List Firewall Rule: #{a_firewall_rule.name}"
end

########################################################################################################################
######################                   Get and Destroy Sql Firewall Rule                        ######################
########################################################################################################################

firewall_rule = azure_sql_service.firewall_rules.get('TestRG-SQL', server_name, 'test-rule-name')
firewall_rule.destroy

########################################################################################################################
######################                       Get Sql Server                                       ######################
########################################################################################################################

server = azure_sql_service.sql_servers.get('TestRG-SQL', server_name)
Fog::Logger.debug "GET Server: #{server.name}"

########################################################################################################################
######################                             List Sql Servers                               ######################
########################################################################################################################

servers = azure_sql_service.sql_servers(resource_group: 'TestRG-SQL')
servers.each do |a_server|
  Fog::Logger.debug "List Serves : #{a_server.name}"
end

########################################################################################################################
######################                    Get and Destroy Sql Servers                             ######################
########################################################################################################################

server = azure_sql_service.sql_servers.get('TestRG-SQL', server_name)
server.destroy

########################################################################################################################
######################                                   CleanUp                                  ######################
########################################################################################################################

resource_group = resources.resource_groups.get('TestRG-SQL')
resource_group.destroy
