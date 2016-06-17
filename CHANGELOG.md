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
