require File.expand_path '../../test_helper', __dir__

# Storage Account Class
class TestGetContainerMetadata < Minitest::Test
  # This class posesses the test cases for the requests of storage account service.
  def setup
    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)
    @container_object = ApiStub::Requests::Storage::Container.test_get_container_metadata
  end

  def test_get_container_metadata_success
    metadata_response = ApiStub::Requests::Storage::Container.metadata_response
    @blob_client.stub :get_container_metadata, @container_object do
      assert_equal @service.get_container_metadata('Test-container'), metadata_response
    end
  end

  def test_get_container_metadata_exception
    raise_exception = -> { fail Exception.new('mocked exception') }
    @blob_client.stub :get_container_metadata, raise_exception do
      assert_raises(RuntimeError) { @service.get_container_metadata('Test-container') }
    end
  end
end
