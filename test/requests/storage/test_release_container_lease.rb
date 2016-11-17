require File.expand_path '../../test_helper', __dir__

# Storage Container Class
class TestReleaseContainerLease < Minitest::Test
  # This class posesses the test cases for the requests of releasing container lease.
  def setup
    Fog.mock!
    @mock_service = Fog::Storage::AzureRM.new(storage_account_credentials)
    Fog.unmock!
    @mocked_response = mocked_storage_http_error

    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)
  end

  def test_release_container_lease_success
    @blob_client.stub :release_container_lease, true do
      assert @service.release_container_lease('test_container', 'lease_id')
    end
  end

  def test_release_container_lease_http_exception
    http_exception = ->(*) { raise Azure::Core::Http::HTTPError.new(@mocked_response) }
    @blob_client.stub :release_container_lease, http_exception do
      assert_raises(RuntimeError) do
        @service.release_container_lease('test_container', 'lease_id')
      end
    end
  end

  def test_release_container_lease_mock
    assert @mock_service.release_container_lease('test_container', 'lease_id')
  end
end
