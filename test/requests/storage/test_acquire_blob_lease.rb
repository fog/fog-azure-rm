require File.expand_path '../../test_helper', __dir__

# Storage Blob Class
class TestAcquireBlobLease < Minitest::Test
  # This class posesses the test cases for the requests of acquire blob lease.
  def setup
    Fog.mock!
    @mock_service = Fog::Storage::AzureRM.new(storage_account_credentials)
    Fog.unmock!
    @mocked_response = mocked_storage_http_error

    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)

    @blob_lease_id = ApiStub::Requests::Storage::File.blob_lease_id
  end

  def test_acquire_blob_lease_success
    @blob_client.stub :acquire_blob_lease, @blob_lease_id do
      assert_equal @blob_lease_id, @service.acquire_blob_lease('test_container', 'test_blob')
    end
  end

  def test_acquire_blob_lease_http_exception
    http_exception = ->(*) { raise Azure::Core::Http::HTTPError.new(@mocked_response) }
    @blob_client.stub :acquire_blob_lease, http_exception do
      assert_raises(Azure::Core::Http::HTTPError) do
        @service.acquire_blob_lease('test_container', 'test_blob')
      end
    end
  end

  def test_acquire_blob_lease_mock
    assert_equal @blob_lease_id, @mock_service.acquire_blob_lease('test_container', 'test_blob')
  end
end
