require 'fog/azurerm'
require 'yaml'

# Unmanaged Availability Set Integration Test using RSpec

describe 'Integration Testing of Un-Managed Availability Set' do
  before :all do
    azure_credentials = YAML.load_file(File.expand_path('credentials/azure.yml', __dir__))

    @resource = Fog::Resources::AzureRM.new(
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

    @resource_group_name       = 'TestRG-AS-U'
    @location = 'eastus'
    @unmanaged_as_name_default = 'ASUnmanagedDefault'
    @unmanaged_as_name_custom  = 'ASUnmanagedCustom'
    @managed_as_name_default   = 'ASManagedDefault'
    @managed_as_name_custom    = 'ASManagedCustom'

    @resource_group = @resource.resource_groups.create(
      name: @resource_group_name,
      location: @location
    )
  end

  describe 'Check Existence' do
    before :all do
      @as_ud_exists = @compute.availability_sets.check_availability_set_exists(@resource_group_name, @unmanaged_as_name_default)
      @as_uc_exists = @compute.availability_sets.check_availability_set_exists(@resource_group_name, @unmanaged_as_name_custom)
    end

    context 'Unmanaged Default Availability Set' do
      it 'should not exist yet' do
        expect(@as_ud_exists).to eq(false)
      end
    end

    context 'Unmanaged Custom Availability Set' do
      it 'should not exist yet' do
        expect(@as_uc_exists).to eq(false)
      end
    end
  end

  describe 'Create' do
    before :all do
      @tags = {
        key1: 'value1',
        key2: 'value2'
      }
    end

    context 'Unmanaged Default Availability Set' do
      before :all do
        @avail_set = @compute.availability_sets.create(
          name: @unmanaged_as_name_default,
          location: @location,
          resource_group: @resource_group_name,
          tags: @tags
        )
      end

      it 'should have name: \'ASUnmanagedDefault\'' do
        expect(@avail_set.name).to eq(@unmanaged_as_name_default)
      end

      it 'should exist in resource group: \'TestRG-AS\'' do
        expect(@avail_set.resource_group).to eq(@resource_group_name)
      end

      it 'should exist in location: \'eastus\'' do
        expect(@avail_set.location).to eq(@location)
      end

      it 'should contain tag values \'value1\' and \'value2\'' do
        expect(@avail_set.tags['key1']).to eq(@tags[:key1])
        expect(@avail_set.tags['key2']).to eq(@tags[:key2])
      end
    end

    context 'Unmanaged Custom Availability Set' do
      before :all do
        @fault_domain_count = 3
        @update_domain_count = 10

        @avail_set = @compute.availability_sets.create(
          name: @unmanaged_as_name_custom,
          location: @location,
          resource_group: @resource_group_name,
          tags: @tags,
          platform_fault_domain_count: @fault_domain_count,
          platform_update_domain_count: @update_domain_count
        )
      end

      it 'should have name: \'ASUnmanagedCustom\'' do
        expect(@avail_set.name).to eq(@unmanaged_as_name_custom)
      end

      it 'should exist in resource group: \'TestRG-AS\'' do
        expect(@avail_set.resource_group).to eq(@resource_group_name)
      end

      it 'should exist in location: \'eastus\'' do
        expect(@avail_set.location).to eq(@location)
      end

      it 'should have fault domain count: 3' do
        expect(@avail_set.platform_fault_domain_count).to eq(@fault_domain_count)
      end

      it 'should have update domain count: 10' do
        expect(@avail_set.platform_update_domain_count).to eq(@update_domain_count)
      end

      it 'should contain tag values \'value1\' and \'value2\'' do
        expect(@avail_set.tags['key1']).to eq(@tags[:key1])
        expect(@avail_set.tags['key2']).to eq(@tags[:key2])
      end
    end
  end

  describe 'Get' do
    context 'Un-Managed Default Availability Set' do
      before :all do
        @avail_set = @compute.availability_sets.get(@resource_group_name, @unmanaged_as_name_default)
      end

      it 'should have name: \'ASUnmanagedDefault\'' do
        expect(@avail_set.name).to eq(@unmanaged_as_name_default)
      end
    end

    context 'Un-Managed Custom Availability Set' do
      before :all do
        @avail_set = @compute.availability_sets.get(@resource_group_name, @unmanaged_as_name_custom)
      end

      it 'should have name: \'ASUnmanagedCustom\'' do
        expect(@avail_set.name).to eq(@unmanaged_as_name_custom)
      end
    end
  end

  describe 'List' do
    before :all do
      @avail_sets = @compute.availability_sets(resource_group: @resource_group_name)
    end

    it 'should not be empty' do
      expect(@avail_sets.length).to_not eq(0)
    end

    it 'should contain availability sets: \'ASUnmanagedDefault\' & \'ASUnmanagedCustom\'' do
      contains_as_default = false
      contains_as_custom = false
      @avail_sets.each do |avail_set|
        contains_as_default = true if avail_set.name == @unmanaged_as_name_default
        contains_as_custom = true if avail_set.name == @unmanaged_as_name_custom
      end
      expect(contains_as_default).to eq(true)
      expect(contains_as_custom).to eq(true)
    end
  end

  describe 'Delete' do
    before 'gets unmanaged availability sets' do
      @avail_set_default = @compute.availability_sets.get(@resource_group_name, @unmanaged_as_name_default)
      @avail_set_custom = @compute.availability_sets.get(@resource_group_name, @unmanaged_as_name_custom)
    end

    it 'should not exist anymore' do
      expect(@avail_set_default.destroy).to eq(true)
      expect(@avail_set_custom.destroy).to eq(true)
      expect(@resource_group.destroy).to eq(true)
    end
  end
end