require File.expand_path '../../test_helper', __dir__

# Storage Blob Class
class TestListBlobs < Minitest::Test
  # This class posesses the test cases for the requests of checking if blob exists.
  def setup
    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)
  end

  def test_check_blob_exist_success
    blob = ApiStub::Requests::Storage::File.get_blob_properties
    @blob_client.stub :get_blob_properties, blob do
      assert @service.check_blob_exist('test_container', 'test_blob'), true
    end
  end
end
