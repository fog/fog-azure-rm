require File.expand_path '../../../test_helper', __FILE__

# Storage Container Class
class TestDeleteContaienr < Minitest::Test
  # This class posesses the test cases for the requests of deleting storage containers.
  def setup
    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)
  end

  def test_delete_container_with_service_success
    @blob_client.stub :delete_container, true do
      assert @service.delete_container('testcontainer1')
    end
  end

  def test_delete_container_with_internal_client_success
    @blob_client.stub :delete_container, true do
      assert @blob_client.delete_container('testcontainer1')
    end
  end

  def test_delete_container_with_service_exception
    assert_raises(URI::InvalidURIError) { @service.delete_container('testcontainer1#@#@') }
  end

  def test_delete_container_with_internal_client_exception
    assert_raises(URI::InvalidURIError) { @blob_client.delete_container('testcontainer1#@#@') }
  end
end
