require File.expand_path '../../test_helper', __dir__

# Storage Blob Class
class TestListBlobs < Minitest::Test
  # This class posesses the test cases for the requests of copying blobs.
  def setup
    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)
    @copy_blob_reponse = ApiStub::Requests::Storage::File.copy_blob
  end

  def test_copy_blob_success
    @blob_client.stub :copy_blob, @copy_blob_reponse do
      assert @service.copy_blob('destination_container', 'destination_blob', 'source_container', 'source_blob'), @copy_blob_reponse
    end
  end

  def test_copy_blob_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @blob_client.stub :copy_blob, response do
      assert_raises(RuntimeError) { @service.copy_blob('destination_container', 'destination_blob', 'source_container', 'source_blob') }
    end
  end
end
