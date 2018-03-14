require File.expand_path '../../test_helper', __dir__

# Storage Blob Class
class TestCompareContainerBlobs < Minitest::Test
  # This class posesses the test cases for the requests of comparing blobs.
  def setup
    Fog.mock!
    @mock_service = Fog::Storage::AzureRM.new(storage_account_credentials)
    Fog.unmock!
    @mocked_response = mocked_storage_http_error

    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)

    @blob_list = ApiStub::Requests::Storage::File.blob_list
  end

  def test_compare_container_blobs_success
    @service.stub :get_identical_blobs_from_containers, @blob_list do
      assert_equal @blob_list, @service.compare_container_blobs('test_container1', 'test_container2')
    end
  end

  def test_compare_container_blobs_http_exception
    http_exception = ->(*) { raise Azure::Core::Http::HTTPError.new(@mocked_response) }
    @service.stub :get_identical_blobs_from_containers, http_exception do
      assert_raises(Azure::Core::Http::HTTPError) do
        @service.compare_container_blobs('test_container1', 'test_container2')
      end
    end
  end

  def test_compare_container_blobs_mock
    assert_equal @blob_list, @mock_service.compare_container_blobs('test_container1', 'test_container2')
  end
end
