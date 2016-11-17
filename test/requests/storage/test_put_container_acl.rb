require File.expand_path '../../test_helper', __dir__

# Storage Container Class
class TestPutContainerACL < Minitest::Test
  # This class posesses the test cases for the requests of setting storage container acl.
  def setup
    Fog.mock!
    @mock_service = Fog::Storage::AzureRM.new(storage_account_credentials)
    Fog.unmock!
    @mocked_response = mocked_storage_http_error

    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)
  end

  def test_put_container_acl_success
    @blob_client.stub :set_container_acl, true do
      assert @service.put_container_acl('test_container', 'container')
    end
  end

  def test_put_container_acl_http_exception
    http_exception = ->(*) { raise Azure::Core::Http::HTTPError.new(@mocked_response) }
    @blob_client.stub :set_container_acl, http_exception do
      assert_raises(RuntimeError) do
        @service.put_container_acl('test_container', 'container')
      end
    end
  end

  def test_put_container_acl_mock
    assert @mock_service.put_container_acl('test_container', 'container')
  end
end
