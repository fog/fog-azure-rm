require 'fog/azurerm'
require 'yaml'

########################################################################################################################
######################                   Services object required by all actions                  ######################
######################                              Keep it Uncommented!                          ######################
########################################################################################################################

azure_credentials = YAML.load_file('credentials/azure.yml')

rs = Fog::Resources::AzureRM.new(
  tenant_id: azure_credentials['tenant_id'],
  client_id: azure_credentials['client_id'],
  client_secret: azure_credentials['client_secret'],
  subscription_id: azure_credentials['subscription_id']
)

storage = Fog::Storage::AzureRM.new(
  tenant_id: azure_credentials['tenant_id'],
  client_id: azure_credentials['client_id'],
  client_secret: azure_credentials['client_secret'],
  subscription_id: azure_credentials['subscription_id'],
  environment: azure_credentials['environment']
)

########################################################################################################################
######################                                 Prerequisites                              ######################
########################################################################################################################

begin
  resource_group = rs.resource_groups.create(
    name: 'TestRG-SA',
    location: LOCATION
  )

  ########################################################################################################################
  ######################                    Check Storage Account name Availability                 ######################
  ########################################################################################################################

  storage_account_avail = storage.storage_accounts.check_name_availability('test-storage')
  puts 'Storage account available' if storage_account_avail
  puts 'Storage account unavailale' unless storage_account_avail

  ########################################################################################################################
  ###############  Create A Standard Storage Account of Replication: LRS (Locally-redundant storage)       ###############
  ########################################################################################################################

  storage_account = storage.storage_accounts.create(
    name: 'fogstandardsalrs',
    location: LOCATION,
    resource_group: 'TestRG-SA'
  )
  puts "Created storage account for standard lrs replication: #{storage_account.name}"

  ########################################################################################################################
  ###############      Create A Standard Storage Account of Replication: GRS (Geo-redundant storage)     #################
  ########################################################################################################################

  storage_account = storage.storage_accounts.create(
    name: 'fogstandardsagrs',
    location: LOCATION,
    resource_group: 'TestRG-SA',
    sku_name: 'Standard',
    replication: 'GRS',
    encryption: true
  )
  puts "Created storage account for standard grs replication: #{storage_account.name}"

  ########################################################################################################################
  ###########   Create A Premium(SSD) Storage Account of its only Replication: LRS (Locally-redundant storage)  ##########
  ########################################################################################################################

  storage_account = storage.storage_accounts.create(
    name: 'fogpremiumsa',
    location: LOCATION,
    resource_group: 'TestRG-SA',
    sku_name: 'Premium',
    replication: 'LRS'
  )
  puts "Created storage account for premium lrs replication: #{storage_account.name}"

  ########################################################################################################################
  ######################                         Get and Update Storage Account                     ######################
  ########################################################################################################################

  premium_storage_account = storage.storage_accounts.get('TestRG-SA', 'fogpremiumsa')
  puts "Get storage account: #{premium_storage_account.name}"
  premium_storage_account.update(encryption: true)
  puts 'Updated encrytion of storage account'

  ########################################################################################################################
  ######################                         Get and Delete Storage Account                     ######################
  ########################################################################################################################

  standard_storage_account = storage.storage_accounts.get('TestRG-SA', 'fogstandardsalrs')
  puts "Deleted storage account for standard lrs replication: #{standard_storage_account.destroy}"
  standard_storage_account = storage.storage_accounts.get('TestRG-SA', 'fogstandardsagrs')
  puts "Deleted storage account for standard grs replication: #{standard_storage_account.destroy}"
  premium_storage_account = storage.storage_accounts.get('TestRG-SA', 'fogpremiumsa')
  puts "Deleted storage account for premium lrs replication: #{premium_storage_account.destroy}"

  ########################################################################################################################
  ######################                                   CleanUp                                  ######################
  ########################################################################################################################

  resource_group = rs.resource_groups.get('TestRG-SA')
  resource_group.destroy
rescue
  puts 'Integration Test for storage account is failing'
  resource_group.destroy unless resource_group.nil?
end
