#SQL

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
        tenant_id:       '<Tenantid>',           # Tenant id of Azure Active Directory Application
        client_id:       '<Clientid>',           # Client id of Azure Active Directory Application
        client_secret:   '<ClientSecret>',       # Client Secret of Azure Active Directory Application
        subscription_id: '<Subscriptionid>'      # Subscription id of an Azure Account
)
```
## Create SQL Server

Create a new Server

```ruby
    azure_sql_service.sql_servers.create(
        name: '<Unique Server Name>',
        resource_group: '<Resource Group Name>',
        location: 'East US',
        version: '2.0',                                # Specifies the version of the Azure server. The acceptable value are: '2.0' or '12.0'
        administrator_login: 'testserveradmin',        # Specifies the name of the SQL administrator.
        administrator_login_password: 'svr@admin123'   # Specifies the password of the SQL administrator.
    )
```
## List SQL Servers

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


## Support and Feedback
Your feedback is appreciated! If you have specific issues with the fog ARM, you should file an issue via Github.
