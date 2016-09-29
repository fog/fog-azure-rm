require File.expand_path '../../test_helper', __dir__

# Storage Blob Class
class TestListBlobs < Minitest::Test
  # This class posesses the test cases for the requests of acquire container lease.
  def setup
    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)
  end

  def test_acquire_container_lease_success
    lease_id = { 'leaseId' => 'abc123' }
    @blob_client.stub :acquire_container_lease, lease_id do
      assert @service.acquire_container_lease('test_container'), lease_id
    end
  end
end
