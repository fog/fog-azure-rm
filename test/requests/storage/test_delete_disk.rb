require File.expand_path '../../test_helper', __dir__

# Storage Data Disk Class
class TestDeleteDisk < Minitest::Test
  # This class posesses the test cases for the requests of deleting data disks.
  def setup
    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)
    @storage_data_disk_object = ApiStub::Requests::Storage::File.get_blob_properties
  end

  def test_delete_disk_success
    @service.stub :delete_blob, nil do
      assert @service.delete_disk('testblob1')
    end
  end

  def test_delete_disk_failure
    @service.stub :delete_blob, @storage_data_disk_object do
      assert !@service.delete_disk('testblob1')
    end
  end
end
