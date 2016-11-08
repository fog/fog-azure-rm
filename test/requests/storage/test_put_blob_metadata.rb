require File.expand_path '../../test_helper', __dir__

# Storage Blob Class
class TestPutBlobMetadata < Minitest::Test
  # This class posesses the test cases for the requests of setting blob metadata.
  def setup
    Fog.mock!
    @mock_service = Fog::Storage::AzureRM.new(storage_account_credentials)
    Fog.unmock!
    @mocked_response = mocked_storage_http_error

    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)

    @metadata = ApiStub::Requests::Storage::File.blob_metadata
  end

  def test_put_blob_metadata_success
    @blob_client.stub :set_blob_metadata, true do
      assert @service.put_blob_metadata('test_container', 'test_blob', @metadata)
    end
  end

  def test_put_blob_metadata_http_exception
    http_exception = ->(*) { raise Azure::Core::Http::HTTPError.new(@mocked_response) }
    @blob_client.stub :set_blob_metadata, http_exception do
      assert_raises(RuntimeError) do
        @service.put_blob_metadata('test_container', 'test_blob', @metadata)
      end
    end
  end

  def test_put_blob_metadata_mock
    assert @mock_service.put_blob_metadata('test_container', 'test_blob', @metadata)
  end
end
