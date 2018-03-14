require File.expand_path '../../test_helper', __dir__

# Test class for Get Managed Disk Request
class TestGetManagedDisk < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    @client = @service.instance_variable_get(:@compute_mgmt_client)
    @managed_disks = @client.disks
  end

  def test_get_managed_disk_success
    mocked_response = ApiStub::Requests::Compute::ManagedDisk.get_managed_disk_response(@client)
    @managed_disks.stub :get, mocked_response do
      assert_equal @service.get_managed_disk('myrg1', 'disk1'), mocked_response
    end
  end

  def test_get_managed_disk_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @managed_disks.stub :get, response do
      assert_raises(MsRestAzure::AzureOperationError) { @service.get_managed_disk('myrg1', 'disk1') }
    end
  end
end
