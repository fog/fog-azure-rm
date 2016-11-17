require File.expand_path '../../test_helper', __dir__

# Storage Blob Class
class TestPutBlobPages < Minitest::Test
  # This class posesses the test cases for the requests of putting blob page.
  def setup
    Fog.mock!
    @mock_service = Fog::Storage::AzureRM.new(storage_account_credentials)
    Fog.unmock!
    @mocked_response = mocked_storage_http_error

    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)
  end

  def test_put_blob_pages_success
    @blob_client.stub :put_blob_pages, true do
      assert @service.put_blob_pages('test_container', 'test_blob', 0, 1024, 'data')
    end
  end

  def test_put_blob_pages_http_exception
    http_exception = ->(*) { raise Azure::Core::Http::HTTPError.new(@mocked_response) }
    @blob_client.stub :put_blob_pages, http_exception do
      assert_raises(RuntimeError) do
        @service.put_blob_pages('test_container', 'test_blob', 0, 1024, 'data')
      end
    end
  end

  def test_put_blob_pages_mock
    assert @mock_service.put_blob_pages('test_container', 'test_blob', 0, 1024, 'data')
  end
end
