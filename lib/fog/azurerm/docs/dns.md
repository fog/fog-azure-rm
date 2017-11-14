# DNS

This document explains how to get started using Azure DNS Service with Fog.

## Usage

First of all, you need to require the Fog library by executing:

```ruby
require 'fog/azurerm'
```

## Create Connection

Next, create a connection to the DNS Service:

```ruby
fog_dns_service = Fog::DNS::AzureRM.new(
        tenant_id:       '<Tenant Id>',                                                           # Tenant Id of Azure Active Directory Application
        client_id:       '<Client Id>',                                                           # Client Id of Azure Active Directory Application
        client_secret:   '<Client Secret>',                                                       # Client Secret of Azure Active Directory Application
        subscription_id: '<Subscription Id>',                                                     # Subscription Id of an Azure Account
        environment:     '<AzureCloud/AzureChinaCloud/AzureUSGovernment/AzureGermanCloud>'        # Azure cloud environment. Default is AzureCloud.
)
```

## Check Zone Existence

```ruby
fog_dns_service.zones.check_zone_exists('<Resource Group Name>', '<Zone Name>')
```

## Create Zone

Create a new Zone

```ruby
fog_dns_service.zones.create(
        name: '<Zone Name>',
        resource_group: '<Resource Group Name>',
        tags: {
            key: 'value'                    # [Optional]
        }
)
```
## List Zones

```ruby
fog_dns_service.zones.each do |zone|
     puts "#{zone.name}"
     puts "#{zone.resource_group}"
end
```

## Retrieve a single Zone

Get a single record of Zone

```ruby
zone = fog_dns_service
             .zones
             .get('<Resource Group Name>', '<Zone Name>')
puts "#{zone.name}"
```

## Destroy a single Zone

Get Zone object from the get method(described above) and then destroy that Zone.

```ruby
zone.destroy
```

## Check Record Set Existence

```ruby
fog_dns_service.record_sets.check_record_set_exists('<Resource Group Name>', '<Record Set Name>', '<Zone Name>', '<Record Type(A/CNAME)>')
```

## Create Record Set

Create a new Record Set

```ruby
fog_dns_service.record_sets.create(
        name:           '<Record Set Name>',
        resource_group: '<Resource Group Name>',
        zone_name:      '<Zone Name>',
        records:        '<String Array of Records>',
        type:           '<Record Type (A/CNAME)>',
        ttl:            <TTL>
)
```

## List Record Sets

```ruby
fog_dns_service.record_sets(
        resource_group: '<Resource Group Name>',
        zone_name:      '<Zone Name>'
      ).each do |record_set|
        puts "#{record_set.name}"
        puts "#{record_set.resource_group}"
end
```

## Retrieve a single Record Set

Get a single record of Record Set

```ruby
record_set = fog_dns_service
                  .record_sets
                  .get('<Resource Group Name>', '<Record Set Name>', '<Zone Name>', '<Record Type>')
puts "#{record_set.name}"
```

## Update TTL

Get an object of record set and then update TTL 

```ruby
record_set.update_ttl(ttl: <Time to live (Integer)>)
```

## Add/Remove Record set in Existing Record sets

Add a record by giving the value of record set in the form of string.

```ruby
record_set.add_a_type_record('<Record>')
```

Remove record from existing records by giving its value in the form of string.

```ruby
record_set.remove_a_type_record('<Record>')
```

## Destroy a single Record Set

Get Record Set object from the get method(described above) and then destroy that Record Set.

```ruby
record_set.destroy
```

## Support and Feedback
Your feedback is appreciated! If you have specific issues with the fog ARM, you should file an issue via Github.