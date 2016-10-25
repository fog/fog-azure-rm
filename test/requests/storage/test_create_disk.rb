require File.expand_path '../../test_helper', __dir__

# Storage Data Disk Class
class TestCreateDisk < Minitest::Test
  # This class posesses the test cases for the request of create disk.
  def setup
    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)
    @storage_data_disk_object = ApiStub::Requests::Storage::File.upload_block_blob_from_file
  end

  def test_create_disk_success
    @service.stub :upload_block_blob_from_file, @storage_data_disk_object do
      assert @service.create_disk('test_blob', options = {})
    end
  end
end
