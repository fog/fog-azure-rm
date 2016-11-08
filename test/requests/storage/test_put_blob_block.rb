require File.expand_path '../../test_helper', __dir__

# Storage Blob Class
class TestPutBlobBlock < Minitest::Test
  # This class posesses the test cases for the requests of putting blob block.
  def setup
    Fog.mock!
    @mock_service = Fog::Storage::AzureRM.new(storage_account_credentials)
    Fog.unmock!
    @mocked_response = mocked_storage_http_error

    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)
  end

  def test_put_blob_block_with_service_success
    @blob_client.stub :put_blob_block, true do
      assert @service.put_blob_block('test_container', 'test_blob', 'id', 'data')
    end
  end

  def test_put_blob_block_http_exception
    http_exception = ->(*) { raise Azure::Core::Http::HTTPError.new(@mocked_response) }
    @blob_client.stub :put_blob_block, http_exception do
      assert_raises(RuntimeError) do
        @service.put_blob_block('test_container', 'test_blob', 'id', 'data')
      end
    end
  end

  def test_put_blob_block_mock
    assert @mock_service.put_blob_block('test_container', 'test_blob', 'id', 'data')
  end
end
