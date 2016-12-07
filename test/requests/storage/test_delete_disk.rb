require File.expand_path '../../test_helper', __dir__

# Storage Data Disk Class
class TestDeleteDisk < Minitest::Test
  # This class posesses the test cases for the requests of deleting data disks.
  def setup
    Fog.mock!
    @mock_service = Fog::Storage::AzureRM.new(storage_account_credentials)
    Fog.unmock!
    @mocked_response = mocked_storage_http_error

    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
  end

  def test_delete_disk_success
    @service.stub :delete_blob, true do
      assert @service.delete_disk('test_disk')
    end
  end

  def test_delete_disk_in_another_container_success
    @service.stub :delete_blob, true do
      assert @service.delete_disk('test_disk', container_name: 'test_container')
    end
  end

  def test_delete_disk_mock
    assert @mock_service.delete_disk('test_disk')
  end
end
