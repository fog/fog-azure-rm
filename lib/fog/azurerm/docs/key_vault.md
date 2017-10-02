# Key Vault

This document explains how to get started using Azure Key Vault Service with Fog to manage Vault. With this gem you can create/list/delete Vault.

## Usage

First of all, you need to require the Fog library by executing:

```ruby
require 'fog/azurerm'
```
## Create Connection

Next, create a connection to the Key Vault Service:

```ruby
    azure_key_vault_service = Fog::KeyVault::AzureRM.new(
        tenant_id: '<Tenantid>',                  # Tenant id of Azure Active Directory Application
        client_id:    '<Clientid>',               # Client id of Azure Active Directory Application
        client_secret: '<ClientSecret>',          # Client Secret of Azure Active Directory Application
        subscription_id: '<Subscriptionid>'       # Subscription id of an Azure Account
)
```

## Check Vault Existence

```ruby
 azure_key_vault_service.vaults.check_vault_exists(<Resource Group name>, <Vault Name>)
```

## Create Vault

Create a new Vault.

```ruby
    vault = azure_key_vault_service.vaults.create(
        name: '<Vault Name>',
        location: 'eastus',
        resource_group: '<Resource Group name>',
        tenant_id: <Tenantid>,
        sku_family: 'A',
        sku_name: 'standard',
        tags: {
            key: 'value'
        }                       'Optional'
        access_policies: [
                           {
                             tenant_id: <Tenantid>,
                             object_id: <Tenantid>,
                             permissions: {
                               keys: ['all'],
                               secrets: ['all']
                             }
                           }
                         ]

    )
```

## List Vaults

List all vaults in a resource group

```ruby
    vaults = azure_key_vault_service.vaults(resource_group: '<Resource Group Name>')
    vaults.each do |vault|
        puts "#{vault.name}"
    end
```

## Retrieve a single Vault

Get a single record of Vault

```ruby
    vault = azure_key_vault_service
                            .vaults
                            .get('<Resource Group name>', '<Vault Name>')
    puts "#{vault.name}"
```

## Destroy a single Vault

Get a vault object from the get method and then destroy that vault.

```ruby
    vault.destroy
```

## Support and Feedback
Your feedback is highly appreciated! If you have specific issues with the fog ARM, you should file an issue via Github.
