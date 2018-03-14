require File.expand_path '../../test_helper', __dir__

# Storage Blob Class
class TestGetBlobProperties < Minitest::Test
  # This class posesses the test cases for the requests of getting storage blob properties.
  def setup
    Fog.mock!
    @mock_service = Fog::Storage::AzureRM.new(storage_account_credentials)
    Fog.unmock!
    @mocked_response = mocked_storage_http_error

    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)

    @blob = ApiStub::Requests::Storage::File.blob
  end

  def test_get_blob_properties_success
    @blob_client.stub :get_blob_properties, @blob do
      assert_equal @blob, @service.get_blob_properties('test_container', 'test_blob')
    end
  end

  def test_get_blob_properties_not_found
    exception = ->(*) { raise StandardError.new('Not found(404). Not exist') }
    @blob_client.stub :get_blob_properties, exception do
      assert_raises('NotFound') do
        @service.get_blob_properties('test_container', 'test_blob')
      end
    end
  end

  def test_get_blob_properties_http_exception
    http_exception = ->(*) { raise Azure::Core::Http::HTTPError.new(@mocked_response) }
    @blob_client.stub :get_blob_properties, http_exception do
      assert_raises(Azure::Core::Http::HTTPError) do
        @service.get_blob_properties('test_container', 'test_blob')
      end
    end
  end

  def test_get_blob_properties_mock
    assert_equal @blob, @mock_service.get_blob_properties('test_container', 'test_blob')
  end
end
