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
  :tenant_id => '<Tenantid>',                                     # Tenant id of Azure Active Directory Application
  :client_id =>    '<Clientid>',                                  # Client id of Azure Active Directory Application
  :client_secret => '<ClientSecret>',                             # Client Secret of Azure Active Directory Application
  :subscription_id => '<Subscriptionid>'                          # Subscription id of an Azure Account
  :azure_storage_account_name => '<StorageAccountName>'           # Name of an Azure Storage Account
  :azure_storage_access_key => '<StorageAccountKey>'              # Key of an Azure Storage Account
  :azure_storage_connection_string => '<StorageConnectionString>' # Connection String of an Azure Storage Account
)
```

If you only want to manage the storage accounts, you can create the connection without the storage account information:

```ruby
azure_storage_service = Fog::Storage.new(
  :provider => 'AzureRM',
  :tenant_id => '<Tenantid>',                                     # Tenant id of Azure Active Directory Application
  :client_id =>    '<Clientid>',                                  # Client id of Azure Active Directory Application
  :client_secret => '<ClientSecret>',                             # Client Secret of Azure Active Directory Application
  :subscription_id => '<Subscriptionid>'                          # Subscription id of an Azure Account
)
```

If you only want to manage the storage data, you can create the connection without the Azure subscription information:

```ruby
azure_storage_service = Fog::Storage.new(
  :provider => 'AzureRM',
  :azure_storage_account_name => '<StorageAccountName>'           # Name of an Azure Storage Account
  :azure_storage_access_key => '<StorageAccountKey>'              # Key of an Azure Storage Account
  :azure_storage_connection_string => '<StorageConnectionString>' # Connection String of an Azure Storage Account (optional)
)
```

## Check Name Availability 

Check Storage Account Name Availability.This operation checks that account name is valid and is not already in use.

```ruby
azure_storage_service.storage_accounts.check_name_availability('<Storage Account name>')
```

## Create Storage Account

Create a new storage account. Replication attribute for Standard and Premium account types are as follows 

Standard: LRS (Standard Locally-redundant storage)
          ZRS (Standard Zone-redundant storage)
          GRS (Standard Geo-redundant storage)
          RAGRS (Standard Read access geo-redundant storage)
Premium:  LRS (Premium Locally-redundant storage)

```ruby
azure_storage_service.storage_accounts.create(
  :name => '<Storage Account name>',
  :location => 'West US',
  :resource_group => '<Resource Group name>',
  :account_type => '<Standard/Premium>'                # Optional. Default value 'Standard'. Allowed values can only be Standard or Premium
  :replication => 'LRS'                                # Optional. Default value 'LRS' 
)
```
Premium Storage account store data on solid state drives (SSDs). For more details on standard and premium storage accounts, see [Introduction to Microsoft Azure Storage](https://azure.microsoft.com/en-us/documentation/articles/storage-introduction/) and [Premium Storage: High-Performance Storage for Azure Virtual Machine Workloads](https://azure.microsoft.com/en-us/documentation/articles/storage-premium-storage/).

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
                .storage_accounts
                .get('<Resource Group name>', '<Storage Account name>')
puts "#{storage_acc.name}"
```

## Get Access Keys

Get access keys of a storage account

```ruby
keys_hash = storage_acc.get_access_keys
keys_hash.each do |keys|
  puts "#{keys.key_name}:  #{keys.value}"
end
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

## Create a storage container

Create a storage container in the current storage account.

```ruby
container = azure_storage_service.create_container(
  name: '<container name>'
)
puts "#{container.name}"
```

## List storage containers

List all the storage containers in the current storage accounts.

```ruby
azure_storage_service.containers.each do |container|
  puts "#{container.name}"
end
```

## Get the access control list of the storage container

Get the permissions for the specified container. The permissions indicate whether container data may be accessed publicly.

```ruby
container = azure_storage_service.containers.get('<container name>')
access_control_list = container.get_access_control_list('<container name>')
puts "#{access_control_list.inspect}"
```

## Delete the storage container

Mark the specified container for deletion. The container and any blobs contained within it are later deleted during garbage collection.

```ruby
container = azure_storage_service.containers.get('<container name>')
result = container.destroy
puts "#{result}"
```

## Upload a local file as a blob
```ruby
new_blob = azure_storage_service.blobs.get('<Container name>', '<Blob name>').create(file_path: '<file path>')
puts "#{new_blob.inspect}"
```

## Download a blob to a local file
```ruby
blob = azure_storage_service.blobs.get('<Container name>', '<Blob name>').save_to_file('<file path>')
puts "#{blob.inspect}"
puts "File Size: #{File.size <file_path>}"
```

## Delete the storage blob

Mark the specified blob for deletion. The blob is later deleted during garbage collection.

```ruby
blob = azure_storage_service.blobs.get('<container name>', '<blob name>')
result = blob.destroy
puts "#{result}"
```

Note that in order to delete a blob, you must delete all of its snapshots.

```ruby
blob = azure_storage_service.blobs.get('<container name>', '<blob name>')
result = blob.destroy(delete_snapshots: 'only')
puts "#{result}"

result = blob.destroy
puts "#{result}"
```

You can delete both at the same time by specifying the option.

```ruby
blob = azure_storage_service.blobs.get('<container name>', '<blob name>')
result = blob.destroy(delete_snapshots: 'inlcude')
puts "#{result}"
```

## Properties

### Get storage container properties

Get the storage container properties. The properties will not fetch the access control list. Call `get_container_access_control_list` to fetch it.

```ruby
container = azure_storage_service.containers.get('<container name>')
properties = container.get_properties
puts "#{properties.inspect}"
```

### Get storage blob properties

Get the storage blob properties.

```ruby
blob = azure_storage_service.blobs.get('<container name>', '<blob name>')
properties = blob.get_properties
puts "#{properties.inspect}"
```

### Set storage blob properties

Set the storage blob properties. The properties are passed in name/value pairs.

```ruby
blob = azure_storage_service.blobs.get('<container name>', '<blob name>')
properties = {
  "content_language" => "English",
  "content_disposition" => "attachment"
}
blob.set_properties(properties)
```

## Metadata

Metadata allows us to provide descriptive information about specific containers or blobs. This is simply providing name/value pairs of data we want to set on the container or blob.

### Get Blob Metadata

```ruby
azure_storage_service.blobs.get('<Container name>', '<Blob name>').get_metadata
```

### Set Blob Metadata

```ruby
metadata = {
  "Category" => "Images",
  "Resolution" => "High"
}
azure_storage_service.blobs.get('<Container name>', '<Blob name>').set_metadata(metadata)
```

### Get Container Metadata

```ruby
azure_storage_service.containers.get_container_metadata('<Container name>')
```

### Set Container Metadata

```ruby
metadata = {
  "CreatedBy" => "User",
  "SourceMachine" => "Mymachine",
  "category" => "guidance",
  "docType" => "textDocuments"
  }
azure_storage_service.containers.set_container_metadata('<Container name>', metadata)
```

## Support and Feedback
Your feedback is appreciated! If you have specific issues with the fog ARM, you should file an issue via Github.




