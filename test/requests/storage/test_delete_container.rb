require File.expand_path '../../test_helper', __dir__

# Storage Container Class
class TestDeleteContainer < Minitest::Test
  # This class posesses the test cases for the requests of deleting storage containers.
  def setup
    Fog.mock!
    @mock_service = Fog::Storage::AzureRM.new(storage_account_credentials)
    Fog.unmock!
    @mocked_response = mocked_storage_http_error
    @mocked_not_found_response = mocked_storage_http_not_found_error

    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)
  end

  def test_delete_container_success
    @blob_client.stub :delete_container, true do
      assert @service.delete_container('test_container')
    end
  end

  def test_delete_container_not_found_success
    http_exception = ->(*) { raise Azure::Core::Http::HTTPError.new(@mocked_not_found_response) }
    @blob_client.stub :delete_container, http_exception do
      assert @service.delete_container('test_container')
    end
  end

  def test_delete_blob_http_exception
    http_exception = ->(*) { raise Azure::Core::Http::HTTPError.new(@mocked_response) }
    @blob_client.stub :delete_container, http_exception do
      assert_raises(RuntimeError) do
        @service.delete_container('test_container')
      end
    end
  end

  def test_delete_container_mock
    assert @mock_service.delete_container('test_container')
  end
end
