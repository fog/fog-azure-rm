require File.expand_path '../../test_helper', __dir__

# Storage Blob Class
class TestCreatePageBlob < Minitest::Test
  # This class posesses the test cases for the requests of creating storage page blobs.
  def setup
    Fog.mock!
    @mock_service = Fog::Storage::AzureRM.new(storage_account_credentials)
    Fog.unmock!
    @mocked_response = mocked_storage_http_error

    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)
  end

  def test_create_page_blob_success
    @blob_client.stub :create_page_blob, true do
      assert @service.create_page_blob('test_container', 'test_blob', 1_024)
    end
  end

  def test_create_page_blob_http_exception
    http_exception = ->(*) { raise Azure::Core::Http::HTTPError.new(@mocked_response) }
    @blob_client.stub :create_page_blob, http_exception do
      assert_raises(Azure::Core::Http::HTTPError) do
        @service.create_page_blob('test_container', 'test_blob', 1_024)
      end
    end
  end

  def test_create_page_blob_mock
    assert @mock_service.create_page_blob('test_container', 'test_blob', 1_024)
  end
end
