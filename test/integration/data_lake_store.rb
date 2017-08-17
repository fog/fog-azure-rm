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

dl = Fog::DataLakeStore::AzureRM.new(
    tenant_id: azure_credentials['tenant_id'],
    client_id: azure_credentials['client_id'],
    client_secret: azure_credentials['client_secret'],
    subscription_id: azure_credentials['subscription_id']
)

########################################################################################################################
######################                                 Prerequisites                              ######################
########################################################################################################################

rs.resource_groups.create(
    name: 'TestRG-DLS',
    location: 'East US 2'
)

########################################################################################################################
######################                        Create Data Lake Store Account                      ######################
########################################################################################################################

dl.data_lake_store_accounts.create(
    name: 'fogtestdls',
    location: 'East US 2',
    resource_group: 'TestRG-DLS',
    type: 'Microsoft.DataLakeStore/accounts',
    encryption_state: 'Enabled',
    firewall_state: 'Enabled',
    firewall_allow_azure_ips:'Enabled',
    new_tier: 'Consumption',
    current_tier: 'Consumption',
    firewall_rules: [
        {
            name: 'one',
            start_ip_address: '116.58.62.100',
            end_ip_address: '116.58.62.110'
        }
    ]
)

########################################################################################################################
######################                      Update Data Lake Store Accounts                       ######################
########################################################################################################################

data_lake = dl.data_lake_store_accounts.get('TestRG-DLS', 'fogtestdls')
data_lake.update(
    firewall_state: 'Disabled',
    firewall_allow_azure_ips: 'Disabled'
)

########################################################################################################################
######################             Get All Data Lake Store Accounts in a Subscription             ######################
########################################################################################################################

dl.data_lake_store_accounts.each do |account|
  puts "Resource Group:#{account.resource_group} name:#{account.name}"
end

########################################################################################################################
######################       Get and Destroy Data Lake Store Account in a Resource Group          ######################
########################################################################################################################

data_lake = dl.data_lake_store_accounts.get('TestRG-DLS', 'fogtestdls')
data_lake.destroy

########################################################################################################################
######################                                   CleanUp                                  ######################
########################################################################################################################

rg = rs.resource_groups.get('TestRG-DLS')
rg.destroy
