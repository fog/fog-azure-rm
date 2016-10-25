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
        publisher: 'Canonical',                    # Not required if custom image is being used 
        offer: 'UbuntuServer',                     # Not required if custom image is being used
        sku: '14.04.2-LTS',                        # Not required if custom image is being used
        version: 'latest',                         # Not required if custom image is being used
        platform: 'Linux',
        vhd_path: '<Path of VHD>',                 # Optional, if you want to create the VM from a custom image.
        custom_data: 'echo customData',            # Optional, if you want to add custom data in this VM.
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
        publisher: 'MicrosoftWindowsServerEssentials',   # Not required if custom image is being used
        offer: 'WindowsServerEssentials',                # Not required if custom image is being used  
        sku: 'WindowsServerEssentials',                  # Not required if custom image is being used
        version: 'latest',                               # Not required if custom image is being used
        platform: 'Windows',
        vhd_path: '<Path of VHD>',                       # Optional, if you want to create the VM from a custom image.
        custom_data: 'echo customData'                   # Optional, if you want to add custom data in this VM.
    )
```
 
For more information about custom_data; see link: https://msdn.microsoft.com/en-us/library/azure/mt163591.aspx

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
                          .get('<Resource Group name>', 'Server name>')
      puts "#{server.name}"
```

## Attach a Data Disk to Server

Get the server object and attach a Data Disk to it.

```ruby
      server.attach_data_disk('<Disk Name>', <Size in GB>, '<Storage Account Name>')
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

## Create Virtual Machine Extension

Installs an extension to the specified virtual machine.

```ruby
    azure_compute_service.virtual_machine_extensions.create(
        name: <Extension Name>,
        resource_group: <Resource Group>,
        location: <Location>,
        vm_name: <Virtual Machine Name>, # Extension will be installed on this VM
        publisher: <Extension publisher>,
        type: <Extension type>,
        type_handler_version: <Extension version>,
        auto_upgrade_minor_version: <true|false>, # Optional
        settings: {JSON object}, # Format: {"key": "value", "key": {"key": "value"}}
        protected_settings: {JSON object}
    )
```

## Get Extension from Virtual Machine

Retrieves the given extension from the virtual machine

```ruby
    vm_extension = azure_compute_service.virtual_machine_extensions.get(
        '<Resource Group Name>', '<Virtual Machine Name>', '<Extension Name>'
    )
```

## Update Extension

Update the given extension. The attributes that can be modified are
- auto_upgrade_minor_version
- settings
- protected_settings

```ruby
    vm_extension.update(
        auto_upgrade_minor_version: <true|false>,
        settings: {JSON object},
        protected_settings: {JSON object}
    )
```

## Destroy Extension

Destroy the given extension from the virtual machine

```ruby
    vm_extension.destroy
```

## Support and Feedback
Your feedback is appreciated! If you have specific issues with the fog ARM, you should file an issue via Github.
