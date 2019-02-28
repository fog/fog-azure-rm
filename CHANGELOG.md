## 0.5.0

**Added**
- Asynchronous creation of Network Interface Card 

## 0.4.9

**Added**
- Current Ruby versions added in .travis.yml for testing
- Asynchronous deletion of Managed Disk added

**Changed**

- List method which handles pagination by default has been updated for Network Security Group.
- .travis.yml updated to handle bundler gem dependency on Ruby 2.3+
- Mocks for Azure::Blobs updated

## 0.4.8

**Added:**
- Added enable_accelerated_networking attribute for NIC

## 0.4.7

**Added:**
- Support added to list resources in a resource group
- Added OS disk id attribute to the 'Compute' model 

## 0.4.6

**Added:**
- Created Custom Fog Exceptions

## 0.4.5

**Changed:**
- Updated dependency of fog-json to (~> 1.0.2)

## 0.4.4

**Fixed:**
- Compute Service - Fixed customData Update Issue

## 0.4.3

**Fixed:**
- Compute Service - Fixed Server Update Scenario

## 0.4.2

**Fixed:**
- Fixed 'raise_azure_exception' method

## 0.4.1

**Fixed:**
- Fixed check existence methods for all resources
- Fixed mime-types dependency issue

## 0.4.0

**Added**
- Support added for custom vm image reference 

## 0.3.9

**Changed**
- Fixed Fog::Storage issue of requiring the 'mime-types' gem

## 0.3.8

**Changed:**
- Updated documentation

**Fixed:**
- Compute Service - Fixed issue with fault/update domain not populating

## 0.3.7

**Fixed:**
- DNS Service - Fixed bug in DNS service

## 0.3.6

**Added:**
- Compute Service - Added support for custom image provisioning with managed disk
- DNS Service - Fog Models for RecordSet Types 'A' and 'CNAME'
- Automated gem publishing on release tagging

**Changed:**
- Loosened dependency on fog-core
- Updated documentation

## 0.3.5

**Added:**
- Compute Service - Added platform update domain and platform fault domain propertied in server model
- Compute Service - Added custom image support for managed VM

**Changed:**
- Compute Service - Changed required arguments for server create method

**Fixed**
- Compute Service - Fixed issue with creating VM with custom image

## 0.3.4

**Added:**
- Compute Service - Added support for custom OS disk size during VM creation
- Compute Service - Added support to attach Managed Disk to VM
- Added resource tagging support on creation

**Removed:**
- Recovery Vault Support

## 0.3.3

**Added:**
- Compute Service - Added support to create availability set with managed disk support

**Changed:**
- Compute Service - Provided option to configure fault and update domain values
- Removed dependency on Rest Client
- azure-storage dependency fixed to 0.11.5.preview (to enable use with ruby 2.0.0)

**Fixed:**
- Unit tests - Storage and Compute

## 0.3.2

**Added:**
- Compute Service - Made remaining server(virtual machine) methods async

## 0.3.1

**Changed:**
- Updated azure storage gem dependency to be flexible

## 0.3.0

**Added**
- Compute Service - Added support for Managed Disk
- Compute Service - Added async method of creating server(virtual machine)

**Changed:**
- Compute Service - Changed create server method to take multiple NICs instead of one
- Updated Azure SDK gems to v0.9.0

**Fixed:**
- Integration tests

## 0.2.7

**Changed:**
- Traffic Manager Service - Updated Traffic Manager Profile create method to receive and create Endpoints with it.

**Fixed:**
- Network Service - Fixed issue in check_virtual_network_exists request

## 0.2.6

**Fixed:**
- Compute Service - storage_account_name attribute issue in server model
- Network Service - Attaching NSG issue while creating NIC

**Removed:**
- Dependency on nokogiri

## 0.2.5

**Fixed:**
- Fog Model enums proper namespacing

## 0.2.4

**Changed:**
- Updated Fog model enums

## 0.2.3

**Added:**
- Added Fog models for Azure SDK Enums

**Changed**
- Compute Service - Made 'password' attribute as optional to create linux virtual machine

## 0.2.2

**Changed:**
- Network Service - Updated NIC for load balancer attributes

## 0.2.1

**Changed:**
- Compute Service - Added new parameter to create virtual machine request

## 0.2.0

**Added:**
- Added support for multiple environments
- Added support to check for resource existence

**Changed:**
- Azure SQL Service - Updated Azure SQL Support to use azure_mgmt_sql gem.
- Azure Network Service - Added list all request in Load Balancer and Virtual Network


## 0.1.2

**Added:**
- Storage Service - Added support for multiple environments


**Changed:**
* Updated fog-azure-rm runtime gem dependencies to latest:
  * azure_mgmt_compute 0.8.0
  * azure_mgmt_network 0.8.0
  * azure_mgmt_resources 0.8.0
  * azure_mgmt_storage 0.8.0
  * azure_mgmt_dns 0.8.0
  * azure_mgmt_traffic_manager 0.8.0
  * azure-storage 0.11.4.preview'
* Refactoring in Azure SQL



## 0.1.1

**Added:**
- Storage Service - Multi-thread support for uploading blobs
- Added support for all Azure locations(Global, China, Gov and Germany) 

**Changed:**
* Updated fog-azure-rm runtime gem dependencies to latest:
  * azure_mgmt_compute 0.7.0
  * azure_mgmt_network 0.7.0
  * azure_mgmt_resources 0.7.0
  * azure_mgmt_storage 0.7.0
  * azure_mgmt_dns 0.7.0
  * azure_mgmt_traffic_manager 0.7.0
  * azure-storage 0.11.3.preview'
* Provided same storage interfaces as other providers (PR: 204)
* Updated Data Disk operations (PR: 220)
* Updated namespaces
* Updated integration scripts

## 0.1.0

**Added:**
- Azure SQL Service - Added support for SQL Server Firewall Rules.
- Azure Recovery Vault - Added support for Azure Recovery Vault.
- Azure Storage Service - Encryption support for storage account and Added support to create new data disk.


## 0.0.9

**Added:**
- Azure SQL Service - Added support for SQL Server, SQL Databases and Data warehouse.
- Updated fog-azure-rm runtime gem dependencies to latest.

**Changed:**
- DNS Service - DNS Service moved from API calls to Azure latest SDK.



## 0.0.8 

**Added:**
- Compute Service - Added support to create virtual machine from a custom image.
- Network Service - Added Network Security Rule.
- Network Service - Added Get Available IP Addresses count in Subnet
- Compute Service - Virtual Machine Extension
- Added Blob count, blob exist, blob compare,blob copy, lease blob, release lease blob, delete blob, set blob properties,
    get blob properties, set blob metadata, get blob metadata, get blob, list blob functionality for storage
- Added get container properties, get container metadata, set container metadata, get container, list container,
    delete container,  Get the access control list of the container


## 0.0.6

**Added:**
- Compute Service - Added Custom data support for creating Virtual Machine.
- Network Service - Added Express Route Circuit Authorization.
- Network Service - Added Virtual Network Gateway Connection support
- Network Service - Added Local Network Gateway
- Traffic Manager - Added support for Update Traffic Manager Profile and Endpoint.

**Changed:**
- Used autoload in place of require to avoid loading time issues
- Used Fog DSL to register services

## 0.0.5

**Added:**
- Network Service - Added Get request for Public IP
- Network Service - Added Express Route Circuit
- Network Service - Added VPN Gateway

**Changed:**
* Updated fog-azure-rm runtime gem dependencies to latest:
  * azure_mgmt_compute 0.5.0
  * azure_mgmt_network 0.5.0 
  * azure_mgmt_resources 0.5.0
  * azure_mgmt_storage 0.5.0 
  * azure_mgmt_traffic_manager 0.5.0
  * rest-client 2.0.0
  * fog-core 1.42.0 
* Traffic Manager Service - Moved Traffic Manager from Network Service to Traffic Manager Service.
* Application Gateway Service - Moved Application Gateway from Network Service to Application Gateway Service.

## 0.0.4

**Added:**
- Storage Service - Added Support for Azure container operations
- Storage Service - Added blob container metadata support
- Storage Service - Added support to get storage access key
- Network Service - Added support for updation methods for Network Security Group
- Network Service - Added support for updation methods for Virtual Network(vnet)
- Network Service - Added support for updation methods for Subnet
- Network Service - Added support for updation methods for Network Interface Card(NIC)
- Compute Service - Added support for azure resource manager templates
- Resource Service - Added support to tag azure resources
- Integration test scripts for all services
- Documentation - Added fog structure information in contribution guide

**Changed:**
- Compute Service - Moved data disk model to storage service and updated unit tests
- Compute Service - Loaded Data Disk model to make it accessible in Server model
- Network Service - Support for internal load balancer and documentation update
- Network Service - Improved subnet and virtual network module
- Network Service - Updated unit test and integration test
- Documentation - Changed delete_data_disk request name to delete_disk

**Fixed:**
- Resolved bugs in server.rb integration file

**Removed:**
- Compute Service - Moved data disk implementation to storage service


## 0.0.3

**Added:**
- Compute Service: Support for Attach Data Disk & Detach Data Disk in Server
- Compute Service: Support for Windows VM in create Server
- Network Service - Application Gateway
- Compute Service- check_vm_status method in Server as per: https://github.com/fog/fog-azure-rm/issues/38
- Badges in Readme.md file

**Fixed:**
- Code Climate Issues
- Rubocop Offences
- Compute service - Bug in Sever model as per: https://github.com/fog/fog-azure-rm/issues/36
- Network Service - Bug in Network Interface as per: https://github.com/fog/fog-azure-rm/issues/65

**Removed:**
- Shindo Unit Tests

**Integrated:**
- Code Climate
- Travis CI
- Hound CI
- Gemnasium
- Waffle


## 0.0.2

**Added:**
- Network Service - Network Security Group
- Network Service - Load Balancer
- Network Service - Traffic Manager
- Minitest Unit Tests - DNS Requests
- Response Parser: Compute, Network, DNS, Storage
- Mock class implementation in all services

**Changed:**
- Response related changes in all services
- Network Service - Subnet attributes names
- Code standardization in all services


## 0.0.1

**Fixed:**
- Network Service - Network Interface Card


## 0.0.0

**Added:**
- Shindo Unit Tests - All
- Minitest Unit Tests - Compute, Storage, Network, Resources, DNS Models
- Documentation - All Services 
- Compute Service - Server
- Compute Service - Availability Set
- Network Service - Network Interface
- Network Service - Subnet
- Network Service - Virtual Network
- Network Service - Public IP
- Storage Service - Storage Account
- Resource Service - Resource Manager
- DNS Service - Record Set
- DNS Service - Zone
