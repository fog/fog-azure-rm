require File.expand_path '../../test_helper', __dir__

# Test class for Check Managed Disk Exists Request
class TestCheckManagedDiskExists < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    @client = @service.instance_variable_get(:@compute_mgmt_client)
    @managed_disks = @client.disks
  end

  def test_check_managed_disk_exists_success
    mocked_response = ApiStub::Requests::Compute::ManagedDisk.get_managed_disk_response(@client)
    @managed_disks.stub :get, mocked_response do
      assert @service.check_managed_disk_exists('myrg1', 'mydisk1')
    end
  end

  def test_check_managed_disk_exists_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, mock_response, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceNotFound' }) }
    @managed_disks.stub :get, response do
      assert !@service.check_managed_disk_exists('myrg1', 'mydisk1')
    end
  end

  def test_check_managed_disk_exists_exception
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, mock_response, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceGroupNotFound' }) }
    @managed_disks.stub :get, response do
      assert !@service.check_managed_disk_exists('myrg1', 'mydisk1')
    end
  end
end
