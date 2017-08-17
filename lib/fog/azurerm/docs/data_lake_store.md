#Data Lake Store

This document explains how to get started using Azure Data Lake Store Service with Fog.

## Usage

First of all, you need to require the Fog library by executing:

```ruby
require 'fog/azurerm'
```

## Create Connection

Next, create a connection to the Data Lake Store Service:

```ruby
    azure_data_lake_store_service = Fog::DataLakeStore::AzureRM.new(
        tenant_id:       '<Tenantid>',                                                    # Tenant id of Azure Active Directory Application
        client_id:       '<Clientid>',                                                    # Client id of Azure Active Directory Application
        client_secret:   '<ClientSecret>',                                                # Client Secret of Azure Active Directory Application
        subscription_id: '<Subscriptionid>',                                              # Subscription id of an Azure Account
        :environment => '<AzureCloud/AzureChinaCloud/AzureUSGovernment/AzureGermanCloud>' # Azure cloud environment. Default is AzureCloud.
)
```

## Check Store Account Existence

```ruby
azure_data_lake_store_service.data_lake_store_accounts.check_for_data_lake_store_account(<Resource Group name>, <Zone name>)
```

## Create Data Lake Store Account

Create a new Data Lake Store Account

```ruby
    azure_data_lake_store_service.data_lake_store_accounts.create(
        name: '<Store Account Name>',
            location: '<Location>',
            resource_group: '<Resource Group name>',
            type: 'Microsoft.DataLakeStore/accounts',
            encryption_state: '<Encryption State>',
            firewall_state: '<Firewall State>',
            firewall_allow_azure_ips:'<Allow Azure Ips>',
            new_tier: '<Next Month Package>',
            current_tier: '<This Month Package>',
            firewall_rules: [
                {
                    name: 'Rule One',
                    start_ip_address: 'x.x.x.x',
                    end_ip_address: 'x.x.x.x'
                },
                {
                    name: 'Rule Two',
                    start_ip_address: 'x.x.x.x',
                    end_ip_address: 'x.x.x.x'
                }
            ]
 )
```

## List Data Lake Store Accounts

```ruby
    azure_data_lake_store_service.data_lake_store_accounts.each do |account|
        puts "#{account.name}"
        puts "#{account.resource_group}"
    end
```

## Retrieve a single Data Lake Store Account

Get a single record of Data Lake Store Account

```ruby
      account = azure_data_lake_store_service
                          .data_lake_store_accounts
                          .get('<Resource Group name>', '<Store Account name>')
      puts "#{account.name}"
```

## Update Data Lake Store Account

Get Data Lake Store Account object from the get method(described above) and then update that Data Lake Store Account.

```ruby
    account.update(
        firewall_state: '<Firewall State>',
        firewall_allow_azure_ips:'<Allow Azure Ips>',
        new_tier: '<Next Month Package>'
 )
```

## Destroy a single Data Lake Store Account

Get Data Lake Store Account object from the get method(described above) and then destroy that Data Lake Store Account.

```ruby
      account.destroy
```

## Support and Feedback
Your feedback is appreciated! If you have specific issues with the fog ARM, you should file an issue via Github.
