# Compute

This document explains how to get started using Azure Compute Service with Fog.

## Usage 

First of all, you need to require the Fog library by executing:

```ruby
require 'fog/azurerm'
```

## Create Connection

Next, create a connection to the Compute Service:

```ruby
    azure_compute_service = Fog::Compute::AzureRM.new(
        tenant_id: '<Tenantid>',                  # Tenant id of Azure Active Directory Application
        client_id:    '<Clientid>',               # Client id of Azure Active Directory Application
        client_secret: '<ClientSecret>',          # Client Secret of Azure Active Directory Application
        subscription_id: '<Subscriptionid>'       # Subscription id of an Azure Account
)
```
## Create Availability Set

Create a new availability set

```ruby
    azure_compute_service.availability_sets.create(
         name: '<Availability Set name>',
         location: 'West US',
         resource_group: '<Resource Group name>'
)
```
## List Availability Sets 

List availability sets in a resource group

```ruby
    availability_sets  = azure_compute_service.availability_sets(resource_group: '<Resource Group name>')
    availability_sets.each do |availability_set|
        puts "#{availability_set.name}"
        puts "#{availability_set.location}"
    end
```

## Retrieve a single record

Get a single record of Availability Set

```ruby
      availability_set = azure_compute_service
                          .availability_sets(resource_group: '<Resource Group name>')
                          .get('<Resource Group name>','<Availability Set name>')
        puts "#{availability_set.name}"
```

## Destroy a single record

Get an availability set object from the get method and then destroy that availability set.

```ruby
      availability_set.destroy
```

## Support and Feedback
Your feedback is appreciated! If you have specific issues with the fog ARM, you should file an issue via Github.




