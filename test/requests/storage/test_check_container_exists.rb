require File.expand_path '../../test_helper', __dir__

# Storage Container Class
class TestCheckContainerExists < Minitest::Test
  # This class posesses the test cases for the requests of checking container exists.
  def setup
    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)

    @container = ApiStub::Requests::Storage::Directory.container
  end

  def test_check_container_exists_success
    @blob_client.stub :get_container_properties, @container do
      assert_equal @service.check_container_exists('test_container'), true
    end
  end
end
