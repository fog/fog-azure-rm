require File.expand_path '../../test_helper', __dir__

# Storage Blob Class
class TestDeleteBlob < Minitest::Test
  # This class posesses the test cases for the requests of deleting storage blobs.
  def setup
    Fog.mock!
    @mock_service = Fog::Storage::AzureRM.new(storage_account_credentials)
    Fog.unmock!
    @mocked_response = mocked_storage_http_error
    @mocked_not_found_response = mocked_storage_http_not_found_error

    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)
  end

  def test_delete_blob_success
    @blob_client.stub :delete_blob, true do
      assert @service.delete_blob('test_container', 'test_blob')
    end
  end

  def test_delete_blob_with_not_found_success
    http_exception = ->(*) { raise Azure::Core::Http::HTTPError.new(@mocked_not_found_response) }
    @blob_client.stub :delete_blob, http_exception do
      assert @service.delete_blob('test_container', 'test_blob')
    end
  end

  def test_delete_blob_http_exception
    http_exception = ->(*) { raise Azure::Core::Http::HTTPError.new(@mocked_response) }
    @blob_client.stub :delete_blob, http_exception do
      assert_raises(Azure::Core::Http::HTTPError) do
        @service.delete_blob('test_container', 'test_blob')
      end
    end
  end

  def test_delete_blob_mock
    assert @mock_service.delete_blob('test_container', 'test_blob')
  end
end
