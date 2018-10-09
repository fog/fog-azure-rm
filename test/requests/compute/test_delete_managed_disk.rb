require File.expand_path '../../test_helper', __dir__

# Test class for Delete Managed Disk Request
class TestDeleteManagedDisk < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@compute_mgmt_client)
    @managed_disks = client.disks
  end

  def test_delete_managed_disk_success
    @managed_disks.stub :delete, true do
      assert @service.delete_managed_disk('fog-test-rg', 'test-disk', false)
    end
  end

  def test_delete_managed_disk_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @managed_disks.stub :delete, response do
      assert_raises(RuntimeError) { @service.delete_managed_disk('fog-test-rg', 'test-disk', false) }
    end
  end
end
