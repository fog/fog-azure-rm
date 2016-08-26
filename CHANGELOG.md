## 0.0.5

**Added:**
- Network Service - Added Get request for Public IP

**Changed:**
- Network Service - Updated Public IP to use updated gems
- Network Service - Updated Virtual Network to use updated gems
- Network Service - Updated Subnet to use updated gems
- Network Service - Updated Network Interface to use updated gems
- Network Service - Updated Load Balancer to use updated gems
- Network Service - Updated Application Gateway to use updated gems
- Network Service - Updated Express Route to use updated gems
- Compute Service - Updated Server to use updated gems
- DNS Service - Updated Record Set to use updated gems
- DNS Service - Updated Zone to use updated gems


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
