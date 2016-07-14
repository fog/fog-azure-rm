#Storage

This document explains how to get started using Azure Storage Service with Fog. With this gem you can create/update/list/delete storage accounts.

## Usage

First of all, you need to require the Fog library by executing:

```ruby
require 'fog/azurerm'
```

## Create Connection

Next, create a connection to the Storage Service:

```ruby
    azure_storage_service = Fog::Storage.new(
        :provider => 'AzureRM',
        :tenant_id => '<Tenantid>',                 # Tenant id of Azure Active Directory Application
        :client_id =>    '<Clientid>',              # Client id of Azure Active Directory Application
        :client_secret => '<ClientSecret>',         # Client Secret of Azure Active Directory Application
        :subscription_id => '<Subscriptionid>'      # Subscription id of an Azure Account
        :azure_storage_account_name => 'haidersa',
        :azure_storage_access_key => 'XTqLFT90JC5S42MhsO0cSW0pYmGoOesCkAtKX+WsD5js60rXKR2fCyhRMwBYBD0GmrsDS1LaCPcK7wj2Uez9zQ=='
)
```

If you only want to manage storage accounts, you can create the connection without the storage account information:

```ruby
    azure_storage_service = Fog::Storage.new(
        :provider => 'AzureRM',
        :tenant_id => '<Tenantid>',                 # Tenant id of Azure Active Directory Application
        :client_id =>    '<Clientid>',              # Client id of Azure Active Directory Application
        :client_secret => '<ClientSecret>',         # Client Secret of Azure Active Directory Application
        :subscription_id => '<Subscriptionid>'      # Subscription id of an Azure Account
)
```

If you only want to manage blobs, you can create the connection like this 

```ruby
    azure_storage_service = Fog::Storage.new(
        :provider => 'AzureRM',
        :azure_storage_account_name => 'haidersa',
        :azure_storage_access_key => 'XTqLFT90JC5S42MhsO0cSW0pYmGoOesCkAtKX+WsD5js60rXKR2fCyhRMwBYBD0GmrsDS1LaCPcK7wj2Uez9zQ=='
)
```

## Check Name Availability 

Check Storage Account Name Availability.This operation checks that account name is valid and is not already in use.

```ruby
    azure_storage_service.storage_accounts.check_name_availability('<Storage Account name>')
```

## Create Storage Account

Create a new storage account

```ruby
    azure_storage_service.storage_accounts.create(
        :name => '<Storage Account name>',
        :location => 'West US',
        :resource_group => '<Resource Group name>'
 )
```
## List storage accounts

##### List storage accounts in a subscription

```ruby
    azure_storage_service.storage_accounts.each do |storage_acc|
        puts "#{storage_acc.name}"
        puts "#{storage_acc.location}"
    end
```
##### List storage accounts in a resource group

```ruby
    storage_accounts  = azure_storage_service.storage_accounts(resource_group: '<Resource Group name>')
    storage_accounts.each do |storage_acc|
        puts "#{storage_acc.name}"
        puts "#{storage_acc.location}"
    end
```

## Retrieve a single Storage Account

Get a single record of Storage Account

```ruby
      storage_acc = azure_storage_service
                          .storage_accounts(resource_group: '<Resource Group name>')
                          .get('<Storage Account name>')
        puts "#{storage_acc.name}"
```

## Destroy a single Storage Account

Get storage account object from the get method and then destroy that storage account.

```ruby
      storage_acc.destroy
```

## Delete a Disk

Delete a Disk from a storage account. Disk must be in unlocked state i.e detached from server(virtual machine) to successfully perform this action.

```ruby
      azure_storage_service.delete_disk('<Resource Group name>', '<Storage Account name>', '<Data Disk Name>')
```

### Metadata

Metadata allows us to provide descriptive information about specific containers or blobs. This is simply providing name/value pairs of data we want to set on the container or blob.

## Get Blob Metadata

```ruby
      azure_storage_service.blobs.get_blob_metadata('<Container name>', '<Blob name>')
```

## Set Blob Metadata

```ruby
      metadata = {
        "Category" => "Images",
        "Resolution" => "High"
      }
      azure_storage_service.blobs.set_blob_metadata('<Container name>', '<Blob name>', metadata)
```

## Get Container Metadata

```ruby
      azure_storage_service.containers.get_container_metadata('<Container name>')
```

## Set Container Metadata

```ruby
      metadata = {
        "CreatedBy" => "Samawia",
        "SourceMachine" => "Mymachine",
        "category" => "guidance",
        "docType" => "textDocuments"
       }
      azure_storage_service.containers.set_container_metadata('<Container name>', metadata)
```

## Support and Feedback
Your feedback is appreciated! If you have specific issues with the fog ARM, you should file an issue via Github.




