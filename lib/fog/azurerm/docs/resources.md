#Resources

This document explains how to get started using Azure Resources Service with Fog.

## Require Gem

First of all, you need to require the Fog library by executing:

```ruby
        require 'fog/azurerm'
```

## Create Connection

Next, create a connection to the Resources Service:

```ruby
    azure_resources_service = Fog::Storage::AzureRM.new(
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
## List resource groups

```ruby
    azure_resources_service.resource_groups.each do |resource_group|
        puts "#{resource_group.name}"
        puts "#{resource_group.location}"
    end
```

## Retrieve a single record

Get a single record of Resource Group

```ruby
      resource_group = azure_resources_service
                          .resource_groups
                          .get('<Resource Group name>')
      puts "#{resource_group.name}"
```

## Destroy a single record

Get resource group object from the get method(described above) and then destroy that resource group.

```ruby
      resource_group.destroy
```

# Support and Feedback
Your feedback is appreciated! If you have specific issues with the fog ARM, you should file an issue via Github.
