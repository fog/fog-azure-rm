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
  subscription_id: azure_credentials['subscription_id'],
  environment: azure_credentials['environment']
)

compute = Fog::Compute::AzureRM.new(
  tenant_id: azure_credentials['tenant_id'],
  client_id: azure_credentials['client_id'],
  client_secret: azure_credentials['client_secret'],
  subscription_id: azure_credentials['subscription_id'],
  environment: azure_credentials['environment']
)

########################################################################################################################
######################                               Resource names                                #####################
########################################################################################################################

time = current_time
resource_group_name = "AS-RG-#{time}"
default_avail_set_name = "AS#{time}asetdefault"
custom_avail_set_name = "AS#{time}asetcustom"
aligned_availability_set_name = "AS#{time}asetunique-Aligned"

########################################################################################################################
######################                                 Prerequisites                              ######################
########################################################################################################################

begin
  puts 'Running integration test for availability set...'

  puts "Create resource group (#{resource_group_name}):"
  resource_group = rs.resource_groups.create(
    name: resource_group_name,
    location: LOCATION
  )
  puts "Created resource group! [#{resource_group.name}]"

  ########################################################################################################################
  ######################                            Check for Availability set                      ######################
  ########################################################################################################################

  flag = compute.availability_sets.check_availability_set_exists(resource_group_name, default_avail_set_name)
  puts "Availability set (#{default_avail_set_name}) doesn't exist." unless flag

  flag = compute.availability_sets.check_availability_set_exists(resource_group_name, custom_avail_set_name)
  puts "Availability set (#{custom_avail_set_name}) doesn't exist." unless flag

  flag = compute.availability_sets.check_availability_set_exists(resource_group_name, aligned_availability_set_name)
  puts "Availability set doesn't exist." unless flag

  ########################################################################################################################
  ######################                         Create Availability Set (Default)                  ######################
  ########################################################################################################################

  puts "Create availability set (#{default_avail_set_name}):"
  avail_set = compute.availability_sets.create(
    name: default_avail_set_name,
    location: LOCATION,
    resource_group: resource_group_name
  )
  name = avail_set.name
  fault_domains = avail_set.platform_fault_domain_count
  update_domains = avail_set.platform_update_domain_count
  puts "Created availability set! [ name: '#{name}' => { fd: #{fault_domains}, ud: #{update_domains} } ]"

  ########################################################################################################################
  ######################                         Create Availability Set (Custom)                   ######################
  ########################################################################################################################

  puts "Create availability set (#{custom_avail_set_name}):"
  avail_set = compute.availability_sets.create(
    name: custom_avail_set_name,
    location: LOCATION,
    resource_group: resource_group_name,
    platform_fault_domain_count: 3,
    platform_update_domain_count: 10
  )
  name = avail_set.name
  fault_domains = avail_set.platform_fault_domain_count
  update_domains = avail_set.platform_update_domain_count
  puts "Created availability set! [ name: '#{name}' => { fd: #{fault_domains}, ud: #{update_domains} } ]"

  ########################################################################################################################
  ######################                         Create Managed Availability Set                    ######################
  ########################################################################################################################

  aligned_avail_set = compute.availability_sets.create(
    name: aligned_availability_set_name,
    location: LOCATION,
    resource_group: resource_group_name,
    is_managed: true
  )
  puts "Created managed availability set! [#{aligned_avail_set.name}]"

  ########################################################################################################################
  ######################                       List Availability Sets                               ######################
  ########################################################################################################################

  puts 'List availability sets:'
  compute.availability_sets(resource_group: resource_group_name).each do |availability_set|
    puts availability_set.name
  end

  ########################################################################################################################
  ######################                       Get and Delete Availability Set                      ######################
  ########################################################################################################################

  puts "Get and delete availability sets ('#{default_avail_set_name}' and '#{custom_avail_set_name}'):"

  avail_set = compute.availability_sets.get(resource_group_name, default_avail_set_name)
  puts "Get availability set: #{avail_set.name}"
  puts "Deleted availability set: #{avail_set.destroy}"

  avail_set = compute.availability_sets.get(resource_group_name, custom_avail_set_name)
  puts "Get availability set: #{avail_set.name}"
  puts "Deleted availability set: #{avail_set.destroy}"

  avail_set = compute.availability_sets.get(resource_group_name, aligned_availability_set_name)
  puts "Get availability set: #{avail_set.name}"
  puts "Deleted availability set: #{avail_set.destroy}"

  ########################################################################################################################
  ######################                                   CleanUp                                  ######################
  ########################################################################################################################

  rg = rs.resource_groups.get(resource_group_name)
  rg.destroy
  puts 'Integration test for availability set ran successfully!'
rescue
  puts 'Integration Test for availability set is failing!!!'
  resource_group.destroy unless resource_group.nil?
end
