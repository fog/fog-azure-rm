#Azure SQL

This document explains how to get started using Azure SQL Services with Fog.

## Usage

First of all, you need to require the Fog library by executing:

```ruby
require 'fog/azurerm'
```

## Create Connection

Next, create a connection to the SQL Service:

```ruby
    azure_sql_service = Fog::Sql::AzureRM.new(
      tenant_id:        '<Tenantid>',                                                      # Tenant id of Azure Active Directory Application
      client_id:        '<Clientid>',                                                      # Client id of Azure Active Directory Application
      client_secret:    '<ClientSecret>',                                                  # Client Secret of Azure Active Directory Application
      subscription_id:  '<Subscriptionid>',                                                # Subscription id of an Azure Account
      environment:      '<AzureCloud/AzureChinaCloud/AzureUSGovernment/AzureGermanCloud>'  # Azure cloud environment. Default is AzureCloud.
    )
```

The {server-name} and {database-name} value must be set using all lowercase ANSI letters , hyphen, and the numbers 1 through 9. Do not use a hyphen as the leading or trailing character.


## Create SQL Server

Create a new Server

```ruby
    azure_sql_service.sql_servers.create(
        name: '<Unique Server Name>',
        resource_group: '<Resource Group Name>',
        location: 'East US',
        version: '2.0',                                                                     # Specifies the version of the Azure server. The acceptable value are: '2.0' or '12.0'
        administrator_login: 'testserveradmin',                                             # Specifies the name of the SQL administrator.
        administrator_login_password: 'svr@admin123',                                       # Specifies the password of the SQL administrator.
        tags: { key1: "value1", key2: "value2", keyN: "valueN" }                            # [Optional]
    )
```
For more information, see link: https://msdn.microsoft.com/en-us/library/azure/mt297738.aspx

## List SQL Servers
Get a list of servers in given resource group
```ruby
    servers  = azure_sql_service.sql_servers(resource_group: '<Resource Group Name>')
    servers.each do |server|
      puts "Listing : #{server.name}"
    end
```

## Retrieve a single SQL Server

Get a single record of SQL Server

```ruby
     server = azure_sql_service.sql_servers
                   .get('<Resource Group Name>', '<Server Name>')
     puts "Server Name: #{server.name}"
```

## Destroy a SQL Server

Get SQL Server object from the get method(described above) and destroy that Server.

```ruby
      server.destroy
```

## Create SQL Database

Creates a new Sql Database

In parameter {create_mode}: 'Copy', 'NonReadableSecondary', and 'OnlineSecondary' are not supported by SQL Data Warehouse.

If parameter {edition} is set to DataWarehouse, the acceptable values for parameter {requested_service_objective_name} are: ['DW100', 'DW200', 'DW300', 'DW400', 'DW500', 'DW600', 'DW1000', 'DW1200', 'DW1500', 'DW2000', 'DW3000', 'DW6000'] 

```ruby
    azure_sql_service.sql_databases.create(
        resource_group: '<Resource Group Name>',
        location: 'East US',
        server_name: '<Server Name>',
        name: '<Database Name>',
        create_mode: '<Create Mode>',                                                       # Optional. Specifies the type of database to create. The default value is Default. The acceptable values are: [Copy, Default, NonReadableSecondary, OnlineSecondary, PointInTimeRestore, PointInTimeRestore, Restore]
        edition: '<Edition>',                                                               # Conditional. Specifies the edition of the database. If createMode is set to Default, then this value must be specified. The acceptable value are: [Basic, Standard, Premium, DataWarehouse]
        source_database_id: '<URI>',                                                        # Conditional. Specifies the URI of the source database. If createMode is not set to Default, then this value must be specified.
        collation: '<Collation>',                                                           # Conditional. Specifies the name of the collation. If createMode is set to Default, then this value must be specified. 
        max_size_bytes: '<Size>',                                                           # Conditional. Specifies the maximum size to which the database may grow. If createMode is set to Default, then this value must be specified.
        requested_service_objective_name: '<Name>',                                         # Conditional. Specifies the requested service level of the database. If requestedServiceObjectiveId is specified, then this value must not be specified. The acceptable value are: [Basic, S0, S1, S2, S3, P1, P2, P4, P6, P11, ElasticPool]
        elastic_pool_name: '<Pool Name>',                                                   # Conditional. Specifies the name of the elastic database pool. If requestedServiceObjectiveId or requestedServiceObjectiveName is set to ElasticPool, then this value must be specified.
        requested_service_objective_id: '<GUID>',                                           # Conditional. Specifies the identifier of the requested service level. If requestedServiceObjectiveName is specified, then this value must not be specified.
        tags: { key1: "value1", key2: "value2", keyN: "valueN" }                            # [Optional]
    )
```
For more information see link: https://msdn.microsoft.com/en-us/library/azure/mt163685.aspx  

## List SQL Databases
Get a list of databases in given resource group

```ruby
    databases  = azure_sql_service.sql_databases(resource_group: '<Resource Group Name>', server_name: '<Server Name>')
    databases.each do |database|
      puts "Listing : #{database.name}"
    end
```

## Retrieve a single SQL Database

Get a single record of SQL Database

```ruby
     database = azure_sql_service.sql_databases
                   .get('<Resource Group Name>', '<Server Name>', '<Database Name>')
     puts "Database Name: #{database.name}"
```

## Destroy a SQL Database

Get SQL Database object from the get method(described above) and destroy that Database.

```ruby
      database.destroy
```

## Create Firewall Rule

Create a new Firewall Rule

```ruby
    azure_sql_service.firewall_rules.create(
        name: '<Firewall Rule Name>',
        resource_group: '<Resource Group Name>',
        server_location: '<Server Name>',
        start_ip: '<Start IP Address>',           # Specifies the starting IP address to allow through the firewall.
        end_ip: '<End IP Address>',               # Specifies the ending IP address to allow through the firewall.
        
    )
```

## List Firewall Rules
Get a list of Firewall Rules on a SQL Server in given resource group
```ruby
    firewall_rules  = azure_sql_service.firewall_rules(resource_group: '<Resource Group Name>', server_name: '<Server Name>')
    firewall_rules.each do |firewall_rule|
      puts "Listing : #{firewall_rule.name}"
    end
```

## Retrieve a single Firewall Rule
Get a single record of Firewall rule on SQL Server
```ruby
     firewall_rule = azure_sql_service.firewall_rules
                   .get('<Resource Group Name>', '<Server Name>', '<Firewall Rule Name>')
     puts "Get: Firewall Rule Name: #{firewall_rule.name}"
```

## Destroy a Firewall Rule
Get Firewall Rule object from the get method(described above) and destroy that Firewall Rule.

```ruby
      firewall_rule.destroy
```


## Support and Feedback
Your feedback is appreciated! If you have specific issues with the fog ARM, you should file an issue via Github.
