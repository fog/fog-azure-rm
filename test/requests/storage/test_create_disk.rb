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
      @service.stub :put_blob_pages, true do
        assert @service.create_disk('test_disk', 10)
      end
    end
  end

  def test_create_disk_in_another_container_success
    @service.stub :create_page_blob, true do
      @service.stub :put_blob_pages, true do
        assert @service.create_disk('test_disk', 10, container_name: 'test_container')
      end
    end
  end

  def test_create_disk_with_invalid_size_exception
    assert_raises(ArgumentError) do
      @service.create_disk('test_disk', 'invalid_size')
    end

    assert_raises(ArgumentError) do
      @service.create_disk('test_disk', 0)
    end

    assert_raises(ArgumentError) do
      @service.create_disk('test_disk', 1024)
    end
  end

  def test_create_disk_http_exception
    http_exception = ->(*) { raise Azure::Core::Http::HTTPError.new(@mocked_response) }
    @service.stub :create_page_blob, http_exception do
      @service.stub :delete_blob, true do
        assert_raises(Azure::Core::Http::HTTPError) do
          @service.create_disk('test_disk', 10, container_name: 'test_container')
        end
      end
    end
  end

  def test_create_disk_fail_when_delete_blob_http_exception
    http_exception = ->(*) { raise Azure::Core::Http::HTTPError.new(@mocked_response) }
    @service.stub :create_page_blob, http_exception do
      @service.stub :delete_blob, http_exception do
        assert_raises(Azure::Core::Http::HTTPError) do
          @service.create_disk('test_disk', 10, container_name: 'test_container')
        end
      end
    end
  end

  def test_create_disk_mock
    assert @mock_service.create_disk('test_disk')
  end
end
