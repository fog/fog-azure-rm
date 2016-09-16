require File.expand_path '../../test_helper', __dir__

# Blob Class
class TestSetBlobProperties < Minitest::Test
  # This class posesses the test cases for the requests of blob service.
  def setup
    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)
  end

  def test_set_blob_properties_success
    @blob_client.stub :set_blob_properties, true do
      assert @service.set_blob_properties('testcontainer', 'testblob10', content_language: 'english', content_disposition: 'attachment')
    end
  end
end
