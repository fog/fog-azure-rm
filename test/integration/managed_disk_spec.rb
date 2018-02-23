require 'fog/azurerm'
require 'yaml'

# Managed Disk Integration Test using RSpec

describe 'Integration Testing of Managed Disk' do
  before :all do
    azure_credentials = YAML.load_file(File.expand_path('credentials/azure.yml', __dir__))

    @rs = Fog::Resources::AzureRM.new(
      tenant_id: azure_credentials['tenant_id'],
      client_id: azure_credentials['client_id'],
      client_secret: azure_credentials['client_secret'],
      subscription_id: azure_credentials['subscription_id']
    )

    @compute = Fog::Compute::AzureRM.new(
      tenant_id: azure_credentials['tenant_id'],
      client_id: azure_credentials['client_id'],
      client_secret: azure_credentials['client_secret'],
      subscription_id: azure_credentials['subscription_id'],
      environment: azure_credentials['environment']
    )

    time                 = current_time
    @resource_group_name = 'TestRG-MD'
    @disk_name           = 'MD'
    @location = 'eastus'
    @tags = { key1: 'value1', key2: 'value2' }
    @disk_account_type = 'Premium_LRS'
    @disk_size_gb = 1023
    @disk_create_option = 'Empty'

    @resource_group = @rs.resource_groups.create(
      name: @resource_group_name,
      location: @location
    )
  end

  describe 'Check Existence' do
    before 'checks existence of managed disk' do
      @md_exists = @compute.managed_disks.check_managed_disk_exists(@resource_group_name, @disk_name)
    end

    it 'should not exist yet' do
      expect(@md_exists).to eq(false)
    end
  end

  describe 'Create' do
    before :all do
      @managed_disk = @compute.managed_disks.create(
        name: @disk_name,
        location: @location,
        resource_group_name: @resource_group_name,
        tags: @tags,
        account_type: @disk_account_type,
        disk_size_gb: @disk_size_gb,
        creation_data: {
          create_option: @disk_create_option
        }
      )
    end

    it 'should have name: \'MD\'' do
      expect(@managed_disk.name).to eq(@disk_name)
    end

    it 'should exist in location: \'eastus\'' do
      expect(@managed_disk.location).to eq(@location)
    end

    it 'should exist in resource group: \'TestRG-MD\'' do
      expect(@managed_disk.resource_group_name).to eq(@resource_group_name)
    end

    it 'should contain tag values \'value1\' and \'value2\'' do
      expect(@managed_disk.tags['key1']).to eq(@tags[:key1])
      expect(@managed_disk.tags['key2']).to eq(@tags[:key2])
    end

    it 'should have account type: \'Premium LRS\'' do
      expect(@managed_disk.account_type).to eq(@disk_account_type)
    end

    it 'should have disk size: 1023' do
      expect(@managed_disk.disk_size_gb).to eq(@disk_size_gb)
    end

    it 'should have creation option: \'Empty\'' do
      expect(@managed_disk.creation_data.create_option).to eq(@disk_create_option)
    end
  end

  describe 'Get' do
    before 'gets managed disk' do
      @managed_disk = @compute.managed_disks.get(@resource_group_name, @disk_name)
    end

    it 'should have name: \'MD\'' do
      expect(@managed_disk.name).to eq(@disk_name)
    end
  end

  describe 'Grant Access' do
    before 'grants access to managed disk' do
      @access_type = 'Read'
      @access_duration_in_secs = 1000
      @access_sas = @compute.managed_disks.grant_access(@resource_group_name, @disk_name, @access_type, @access_duration_in_secs)
    end

    it 'should have granted READ access' do
      expect(@access_sas).not_to eq(nil)
    end
  end

  describe 'Revoke Access' do
    before 'revokes access to the managed disk' do
      @response = @compute.managed_disks.revoke_access(@resource_group_name, @disk_name)
    end

    it 'should have revoked access' do
      expect(@response).not_to eq(nil)
    end
  end

  describe 'List' do
    context 'Within a Subscription' do
      before 'lists all managed disks within a subscription' do
        @managed_disks_in_subscription = @compute.managed_disks
      end

      it 'should not be nil' do
        expect(@managed_disks_in_subscription.length).not_to eq(0)
      end
    end

    context 'Within the Resouce Group' do
      before 'lists all managed disks in the resource group' do
        @managed_disks_list = @compute.managed_disks(resource_group: @resource_group_name)
      end

      it 'should contain managed disk \'MD\'' do
        contains_md = false
          @managed_disks_list.each do |managed_disk|
          contains_md = true if managed_disk.name == @disk_name
        end
        expect(contains_md).to eq(true)
      end
    end
  end

  describe 'Delete' do
    before 'gets managed disk' do
      @managed_disk = @compute.managed_disks.get(@resource_group_name, @disk_name)
    end

    it 'should not exist anymore' do
      expect(@managed_disk.destroy).to eq(true)
      expect(@resource_group.destroy).to eq(true)
    end
  end
end
