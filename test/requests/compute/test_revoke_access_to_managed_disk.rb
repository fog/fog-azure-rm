require File.expand_path '../../test_helper', __dir__

# Test class for Revoke Access from Managed Disk Request
class TestRevokeAccessFromManagedDisk < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    @client = @service.instance_variable_get(:@compute_mgmt_client)
    @managed_disks = @client.disks
  end

  def test_revoke_access_from_managed_disk_success
    mocked_response = ApiStub::Requests::Compute::ManagedDisk.operation_status_response(@client)
    @managed_disks.stub :revoke_access, mocked_response do
      assert_equal @service.revoke_access_to_managed_disk('myrg1', 'myavset1'), mocked_response
    end
  end

  def test_revoke_access_from_managed_disk_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @managed_disks.stub :revoke_access, response do
      assert_raises(MsRestAzure::AzureOperationError) { @service.revoke_access_to_managed_disk('myrg1', 'myavset1') }
    end
  end
end
