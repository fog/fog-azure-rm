require File.expand_path '../../test_helper', __dir__

# Storage Data Disk Class
class TestCreateDisk < Minitest::Test
  # This class posesses the test cases for the request of create disk.
  def setup
    Fog.mock!
    @mock_service = Fog::Storage::AzureRM.new(storage_account_credentials)
    Fog.unmock!
    @mocked_response = mocked_storage_http_error

    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
  end

  def test_create_disk_success
    @service.stub :create_page_blob, true do
      assert @service.create_disk('test_blob', {})
    end
  end

  def test_create_disk_mock
    assert @mock_service.create_disk('test_blob', {})
  end
end
