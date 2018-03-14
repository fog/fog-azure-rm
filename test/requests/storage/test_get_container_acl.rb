require File.expand_path '../../test_helper', __dir__

# Storage Container Class
class TestGetContainerAcl < Minitest::Test
  # This class posesses the test cases for the requests of getting storage container acl.
  def setup
    Fog.mock!
    @mock_service = Fog::Storage::AzureRM.new(storage_account_credentials)
    Fog.unmock!
    @mocked_response = mocked_storage_http_error

    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)

    @raw_container_acl = ApiStub::Requests::Storage::Directory.raw_container_acl
    @container_acl = ApiStub::Requests::Storage::Directory.container_acl
  end

  def test_get_container_acl_success
    @blob_client.stub :get_container_acl, @raw_container_acl do
      assert_equal @container_acl, @service.get_container_acl('test_container')
    end
  end

  def test_get_container_acl_http_exception
    http_exception = ->(*) { raise Azure::Core::Http::HTTPError.new(@mocked_response) }
    @blob_client.stub :get_container_acl, http_exception do
      assert_raises(Azure::Core::Http::HTTPError) do
        @service.get_container_acl('test_container')
      end
    end
  end

  def test_get_container_acl_mock
    assert_equal @container_acl, @mock_service.get_container_acl('test_container')
  end
end
