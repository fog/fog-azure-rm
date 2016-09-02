# Compute

This document explains how to get started using Azure Compute Service with Fog. With this gem you can create/update/list/delete availability sets and virtual machines.

## Usage 

First of all, you need to require the Fog library by executing:

```ruby
require 'fog/azurerm'
```

## Create Connection

Next, create a connection to the Compute Service:

```ruby
    azure_compute_service = Fog::Compute.new(
        provider: 'AzureRM',
        tenant_id: '<Tenantid>',                  # Tenant id of Azure Active Directory Application
        client_id:    '<Clientid>',               # Client id of Azure Active Directory Application
        client_secret: '<ClientSecret>',          # Client Secret of Azure Active Directory Application
        subscription_id: '<Subscriptionid>'       # Subscription id of an Azure Account
)
```

## Create Server

Create a new linux server

```ruby
    azure_compute_service.servers.create(
        name: '<VM Name>',
        location: 'West US',
        resource_group: '<Resource Group Name>',
        vm_size: 'Basic_A0',
        storage_account_name: '<Storage Account Name>',
        username: '<Username for VM>',
        password: '<Password for VM>',
        disable_password_authentication: false,
        network_interface_card_id: '/subscriptions/{Subscription-Id}/resourceGroups/{Resource-Group-Name}/providers/Microsoft.Network/networkInterfaces/{Network-Interface-Id}',
        publisher: 'Canonical',
        offer: 'UbuntuServer',
        sku: '14.04.2-LTS',
        version: 'latest',
        platform: 'Linux'
    )
```
Create a new windows server

```ruby
    azure_compute_service.servers.create(
        name: '<VM Name>',
        location: 'West US',
        resource_group: '<Resource Group Name>',
        vm_size: 'Basic_A0',
        storage_account_name: '<Storage Account Name>',
        username: '<Username for VM>',
        password: '<Password for VM>',
        disable_password_authentication: false,
        network_interface_card_id: '/subscriptions/{Subscription-Id}/resourceGroups/{Resource-Group-Name}/providers/Microsoft.Network/networkInterfaces/{Network-Interface-Id}',
        publisher: 'MicrosoftWindowsServerEssentials',
        offer: 'WindowsServerEssentials',
        sku: 'WindowsServerEssentials',
        version: 'latest',
        platform: 'Windows'
    )
```

## List Servers

List servers in a resource group

```ruby
    servers  = azure_compute_service.servers(resource_group: '<Resource Group name>')
    servers.each do |server|
        puts "#{server.name}"
        puts "#{server.location}"
    end
```

## Retrieve a single Server

Get a single record of Server

```ruby
      server = azure_compute_service
                          .servers(resource_group: '<Resource Group name>')
                          .get('Server name>')
      puts "#{server.name}"
```

## Attach a Data Disk to Server

Get the server object and attach a Data Disk to it.

```ruby
      server.attach_data_disk('<Disk Name>', <Size in GB>, '<Storage Account Name>)
```

## Detach a Data Disk from Server

Get the server object and detach a Data Disk from it.

```ruby
      server.detach_data_disk('<Disk Name>')
```

## Get a Server's status

Check the status of a Server

```ruby 
      status = azure_compute_service
                          .servers
                          .get('<Resource Group name>', '<Server name>')
                          .vm_status
      puts status
```

## Destroy a single Server

Get a server object from the get method(described above) and then destroy that server.

```ruby
      server.destroy
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

## Retrieve a single Availability Set

Get a single record of Availability Set

```ruby
      availability_set = azure_compute_service
                          .availability_sets
                          .get('<Resource Group name>','<Availability Set name>')
        puts "#{availability_set.name}"
```

## Destroy a single Availability Set

Get an availability set object from the get method and then destroy that availability set.

```ruby
      availability_set.destroy
```

## Support and Feedback
Your feedback is appreciated! If you have specific issues with the fog ARM, you should file an issue via Github.
