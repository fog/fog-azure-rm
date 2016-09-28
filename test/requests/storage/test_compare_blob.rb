require File.expand_path '../../test_helper', __dir__

# Storage Blob Class
class TestCompareBlobs < Minitest::Test
  # This class posesses the test cases for the requests of comparing blobs.
  def setup
    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)
    @compare_blob_response = ApiStub::Requests::Storage::File.list_blobs_response
  end

  def test_compare_blobs_success
    @service.stub :get_identical_blobs_from_containers, @compare_blob_response do
      assert @service.compare_blob('container1', 'container2'), @compare_blob_response
    end
  end
end
