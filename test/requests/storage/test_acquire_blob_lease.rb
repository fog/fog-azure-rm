require File.expand_path '../../test_helper', __dir__

# Storage Blob Class
class TestListBlobs < Minitest::Test
  # This class posesses the test cases for the requests of acquire blob lease.
  def setup
    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)
  end

  def test_acquire_blob_lease_success
    lease_id = { 'leaseId' => 'abc123' }
    @blob_client.stub :acquire_blob_lease, lease_id do
      assert @service.acquire_blob_lease('test_container', 'test_blob'), lease_id
    end
  end
end
