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
  :replication => 'LRS',                               # Optional. Default value 'LRS'
  :encryption => true                                  # Optional. If you want to enable encryption. Default value is 'false'
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

## Enable encryption on Storage Account

Get a single record of Storage Account and enable encryption on that Storage Account

```ruby
storage_acc = azure_storage_service
                .storage_accounts
                .get('<Resource Group name>', '<Storage Account name>')

storage_acc.update(encryption: true)
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

## Create a Disk

Create a Disk in storage account.

```ruby
azure_storage_service.create_disk('<Data Disk Name>', options = {})
```

## Delete a Disk

Delete a Disk from a storage account. Disk must be in unlocked state i.e detached from server(virtual machine) to successfully perform this action.

```ruby
azure_storage_service.delete_disk('<Data Disk Name>')
```

## Create a storage container

Create a storage container in the current storage account.

```ruby
directory = azure_storage_service.directories.create(
  key: '<container name>',
  public: true
)
puts directory.key
```

## List storage containers

List all the storage containers in the current storage accounts.

```ruby
azure_storage_service.directories.all.each do |directory|
  puts directory.key
end
```

## Get the access control level of the storage container

Get the permissions for the specified container. The permissions indicate whether container data may be accessed publicly.

```ruby
directory = azure_storage_service.directories.get('<Container Name>', max_results: 1)
puts directory.acl
```

## Set the access control level of the storage container

Set the permissions for the specified container. The permissions indicate whether container data may be accessed publicly.

```ruby
directory = azure_storage_service.directories.get('<Container Name>', max_results: 1)
directory.acl = 'container'
directory.save(is_create: false)
```

## Delete the storage container

Mark the specified container for deletion. The container and any blobs contained within it are later deleted during garbage collection.

```ruby
directory = azure_storage_service.directories.get('<Container Name>', max_results: 1)
puts directory.destroy
```

## Upload data as a block blob
```ruby
directory = azure_storage_service.directories.get('<Container Name>', max_results: 1)
options = {
  key: '<Blob Name>',
  body: '<Blob Content>'
}
new_block_blob = directory.files.create(options)
puts new_block_blob.inspect
```

## Upload a local file as a block blob
```ruby
directory = azure_storage_service.directories.get('<Container Name>', max_results: 1)
File.open('<File Path>') do |file|
  options = {
    key: '<Blob Name>',
    body: file
  }
  new_block_blob = directory.files.create(options)
  puts new_block_blob.inspect
end
```

## Upload VHD data as a page blob
```ruby
directory = azure_storage_service.directories.get('<Container Name>', max_results: 1)
options = {
  key: '<Blob Name>',
  body: '<Blob Content>',
  blob_type: 'PageBlob'
}
new_page_blob = directory.files.create(options)
puts new_page_blob.inspect
```

## Upload a local VHD as a page blob
```ruby
directory = azure_storage_service.directories.get('<Container Name>', max_results: 1)
File.open('<File Path>') do |file|
  options = {
    key: '<Blob Name>',
    body: file,
    blob_type: 'PageBlob'
  }
  new_page_blob = directory.files.create(options)
  puts new_page_blob.inspect
end
```

## Copy Blob from one container to another
```ruby
directory = azure_storage_service.directories.get('<Source Container Name>', max_results: 1)
copied_blob = directory.files.head('<Source Blob Name>').copy('<Destination Container Name>', '<Destination Blob Name>')
puts copied_blob.inspect
```

## Copy Blob from one uri to self
```ruby
directory = azure_storage_service.directories.get('<Destination Container Name>', max_results: 1)
copied_blob = directory.files.new(key: '<Destination Blob Name>')
copied_blob.copy_from_uri('<Source Blob Uri>')
puts copied_blob.inspect
```

## Download a small blob to a local file
```ruby
directory = azure_storage_service.directories.get('<Container Name>', max_results: 1)
blob = directory.files.get('<Blob Name>')
File.open('<File Path>', 'wb') do |file|
  file.write(blob.body)
end
puts "File Size: #{::File.size <File Path>}"
```

## Download a large blob to a local file
```ruby
directory = azure_storage_service.directories.get('<Container Name>', max_results: 1)
File.open('<File Path>', 'wb') do |file|
  directory.files.get('<Blob Name>') do |chunk, remaining_bytes, total_bytes|
    puts "remaining_bytes: #{remaining_bytes}, total_bytes: #{total_bytes}"
    file.write(chunk)
  end
end
puts "File Size: #{::File.size <File Path>}"
```

## Delete the storage blob

Mark the specified blob for deletion. The blob is later deleted during garbage collection.

```ruby
directory = azure_storage_service.directories.get('<Container Name>', max_results: 1)
blob = directory.files.head('<Blob Name>')
puts blob.destroy
```

### Set storage blob properties

Set the storage blob properties.

```ruby
directory = azure_storage_service.directories.get('<Container Name>', max_results: 1)
blob = directory.files.head('<Blob Name>')
blob.content_language = "English"
blob.content_disposition = "attachment"
blob.save(update_body: false)
```

## Metadata

Metadata allows us to provide descriptive information about specific containers or blobs. This is simply providing name/value pairs of data we want to set on the container or blob.

### Get Blob Metadata

```ruby
directory = azure_storage_service.directories.get('<Container Name>', max_results: 1)
blob = directory.files.head('<Blob Name>')
puts blob.metadata
```

### Set Blob Metadata

```ruby
directory = azure_storage_service.directories.get('<Container Name>', max_results: 1)
blob = directory.files.head('<Blob Name>')
blob.metadata = {
  "Category" => "Images",
  "Resolution" => "High"
}
blob.save(update_body: false)
```

### Get Container Metadata

```ruby
directory = azure_storage_service.directories.get('<Container Name>', max_results: 1)
puts directory.metadata
```

### Set Container Metadata

```ruby
directory = azure_storage_service.directories.get('<Container Name>', max_results: 1)
directory.metadata = {
  "CreatedBy" => "User",
  "SourceMachine" => "Mymachine",
  "category" => "guidance",
  "docType" => "textDocuments"
  }
directory.save(is_create: false)
```

### Create Recovery Vault

Create a new Recovery Vault object

```ruby
azure_storage_service.recovery_vaults.create(
  name: '<vault_name>',
  location: '<location>',
  resource_group: '<resource_group_name>'
```

### Get Recovery Vault

Retrieves a Recovery Vault object

```ruby
recovery_vault = azure_storage_service.recovery_vaults.get(
  'Vault Name',
  'Vault Resource Group'
)
```

### List Recovery Vaults

List the Recovery Vaults in a resource group

```ruby
azure_storage_service.recovery_vaults('Resource Group Name').each do |recovery_vault|
  puts recovery_vault.inspect
end
```

### Enable Backup Protection

Enables backup protection for a virtual machine in the recovery vault. Backup protection for a virtual machine must be enabled before running backup.

```ruby
recovery_vault.enable_backup_protection('Virtual Machine Name', 'Virtual Machine Resource Group')
```

### Disable Backup Protection

Disables backup protection for a virtual machine in the recovery vault.

```ruby
recovery_vault.disable_backup_protection('Virtual Machine Name', 'Virtual Machine Resource Group')
```

### Start Backup

Starts the backup process for a given virtual machine

```ruby
recovery_vault.start_backup('Virtual Machine Name', 'Virtual Machine Resource Group')
```

### Destroy Recovery Vault

Destroys the Recovery Vault

```ruby
recovery_vault.destroy
```

Note that a Recovery Vault must not contain any backup protectable items or tasks running in order for you to delete it. If any item is present, it must be deleted from the portal first before running this command.

## Support and Feedback
Your feedback is appreciated! If you have specific issues with the fog ARM, you should file an issue via Github.




