require File.expand_path '../../test_helper', __dir__

# Test class for List Managed Disks Request
class TestListManagedDisksByRG < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    @client = @service.instance_variable_get(:@compute_mgmt_client)
    @managed_disks = @client.disks
  end

  def test_list_managed_disks_by_rg_success
    mocked_response = [ApiStub::Requests::Compute::ManagedDisk.create_or_update_managed_disk_response(@client)]
    @managed_disks.stub :list_by_resource_group, mocked_response do
      assert_equal @service.list_managed_disks_by_rg('fog-test-rg'), mocked_response
    end
  end

  def test_list_managed_disks_by_rg_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @managed_disks.stub :list_by_resource_group, response do
      assert_raises(MsRestAzure::AzureOperationError) { @service.list_managed_disks_by_rg('fog-test-rg') }
    end
  end
end
