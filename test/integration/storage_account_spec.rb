require 'fog/azurerm'
require 'yaml'

# Storage Account Integration Test using RSpec

describe 'Integration Testing of Storage Account' do
  before :all do
    azure_credentials = YAML.load_file(File.expand_path('credentials/azure.yml', __dir__))

    @resource = Fog::Resources::AzureRM.new(
      tenant_id: azure_credentials['tenant_id'],
      client_id: azure_credentials['client_id'],
      client_secret: azure_credentials['client_secret'],
      subscription_id: azure_credentials['subscription_id']
    )

    @storage = Fog::Storage::AzureRM.new(
      tenant_id: azure_credentials['tenant_id'],
      client_id: azure_credentials['client_id'],
      client_secret: azure_credentials['client_secret'],
      subscription_id: azure_credentials['subscription_id'],
      environment: azure_credentials['environment']
    )

    @location = 'eastus'
    @lrs_sa_name = 'testlrssa'
    @grs_sa_name = 'testgrssa'
    @premium_sa_name = 'testpremiumsa'

    @resource_group = @resource.resource_groups.create(
      name: 'TestRG-SA',
      location: @location
    )
  end

  describe 'Check Name Availability' do
    context 'Standard LRS Storage Account' do
      before 'checks name availability' do
        @is_available = @storage.storage_accounts.check_name_availability(@lrs_sa_name)
      end

      it 'should be available, name: \'testlrssa\'' do
        expect(@is_available).to eq(true)
      end
    end

    context 'Standard GRS Storage Account' do
      before 'checks name availability' do
        @is_available = @storage.storage_accounts.check_name_availability(@grs_sa_name)
      end

      it 'should be available, name: \'testgrssa\'' do
        expect(@is_available).to eq(true)
      end
    end

    context 'Premium LRS Storage Account' do
      before 'checks name availability' do
        @is_available = @storage.storage_accounts.check_name_availability(@premium_sa_name)
      end

      it 'should be available, name: \'testpremiumsa\'' do
        expect(@is_available).to eq(true)
      end
    end
  end

  describe 'Check Existence' do
    context 'Standard LRS Storage Account' do
      before 'checks existence' do
        @sa_exists = @storage.storage_accounts.check_storage_account_exists(@resource_group.name, @lrs_sa_name)
      end

      it 'should not exist yet' do
        expect(@sa_exists).to eq(false)
      end
    end

    context 'Standard GRS Storage Account' do
      before 'checks existence' do
        @sa_exists = @storage.storage_accounts.check_storage_account_exists(@resource_group.name, @grs_sa_name)
      end

      it 'should not exist yet' do
        expect(@sa_exists).to eq(false)
      end
    end

    context 'Premium LRS Storage Account' do
      before 'checks existence' do
        @sa_exists = @storage.storage_accounts.check_storage_account_exists(@resource_group.name, @premium_sa_name)
      end

      it 'should not exist yet' do
        expect(@sa_exists).to eq(false)
      end
    end
  end

  describe 'Create' do
    before :all do
      @tags = { key1: 'value1', key2: 'value2' }
    end

    context 'Standard LRS Storage Account' do
      before :all do
        @storage_account = @storage.storage_accounts.create(
          name: @lrs_sa_name,
          location: @location,
          resource_group: @resource_group.name,
          tags: @tags
        )
      end

      it 'should have name: \'testlrssa\'' do
        expect(@storage_account.name).to eq(@lrs_sa_name)
      end

      it 'should belong to resource group: \'TestRG-SA\'' do
        expect(@storage_account.resource_group).to eq(@resource_group.name)
      end

      it 'should exist in location: \'eastus\'' do
        expect(@storage_account.location).to eq(@location)
      end

      it 'should contain tag values \'value1\' and \'value2\'' do
        expect(@storage_account.tags['key1']).to eq(@tags[:key1])
        expect(@storage_account.tags['key2']).to eq(@tags[:key2])
      end
    end

    context 'Standard GRS Storage Account' do
      before :all do
        @replication = 'GRS'
        @sku_name = Fog::ARM::Storage::Models::SkuTier::Standard

        @storage_account = @storage.storage_accounts.create(
          name: @grs_sa_name,
          location: @location,
          resource_group: @resource_group.name,
          sku_name: @sku_name,
          replication: @replication,
          encryption: true,
          tags: @tags
        )
      end

      it 'should have name: \'testgrssa\'' do
        expect(@storage_account.name).to eq(@grs_sa_name)
      end

      it 'should belong to resource group: \'TestRG-SA\'' do
        expect(@storage_account.resource_group).to eq(@resource_group.name)
      end

      it 'should exist in location: \'eastus\'' do
        expect(@storage_account.location).to eq(@location)
      end

      it 'should have replication: \'GRS\'' do
        expect(@storage_account.replication).to eq(@replication)
      end

      it 'should be encrypted' do
        expect(@storage_account.encryption).to eq(true)
      end

      it 'should have SKU type: \'Standard\'' do
        expect(@storage_account.sku_name).to eq(@sku_name)
      end

      it 'should contain tag values \'value1\' and \'value2\'' do
        expect(@storage_account.tags['key1']).to eq(@tags[:key1])
        expect(@storage_account.tags['key2']).to eq(@tags[:key2])
      end
    end

    context 'Premium LRS Storage Account' do
      before :all do
        @replication = 'LRS'
        @sku_name = Fog::ARM::Storage::Models::SkuTier::Premium

        @storage_account = @storage.storage_accounts.create(
          name: @premium_sa_name,
          location: @location,
          resource_group: @resource_group.name,
          sku_name: @sku_name,
          replication: @replication,
          tags: @tags
        )
      end

      it 'should have name: \'testpremiumsa\'' do
        expect(@storage_account.name).to eq(@premium_sa_name)
      end

      it 'should belong to resource group: \'TestRG-SA\'' do
        expect(@storage_account.resource_group).to eq(@resource_group.name)
      end

      it 'should exist in location: \'eastus\'' do
        expect(@storage_account.location).to eq(@location)
      end

      it 'should have replication: \'LRS\'' do
        expect(@storage_account.replication).to eq(@replication)
      end

      it 'should have SKU type: \'Premium\'' do
        expect(@storage_account.sku_name).to eq(@sku_name)
      end

      it 'should contain tag values \'value1\' and \'value2\'' do
        expect(@storage_account.tags['key1']).to eq(@tags[:key1])
        expect(@storage_account.tags['key2']).to eq(@tags[:key2])
      end
    end
  end

  describe 'Update' do
    context 'Premium LRS Storage Account' do
      before 'updates premium storage account' do
        @premium_sa = @storage.storage_accounts.get(@resource_group.name, @premium_sa_name)
        @updated_premium_sa = @premium_sa.update(encryption: true)
      end

      it 'should be encrypted' do
        expect(@updated_premium_sa.encryption).to eq(true)
      end
    end
  end

  describe 'Get' do
    context 'Standard LRS Storage Account' do
      before 'gets standard LRS account' do
        @lrs_sa = @storage.storage_accounts.get(@resource_group.name, @lrs_sa_name)
      end

      it 'should have name: \'testlrssa\'' do
        expect(@lrs_sa.name).to eq(@lrs_sa_name)
      end
    end

    context 'Standard GRS Storage Account' do
      before 'gets standard GRS account' do
        @grs_sa = @storage.storage_accounts.get(@resource_group.name, @grs_sa_name)
      end

      it 'should have name: \'testgrssa\'' do
        expect(@grs_sa.name).to eq(@grs_sa_name)
      end
    end

    context 'Premium LRS Storage Account' do
      before 'gets standard GRS account' do
        @premium_sa = @storage.storage_accounts.get(@resource_group.name, @premium_sa_name)
      end

      it 'should have name: \'testpremiumsa\'' do
        expect(@premium_sa.name).to eq(@premium_sa_name)
      end
    end
  end

  describe 'List' do
    context 'Within a Subscription' do
      before 'lists all storage accounts within a subscription' do
        @sa_in_subscription = @storage.storage_accounts
      end

      it 'should not be empty' do
        expect(@sa_in_subscription.length).not_to eq(0)
      end
    end

    context 'Within the Resource Group' do
      before 'lists all storage accounts in the resource group' do
        @storage_accounts_list = @storage.storage_accounts(resource_group: @resource_group.name)
      end

      it 'should contain storage accounts: \'testlrssa\', \'testgrssa\', \'testpremiumsa\'' do
        contains_lrs_sa = false
        contains_grs_sa = false
        contains_premium_sa = false
        @storage_accounts_list.each do |storage_account|
          contains_lrs_sa = true if storage_account.name == @lrs_sa_name
          contains_grs_sa = true if storage_account.name == @grs_sa_name
          contains_premium_sa = true if storage_account.name == @premium_sa_name
        end
        expect(contains_lrs_sa).to eq(true)
        expect(contains_grs_sa).to eq(true)
        expect(contains_premium_sa).to eq(true)
      end
    end
  end

  describe 'Delete' do
    context 'Standard LRS Storage Account' do
      before 'gets standard LRS account' do
        @lrs_sa = @storage.storage_accounts.get(@resource_group.name, @lrs_sa_name)
      end

      it 'should not exist anymore' do
        expect(@lrs_sa.destroy).to eq(true)
      end
    end

    context 'Standard GRS Storage Account' do
      before 'gets standard GRS account' do
        @grs_sa = @storage.storage_accounts.get(@resource_group.name, @grs_sa_name)
      end

      it 'should not exist anymore' do
        expect(@grs_sa.destroy).to eq(true)
      end
    end

    context 'Premium LRS Storage Account' do
      before 'gets standard GRS account' do
        @premium_sa = @storage.storage_accounts.get(@resource_group.name, @premium_sa_name)
      end

      it 'should not exist anymore' do
        expect(@premium_sa.destroy).to eq(true)
        expect(@resource_group.destroy).to eq(true)
      end
    end
  end
end
