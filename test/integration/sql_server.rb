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
    location: 'eastus'
)

########################################################################################################################
######################                         Create Sql Server                                  ######################
########################################################################################################################
server_name = rand(0...99999)

azure_sql_service.sql_servers.create(
  name: server_name,
  resource_group: 'TestRG-SQL',
  location: 'East US',
  version: '2.0',
  administrator_login: 'testserveradmin',
  administrator_login_password: 'db@admin=123'
)

########################################################################################################################
######################                        Create Sql Database                                 ######################
########################################################################################################################
database_name = rand(0...99999)

azure_sql_service.sql_databases.create(
  resource_group: 'TestRG-SQL',
  location: 'East US',
  server_name: server_name,
  name: database_name
)

########################################################################################################################
######################                   Get Sql Database                                         ######################
########################################################################################################################

database = azure_sql_service.sql_databases
              .get('TestRG-SQL', server_name, database_name)
puts "GET Database: #{database.name}"

########################################################################################################################
######################                        List Sql Database                                   ######################
########################################################################################################################

databases  = azure_sql_service.sql_databases(resource_group: 'TestRG-SQL', server_name: server_name)
databases.each do |database|
  puts "List Databases: #{database.name}"
end

########################################################################################################################
######################                   Get and Destroy Sql Database                             ######################
########################################################################################################################

database = azure_sql_service.sql_databases
               .get('TestRG-SQL', server_name, database_name)
database.destroy

########################################################################################################################
######################                       Get Sql Server                                       ######################
########################################################################################################################

server = azure_sql_service
              .sql_servers.get('TestRG-SQL', server_name)
puts "GET Server: #{server.name}"

########################################################################################################################
######################                             List Sql Servers                               ######################
########################################################################################################################

servers  = azure_sql_service.sql_servers(resource_group: 'TestRG-SQL')
servers.each do |server|
  puts "List Serves : #{server.name}"
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
