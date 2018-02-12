require File.expand_path '../../test_helper', __dir__

# Storage Container Class
class TestCreateContainer < Minitest::Test
  # This class posesses the test cases for the requests of creating storage containers.
  def setup
    Fog.mock!
    @mock_service = Fog::Storage::AzureRM.new(storage_account_credentials)
    Fog.unmock!
    @mocked_response = mocked_storage_http_error

    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)

    @container = ApiStub::Requests::Storage::Directory.container
  end

  def test_create_container_success
    @blob_client.stub :create_container, @container do
      assert_equal @container, @service.create_container('test_container')
    end
  end

  def test_create_container_http_exception
    http_exception = ->(*) { raise Azure::Core::Http::HTTPError.new(@mocked_response) }
    @blob_client.stub :create_container, http_exception do
      assert_raises(Azure::Core::Http::HTTPError) do
        @service.create_container('test_container')
      end
    end
  end

  def test_create_container_mock
    assert_equal @container, @mock_service.create_container('test_container')
  end
end
