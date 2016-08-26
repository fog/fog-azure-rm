# Traffic Manager

This document explains how to get started using Azure Traffic Manager Service with Fog. With this gem you can create/update/list/delete Traffic Manager Profiles and End Points.

## Usage

First of all, you need to require the Fog library by executing:

```ruby
require 'fog/azurerm'
```
## Create Connection

Next, create a connection to the Traffic Manager Service:

```ruby
    azure_traffic_manager_service = Fog::TrafficManager::AzureRM.new(
        tenant_id: '<Tenantid>',                  # Tenant id of Azure Active Directory Application
        client_id:    '<Clientid>',               # Client id of Azure Active Directory Application
        client_secret: '<ClientSecret>',          # Client Secret of Azure Active Directory Application
        subscription_id: '<Subscriptionid>'       # Subscription id of an Azure Account
)
```

## Create Traffic Manager Profile

Create a new Traffic Manager Profile. The parameter 'traffic_routing_method' can be 'Performance', 'Weighted' or 'Priority'.

```ruby
      profile = azure_traffic_manager_service.traffic_manager_profiles.create(
        name: '<Profile Name>',
        resource_group: '<Resource Group Name>',
        traffic_routing_method: 'Performance',
        relative_name: '<Profile Relative Name>',
        ttl: '30',
        protocol: 'http',
        port: '80',
        path: '/monitorpage.aspx'
      )
```

## List Traffic Manager Profiles

List Traffic Manager Profiles in a resource group

```ruby
    profiles  = azure_traffic_manager_service.traffic_manager_profiles(resource_group: '<Resource Group name>')
    profiles.each do |profile|
      puts "#{profile.name}"
    end
```

## Retrieve a single Traffic Manager Profile

Get a single record of Traffic Manager Profile

```ruby
     profile = azure_traffic_manager_service
               .traffic_manager_profiles
                .get('<Resource Group name>', '<Profile name>')
     puts "#{profile.name}"
```

## Destroy a single Traffic Manager Profile

Get a Traffic Manager Profile object from the get method and then destroy that Traffic Manager Profile.

```ruby
     profile.destroy
```

## Create Traffic Manager Endpoint

Traffic Manager Profile is pre-requisite of Traffic Manager Endpoint. Create a new Traffic Manager Endpoint. The parameter 'type' can be 'externalEndpoints, 'azureEndpoints' or 'nestedEndpoints'.

```ruby
      endpoint = azure_network_service.traffic_manager_end_points.create(
        name: '<Endpoint Name>',
        traffic_manager_profile_name: '<Profile Name>',
        resource_group: '<Resource Group Name>',
        type: 'externalEndpoints',
        target: 'test.com',
        endpoint_location: 'West US'
      )
```

## List Traffic Manager Endpoints

List Traffic Manager Endpoints in a resource group.

```ruby
    endpoints  = azure_traffic_manager_service.traffic_manager_end_points(resource_group: '<Resource Group name>', traffic_manager_profile_name: '<Profile Name>')
    endpoints.each do |endpoint|
      puts "#{endpoint.name}"
    end
```

## Retrieve a single Traffic Manager Endpoint

Get a single Traffic Manager Endpoint.

```ruby
      endpoint = azure_traffic_manager_service
                 .traffic_manager_end_points
                 .get('<Resource Group name>', '<Profile Name>', '<Endpoint name>', '<Endpoint type>')
      puts "#{endpoint.name}"
```

## Destroy a single Traffic Manager Endpoint

Get a Traffic Manager Endpoint object from the get method and then destroy that Traffic Manager Endpoint.

```ruby
     endpoint.destroy
```

## Support and Feedback
Your feedback is highly appreciated! If you have specific issues with the fog ARM, you should file an issue via Github.
