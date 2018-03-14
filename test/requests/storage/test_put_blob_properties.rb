require File.expand_path '../../test_helper', __dir__

# Storage Blob Class
class TestPutBlobProperties < Minitest::Test
  # This class posesses the test cases for the requests of setting blob properties.
  def setup
    Fog.mock!
    @mock_service = Fog::Storage::AzureRM.new(storage_account_credentials)
    Fog.unmock!
    @mocked_response = mocked_storage_http_error

    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)

    @properties = {
      content_language: 'english',
      content_disposition: 'attachment'
    }
  end

  def test_put_blob_properties_success
    @blob_client.stub :set_blob_properties, true do
      assert @service.put_blob_properties('test_container', 'test_blob', @properties)
    end
  end

  def test_put_blob_properties_http_exception
    http_exception = ->(*) { raise Azure::Core::Http::HTTPError.new(@mocked_response) }
    @blob_client.stub :set_blob_properties, http_exception do
      assert_raises(Azure::Core::Http::HTTPError) do
        @service.put_blob_properties('test_container', 'test_blob', @properties)
      end
    end
  end

  def test_put_blob_properties_mock
    assert @mock_service.put_blob_properties('test_container', 'test_blob', @properties)
  end
end
