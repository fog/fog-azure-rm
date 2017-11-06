# Resources

This document explains how to get started using Azure Resources Service with Fog. With this gem you can create, update, list or delete resource groups.

## Usage

First of all, you need to require the Fog library by executing:

```ruby
require 'fog/azurerm'
```

## Create Connection

Next, create a connection to the Resources Service:

```ruby
fog_resources_service = Fog::Resources::AzureRM.new(
      tenant_id:        '<Tenant Id>',                                                         # Tenant Id of Azure Active Directory Application
      client_id:        '<Client Id>',                                                         # Client Id of Azure Active Directory Application
      client_secret:    '<Client Secret>',                                                     # Client Secret of Azure Active Directory Application
      subscription_id:  '<Subscription Id>',                                                   # Subscription Id of an Azure Account
      environment:      '<AzureCloud/AzureChinaCloud/AzureUSGovernment/AzureGermanCloud>'      # Azure cloud environment. Default is AzureCloud.
)
```

## Check Resource Group Existence

```ruby
fog_resources_service.resource_groups.check_resource_group_exists('<Resource Group Name>')
```

## Create Resource Group

Create a new resource group

```ruby
fog_resources_service.resource_groups.create(
        name:     '<Resource Group name>',
        location: '<Location>',
        tags:     { key1: 'value1', key2: 'value2', keyN: 'valueN' }                        # [Optional]
)
```
## List Resource Groups

```ruby
fog_resources_service.resource_groups.each do |resource_group|
        puts "#{resource_group.name}"
        puts "#{resource_group.location}"
end
```

## Retrieve a single Resource Group

Get a single record of Resource Group

```ruby
resource_group = fog_resources_service
                          .resource_groups
                          .get('<Resource Group Name>')
puts "#{resource_group.name}"
```

## Destroy a single Resource Group

Get resource group object from the get method(described above) and then destroy that resource group.

```ruby
resource_group.destroy
```
## Tagging a Resource

You can tag a Resource as following:

```ruby
fog_resources_service.tag_resource(
        '<Resource Id>',
        '<Tag Key>',
        '<Tag Value>',
        '<API Version>'
)
```

## List Tagged Resources in a Subscription

```ruby
fog_resources_service.azure_resources(tag_name: '<Tag Key>', tag_value: '<Tag Value>').each do |resource|
        puts "#{resource.name}"
        puts "#{resource.location}"
        puts "#{resource.type}"        
end
```
OR
```ruby
fog_resources_service.azure_resources(tag_name: '<Tag Key>').each do |resource|
        puts "#{resource.name}"
        puts "#{resource.location}"
        puts "#{resource.type}"        
end
```
## Retrieve a single Resource

Get a single record of Tagged Resources

```ruby
resource = fog_resources_service
                          .azure_resources(tag_name: '<Tag Key>')
                          .get('<Resource Id>')
puts "#{resource.name}"
```
## Remove tag from a Resource

Remove tag from a resource as following:

```ruby
fog_resources_service.delete_resource_tag(
        '<Resource Id>',
        '<Tag Key>',
        '<Tag Value>',
        '<API Version>'
)
```

## Check Resource Existence

```ruby
fog_resources_service.azure_resources.check_azure_resource_exists('<Resource Id>', '<API Version>')
```

## Check Deployment Existence

```ruby
fog_resources_service.deployments.check_deployment_exists('<Resource Group Name>', '<Deployment Name>')
```

## Create Deployment

Create a Deployment

```ruby
fog_resources_service.deployments.create(
        name:            '<Deployment Name>',
        resource_group:  '<Resource Group Name>',
        template_link:   '<Template Link>',
        parameters_link: '<Parameters Link>'
)
```
## List Deployments

List Deployments in a resource group

```ruby
fog_resources_service.deployments(resource_group: '<Resource Group Name>').each do |deployment|
        puts "#{deployment.name}"
end
```

## Retrieve a single Deployment

Get a single record of Deployment

```ruby
deployment = fog_resources_service
                       .deployments
                       .get('<Resource Group Name>', '<Deployment Name>')
puts "#{deployment.name}"
```

## Destroy a single Deployment

Get Deployment object from the get method(described above) and then destroy that Deployment.

```ruby
deployment.destroy
```

## Support and Feedback
Your feedback is appreciated! If you have specific issues with the fog ARM, you should file an issue via Github.
