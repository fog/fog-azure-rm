require File.expand_path '../../test_helper', __dir__

# Test class for Create Managed Disk Request
class TestCreateManagedDisk < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    @client = @service.instance_variable_get(:@compute_mgmt_client)
    @managed_disks = @client.disks
    @disk = {
      name: 'my-managed-disk',
      location: 'eastus',
      resource_group_name: 'fog-test-rg',
      account_type: 'Premium_LRS',
      disk_size_gb: 1024,
      creation_data: {
        create_option: 'Empty'
      }
    }
  end

  def test_create_or_update_managed_disk_success
    mocked_response = ApiStub::Requests::Compute::ManagedDisk.create_or_update_managed_disk_response(@client)
    @managed_disks.stub :validate_params, true do
      @managed_disks.stub :create_or_update, mocked_response do
        assert_equal @service.create_or_update_managed_disk(@disk), mocked_response
      end
    end
  end

  def test_create_or_update_managed_disk_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @managed_disks.stub :validate_params, true do
      @managed_disks.stub :create_or_update, response do
        assert_raises(RuntimeError) { @service.create_or_update_managed_disk(@disk) }
      end
    end
  end
end
