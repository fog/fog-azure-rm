require File.expand_path '../../test_helper', __dir__

# Test class for Grant Access to Managed Disk Request
class TestGrantAccessToManagedDisk < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    @client = @service.instance_variable_get(:@compute_mgmt_client)
    @managed_disks = @client.disks
  end

  def test_grant_access_to_managed_disk_success
    mocked_response = Azure::Compute::Profiles::Latest::Mgmt::Models::AccessUri.new
    mocked_response.stub :access_sas, 'xxxxxxxx-xxxx-xxxx-xxxxxxxx' do
      @managed_disks.stub :grant_access, mocked_response do
        assert_equal @service.grant_access_to_managed_disk('myrg1', 'disk1', 'Read', 100), 'xxxxxxxx-xxxx-xxxx-xxxxxxxx'
      end
    end
  end

  def test_grant_access_to_managed_disk_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @managed_disks.stub :grant_access, response do
      assert_raises(MsRestAzure::AzureOperationError) { @service.grant_access_to_managed_disk('myrg1', 'disk1', 'Read', 100) }
    end
  end
end
