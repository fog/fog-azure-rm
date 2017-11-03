# Storage

This document explains how to get started using Azure Storage Service with Fog. With this gem you can create, update, list or delete storage accounts.

## Usage

First of all, you need to require the Fog library by executing:

```ruby
require 'fog/azurerm'
```

## Create Connection

Next, create a connection to the Storage Service:

```ruby
fog_storage_service = Fog::Storage::AzureRM.new(
  tenant_id: '<Tenantid>',                                                          # Tenant id of Azure Active Directory Application
  client_id:    '<Clientid>',                                                       # Client id of Azure Active Directory Application
  client_secret: '<ClientSecret>',                                                  # Client Secret of Azure Active Directory Application
  subscription_id: '<Subscriptionid>',                                              # Subscription id of an Azure Account
  azure_storage_account_name: '<Storage Account Name>',                             # Name of an Azure Storage Account
  azure_storage_access_key: '<Storage Account Key>',                                # Key of an Azure Storage Account
  environment: '<AzureCloud/ AzureChinaCloud/ AzureUSGovernment/ AzureGermanCloud>' # Azure cloud environment. Default is AzureCloud.
)
```

If you only want to manage the storage accounts, you can create the connection without the storage account information:

```ruby
fog_storage_service = Fog::Storage::AzureRM.new(
  tenant_id:        '<Tenantid>',                                                         # Tenant id of Azure Active Directory Application
  client_id:        '<Clientid>',                                                         # Client id of Azure Active Directory Application
  client_secret:    '<ClientSecret>',                                                     # Client Secret of Azure Active Directory Application
  subscription_id:  '<Subscriptionid>',                                                   # Subscription id of an Azure Account
  environment:      '<AzureCloud/ AzureChinaCloud/ AzureUSGovernment/ AzureGermanCloud>'  # Azure cloud environment. Default is AzureCloud.
)
```

If you only want to manage the storage data, you can create the connection without the Azure subscription information:

```ruby
fog_storage_service = Fog::Storage::AzureRM.new(
  azure_storage_account_name:   '<Storage Account Name>',                                             # Name of an Azure Storage Account
  azure_storage_access_key:     '<Storage Account Key>',                                              # Key of an Azure Storage Account
  environment:                  '<AzureCloud/ AzureChinaCloud/ AzureUSGovernment/ AzureGermanCloud>'  # Azure cloud environment. Default is AzureCloud.
)
```

## Check Name Availability 

This operation checks that account name is valid and is not already in use. _Storage Account Type_ is an optional parameter

```ruby
fog_storage_service.storage_accounts.check_name_availability('<Storage Account Name>', '<Storage Account Type>')
```

## Check Storage Account Existence

```ruby
fog_storage_service.storage_accounts.check_storage_account_exists('<Resource Group Name>', '<Storage Account Name>')
```

## Create Storage Account

Create a new storage account. Replication attribute for Standard and Premium account types are as follows 

##### Standard 

1. LRS (Standard Locally-redundant storage)
2. ZRS (Standard Zone-redundant storage)
3. GRS (Standard Geo-redundant storage)
4. RAGRS (Standard Read access geo-redundant storage)

##### Premium
1. LRS (Premium Locally-redundant storage)

```ruby
fog_storage_service.storage_accounts.create(
  name:           '<Storage Account name>',
  location:       '<Location>',
  resource_group: '<Resource Group Name>',
  account_type:   '<Standard/ Premium>',                                   # [Optional] Default value 'Standard'. Allowed values can only be Standard or Premium
  replication:    '<Replication Type>',                                    # [Optional] Default value 'LRS'
  encryption:     <True/ False>,                                           # [Optional] Enables encryption. Default is false.
  tags:           { key1: 'value1', key2: 'value2', keyN: 'valueN' }       # [Optional]
)
```
Premium Storage account store data on solid state drives (SSDs). For more details on standard and premium storage accounts, see [Introduction to Microsoft Azure Storage](https://azure.microsoft.com/en-us/documentation/articles/storage-introduction/) and [Premium Storage: High-Performance Storage for Azure Virtual Machine Workloads](https://azure.microsoft.com/en-us/documentation/articles/storage-premium-storage/).

## List storage accounts

##### List storage accounts in a subscription

```ruby
fog_storage_service.storage_accounts.each do |storage_acc|
  puts "#{storage_acc.name}"
  puts "#{storage_acc.location}"
end
```
##### List storage accounts in a resource group

```ruby
storage_accounts  = fog_storage_service.storage_accounts(resource_group: '<Resource Group Name>')
storage_accounts.each do |storage_acc|
  puts "#{storage_acc.name}"
  puts "#{storage_acc.location}"
end
```

## Retrieve a single Storage Account

Get a single record of Storage Account

```ruby
storage_acc = fog_storage_service
                .storage_accounts
                .get('<Resource Group Name>', '<Storage Account Name>')
puts "#{storage_acc.name}"
```

## Enable encryption on Storage Account

Get a single record of Storage Account and enable encryption on that Storage Account

```ruby
storage_acc = fog_storage_service
                .storage_accounts
                .get('<Resource Group Name>', '<Storage Account Name>')

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

Create a Disk in storage account. _disk_size_in_gb_ must be an integer and the range is [1, 1023].
By default the disk will be created in the container 'vhds'. You can specify other container by set options[:container_name].

```ruby
fog_storage_service.create_disk('<Data Disk Name>', disk_size_in_gb, options = {})
```

## Delete a Disk

Delete a Disk from a storage account. Disk must be in unlocked state i.e detached from server (virtual machine) to successfully perform this action.
By default the disk will be deleted from the container 'vhds'. You can specify other container by set options[:container_name].

```ruby
fog_storage_service.delete_disk('<Data Disk Name>', options = {})
```

## Check Storage Container Existence

```ruby
fog_storage_service.directories.check_container_exists('<Container Name>')
```

## Create a storage container

Create a storage container in the current storage account.

```ruby
directory = fog_storage_service.directories.create(
   key: '<Container Name>',
   public: <True/ False>
)
puts directory.key
```

## List storage containers

List all the storage containers in the current storage accounts.

```ruby
fog_storage_service.directories.each do |directory|
  puts directory.key
end
```

## Get the access control level of the storage container

Get the permissions for the specified container. The permissions indicate whether container data may be accessed publicly.

```ruby
directory = fog_storage_service.directories.get('<Container Name>', max_keys: <Maximum No. Of Keys Value>)
puts directory.acl
```

## Set the access control level of the storage container

Set the permissions for the specified container. The permissions indicate whether container data may be accessed publicly. The container permissions provide the following options for managing container access:

  - ###### Container

    Full public read access. Container and blob data can be read via anonymous request. Clients can enumerate blobs within the container via anonymous request, but cannot enumerate containers within the storage account.

  - ###### Blob

    Public read access for blobs only. Blob data within this container can be read via anonymous request, but container data is not available. Clients cannot enumerate blobs within the container via anonymous request.

  - ###### Nil

    No public read access. Container and blob data can be read by the account owner only.

```ruby
directory = fog_storage_service.directories.get('<Container Name>', max_keys: <Maximum No. Of Keys Value>)
directory.acl = '<Container Name>'
directory.save(is_create: <True/ False>)
```

## Delete the storage container

Mark the specified container for deletion. The container and any blobs contained within it are later deleted during garbage collection.

```ruby
directory = fog_storage_service.directories.get('<Container Name>', max_keys: <Maximum No. Of Keys Value>)
puts directory.destroy
```

## Upload data as a block blob
```ruby
directory = fog_storage_service.directories.get('<Container Name>', max_keys: <Maximum No. Of Keys Value>)
options = {
  key: '<Blob Name>',
  body: '<Blob Content>'
}
new_block_blob = directory.files.create(options)
puts new_block_blob.inspect
```

## Upload a local file as a block blob
```ruby
directory = fog_storage_service.directories.get('<Container Name>', max_keys: <Maximum No. Of Keys Value>)
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
directory = fog_storage_service.directories.get('<Container Name>', max_keys: <Maximum No. Of Keys Value>)
options = {
  key: '<Blob Name>',
  body: '<Blob Content>',
  blob_type: '<Blob Type>'
}
new_page_blob = directory.files.create(options)
puts new_page_blob.inspect
```

## Upload a local VHD as a page blob
```ruby
directory = fog_storage_service.directories.get('<Container Name>', max_keys: <Maximum No. Of Keys Value>)
File.open('<File Path>') do |file|
  options = {
    key: '<Blob Name>',
    body: file,
    blob_type: '<Blob Type>'
  }
  new_page_blob = directory.files.create(options)
  puts new_page_blob.inspect
end
```

## Copy Blob from one container to another
```ruby
directory = fog_storage_service.directories.get('<Source Container Name>', max_keys: <Maximum No. Of Keys Value>)
copied_blob = directory.files.head('<Source Blob Name>').copy('<Destination Container Name>', '<Destination Blob Name>')
puts copied_blob.inspect
```

## Copy Blob from one uri to self
```ruby
directory = fog_storage_service.directories.get('<Destination Container Name>', max_keys: <Maximum No. Of Keys Value>)
copied_blob = directory.files.new(key: '<Destination Blob Name>')
copied_blob.copy_from_uri('<Source Blob Uri>')
puts copied_blob.inspect
```

## Download a small blob to a local file
```ruby
directory = fog_storage_service.directories.get('<Container Name>', max_keys: <Maximum No. Of Keys Value>)
blob = directory.files.get('<Blob Name>')
File.open('<File Path>', 'wb') do |file|
  file.write(blob.body)
end
puts "File Size: #{::File.size <File Path>}"
```

## Download a large blob to a local file
```ruby
directory = fog_storage_service.directories.get('<Container Name>', max_keys: <Maximum No. Of Keys Value>)
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
directory = fog_storage_service.directories.get('<Container Name>', max_keys: <Maximum No. Of Keys Value>)
blob = directory.files.head('<Blob Name>')
puts blob.destroy
```

## Set storage blob properties

Set the storage blob properties.

```ruby
directory = fog_storage_service.directories.get('<Container Name>', max_keys: <Maximum No. Of Keys Value>)
blob = directory.files.head('<Blob Name>')
blob.content_language = '<Language>'
blob.content_disposition = '<Content Disposition Type>'
blob.save(update_body: <True/ False>)
```

## Metadata

Metadata allows us to provide descriptive information about specific containers or blobs. This is simply providing name/value pairs of data we want to set on the container or blob.

### Get Blob Metadata

```ruby
directory = fog_storage_service.directories.get('<Container Name>', max_keys: <Maximum No. Of Keys Value>)
blob = directory.files.head('<Blob Name>')
puts blob.metadata
```

### Set Blob Metadata

```ruby
directory = fog_storage_service.directories.get('<Container Name>', max_keys: <Maximum No. Of Keys Value>)
blob = directory.files.head('<Blob Name>')
blob.metadata = {
  Category: '<Category Value>',
  Resolution: '<Resolution Value>'
}
blob.save(update_body: <True/ False>)
```

### Get Container Metadata

```ruby
directory = fog_storage_service.directories.get('<Container Name>', max_keys: <Maximum No. Of Keys Value>)
puts directory.metadata
```

### Set Container Metadata

```ruby
directory = fog_storage_service.directories.get('<Container Name>', max_keys: <Maximum No. Of Keys Value>)
directory.metadata = {
  CreatedBy: '<Username>',
  SourceMachine: '<Machine Name>',
  category: '<Category Value>',
  docType: '<Document Type>'
}
directory.save(is_create: <True/ False>)
```

## Support and Feedback
Your feedback is appreciated! If you have specific issues with the fog ARM, you should file an issue via Github.




