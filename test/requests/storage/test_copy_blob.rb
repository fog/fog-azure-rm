require File.expand_path '../../test_helper', __dir__

# Storage Blob Class
class TestCopyBlob < Minitest::Test
  # This class posesses the test cases for the requests of copying blobs.
  def setup
    Fog.mock!
    @mock_service = Fog::Storage::AzureRM.new(storage_account_credentials)
    Fog.unmock!
    @mocked_response = mocked_storage_http_error

    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)

    @blob_copy_result = ApiStub::Requests::Storage::File.blob_copy_result
  end

  def test_copy_blob_success
    @blob_client.stub :copy_blob, @blob_copy_result do
      assert_equal @blob_copy_result, @service.copy_blob('destination_container', 'destination_blob', 'source_container', 'source_blob')
    end
  end

  def test_copy_blob_http_exception
    http_exception = ->(*) { raise Azure::Core::Http::HTTPError.new(@mocked_response) }
    @blob_client.stub :copy_blob, http_exception do
      assert_raises(RuntimeError) do
        @service.copy_blob('destination_container', 'destination_blob', 'source_container', 'source_blob')
      end
    end
  end

  def test_copy_blob_mock
    assert_equal @blob_copy_result, @mock_service.copy_blob('destination_container', 'destination_blob', 'source_container', 'source_blob')
  end
end
