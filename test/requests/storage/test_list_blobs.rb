require File.expand_path '../../test_helper', __dir__

# Storage Blob Class
class TestListBlobs < Minitest::Test
  # This class posesses the test cases for the requests of listing storage containers.
  def setup
    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)
    @storage_blob_object = ApiStub::Requests::Storage::File.list_blobs
  end

  def test_list_blobs_with_service_success
    @blob_client.stub :list_blobs, @storage_blob_object do
      assert @service.list_blobs('test-container').size >= 1
    end
  end

  def test_list_blobs_with_internal_client_success
    @blob_client.stub :list_blobs, @storage_blob_object do
      assert @blob_client.list_blobs('test-container').size >= 1
    end
  end
end
