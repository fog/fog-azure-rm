# Fog::AzureRM

Module for the 'fog' gem to support Windows Azure Resource Manager

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fog-azurerm'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fog-azurerm
    
    
## Usage

You can use this gem against the Microsoft Azure Resource Manager Services in the cloud. Of course, to use the Microsoft Azure Resource Manager Services in the cloud, you need to first [create a Microsoft Azure account](http://www.azure.com/en-us/pricing/free-trial/).


### Setup Connection

The next step to use this gem, is authentication and permissioning. For people unfamilar with Azure this may be one of
the more difficult concepts. For a reference on setting up a service principal from the command line see
[Authenticating a service principal with Azure Resource Manager](http://aka.ms/cli-service-principal) or
[Unattended Authentication](http://aka.ms/auth-unattended). For a more robust explanation of authentication in Azure,
see [Developer’s guide to auth with Azure Resource Manager API](http://aka.ms/arm-auth-dev-guide).

After creating the service principal, you should have three pieces of information, a client id (GUID), client secret
(string) and tenant id (GUID).


### Getting Started Samples

Fog provides implementation of the services for Microsoft Azure Resource Manager. Examples of using Fog in a code for the Resource Manager services are as follows

* #### Compute

  Fog-AzureRM for compute includes implementaion of Virtual Machines and Availability Sets. Readme for the usage of [Compute](fog-azure-rm/lib/fog/azurerm/docs/compute.md) module.

* #### Resources

  Fog-AzureRM for resources includes implementaion of Resource Groups. Readme for the usage of [Resources](fog-azure-rm/lib/fog/azurerm/docs/resources.md) module.

* #### Dns

  Fog-AzureRM for dns includes implementaion of Record sets and Zones. Readme for the usage of [Dns]() module.

* #### Network

  Fog-AzureRM for network includes implementaion of Network Interfaces, Public IPs, Subnets and Virtual Networks. Readme for the usage of [Network]() module.

* #### Storage

  Fog-AzureRM for storage includes implementaion of Storage Accounts. Readme for the usage of [Storage](fog-azure-rm/lib/fog/azurerm/docs/storage.md) module.
  
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request





