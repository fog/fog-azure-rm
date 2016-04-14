#Storage

This document explains how to get started using Azure Storage Service with Fog.

## Require Gem 

First of all, you need to require the Fog library by executing:

```ruby
        require 'fog/azurerm'
```

## Create Connection

Next, create a connection to the Storage Service:

```ruby
    azure_storage_service = Fog::Storage::AzureRM.new(
        :provider => 'AzureRM',
        :tenant_id => '<Tenantid>',                 # Tenant id of Azure Active Directory Application
        :client_id =>    '<Clientid>',              # Client id of Azure Active Directory Application
        :client_secret => '<ClientSecret>',         # Client Secret of Azure Active Directory Application
        :subscription_id => '<Subscriptionid>'      # Subscription id of an Azure Account
)
```
## Storage Account creation

Creating a new storage account

```ruby
    azure_storage_service.storage_accounts.create(
        :name => '<Storage Account name>',
        :location => 'West US',
        :resource_group => '<Resource Group name>'
 )
```
## Listing storage accounts

##### Listing storage accounts in a subscription

```ruby
    azure_storage_service.storage_accounts.each do |storage_acc|
        puts "#{storage_acc.name}"
        puts "#{storage_acc.location}"
    end
```
##### Listing storage accounts in a resource group

```ruby
    storage_accounts  = azure_storage_service.storage_accounts(resource_group: '<Resource Group name>')
    storage_accounts.each do |storage_acc|
        puts "#{storage_acc.name}"
        puts "#{storage_acc.location}"
    end
```

## Retrieve a single record

Getting a single record of Storage Account

```ruby
      storage_acc = azure_storage_service
                          .storage_accounts(resource_group: '<Resource Group name>')
                          .get('<Storage Account name>')
        puts "#{storage_acc.name}"
```

## Destroy a single record

Get storage account object from the get method and then destroy that storage account.

```ruby
      storage_acc.destroy
```

# Support and Feedback
Your feedback is appreciated! If you have specific issues with the fog ARM, you should file an issue via Github.




