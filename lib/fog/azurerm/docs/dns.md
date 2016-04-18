#DNS

This document explains how to get started using Azure DNS Service with Fog.

## Require Gem

First of all, you need to require the Fog library by executing:

```ruby
        require 'fog/azurerm'
```

## Create Connection

Next, create a connection to the DNS Service:

```ruby
    azure_dns_service = Fog::DNS::AzureRM.new(
        tenant_id:       '<Tenantid>',           # Tenant id of Azure Active Directory Application
        client_id:       '<Clientid>',           # Client id of Azure Active Directory Application
        client_secret:   '<ClientSecret>',       # Client Secret of Azure Active Directory Application
        subscription_id: '<Subscriptionid>'      # Subscription id of an Azure Account
)
```
## Create Zone

Create a new Zone

```ruby
    azure_dns_service.zones.create(
        name:           '<Zone name>',
        resource_group: '<Resource Group name>'
 )
```
## List Zones

```ruby
    azure_dns_service.zones.each do |zone|
        puts "#{zone.name}"
        puts "#{zone.resource_group}"
    end
```

## Retrieve a single record

Get a single record of Zone

```ruby
      zone = azure_dns_service
                          .zones
                          .get('<Zone name>', '<Resource Group name>')
      puts "#{zone.name}"
```

## Destroy a single record

Get Zone object from the get method(described above) and then destroy that Zone.

```ruby
      zone.destroy
```

## Create Record Set

Create a new Record Set

```ruby
    azure_dns_service.record_sets.create(
        name:           '<Record Set name>',
        resource_group: '<Resource Group name>',
        zone_name:      '<Zone Name>',
        records:        <String array of Records>,
        type:           '<Record Type(A/CNAME)>',
        ttl:            <Time to live(Integer)>
 )
```
## List Record Sets

```ruby
    azure_dns_service.record_sets(
        resource_group: '<Resource Group Name>',
        zone_name:      '<Zone Name>'
    ).each do |record_set|
        puts "#{record_set.name}"
        puts "#{record_set.resource_group}"
    end
```

## Retrieve a single record

Get a single record of Record Set

```ruby
      record_set = azure_dns_service
                      .record_sets(
                           resource_group: '<Resource Group Name>',
                           zone_name:      '<Zone Name>'
                      )
                      .get('<Record Set name>', '<Record Type>')
      puts "#{record_set.name}"
```

## Destroy a single record

Get Record Set object from the get method(described above) and then destroy that Record Set.

```ruby
      record_set.destroy
```

## Support and Feedback
Your feedback is appreciated! If you have specific issues with the fog ARM, you should file an issue via Github.
