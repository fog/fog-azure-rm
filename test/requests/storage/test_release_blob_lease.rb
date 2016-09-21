require File.expand_path '../../test_helper', __dir__

# Storage Blob Class
class TestListBlobs < Minitest::Test
  # This class posesses the test cases for the requests of releasing blob lease.
  def setup
    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)
  end

  def test_release_blob_lease_success
    @blob_client.stub :release_blob_lease, true do
      assert @service.release_blob_lease('test_container', 'test_blob', '78659cee-b7cb-4f18-b9f8-0e9e8bf849f6'), true
    end
  end
end
