#Resources

This document explains how to get started using Azure Resources Service with Fog. With this gem you can create/update/list/delete resource groups.

## Usage

First of all, you need to require the Fog library by executing:

```ruby
require 'fog/azurerm'
```

## Create Connection

Next, create a connection to the Resources Service:

```ruby
    azure_resources_service = Fog::Resources::AzureRM.new(
        tenant_id:       '<Tenantid>',           # Tenant id of Azure Active Directory Application
        client_id:       '<Clientid>',           # Client id of Azure Active Directory Application
        client_secret:   '<ClientSecret>',       # Client Secret of Azure Active Directory Application
        subscription_id: '<Subscriptionid>'      # Subscription id of an Azure Account
)
```
## Create Resource Group

Create a new resource group

```ruby
    azure_resources_service.resource_groups.create(
        name:     '<Resource Group name>',
        location: 'West US'
 )
```
## List Resource Groups

```ruby
    azure_resources_service.resource_groups.each do |resource_group|
        puts "#{resource_group.name}"
        puts "#{resource_group.location}"
    end
```

## Retrieve a single Resource Group

Get a single record of Resource Group

```ruby
      resource_group = azure_resources_service
                          .resource_groups
                          .get('<Resource Group name>')
      puts "#{resource_group.name}"
```

## Destroy a single Resource Group

Get resource group object from the get method(described above) and then destroy that resource group.

```ruby
      resource_group.destroy
```

## Support and Feedback
Your feedback is appreciated! If you have specific issues with the fog ARM, you should file an issue via Github.
