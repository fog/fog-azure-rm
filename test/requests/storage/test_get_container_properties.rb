require File.expand_path '../../test_helper', __dir__

# Storage Container Class
class TestGetContainerProperties < Minitest::Test
  # This class posesses the test cases for the requests of getting storage container properties.
  def setup
    Fog.mock!
    @mock_service = Fog::Storage::AzureRM.new(storage_account_credentials)
    Fog.unmock!
    @mocked_response = mocked_storage_http_error

    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)

    @container = ApiStub::Requests::Storage::Directory.container
  end

  def test_get_container_properties_success
    @blob_client.stub :get_container_properties, @container do
      assert_equal @container, @service.get_container_properties('test_container')
    end
  end

  def test_get_container_properties_not_found
    exception = ->(_name, _option) { raise StandardError.new('Not found(404). Not exist') }
    @blob_client.stub :get_container_properties, exception do
      assert_raises('NotFound') do
        @service.get_container_properties('test_container')
      end
    end
  end

  def test_get_container_properties_http_exception
    http_exception = ->(*) { raise Azure::Core::Http::HTTPError.new(@mocked_response) }
    @blob_client.stub :get_container_properties, http_exception do
      assert_raises(RuntimeError) do
        @service.get_container_properties('test_container')
      end
    end
  end

  def test_get_container_properties_mock
    assert_equal @container, @mock_service.get_container_properties('test_container')
  end
end
