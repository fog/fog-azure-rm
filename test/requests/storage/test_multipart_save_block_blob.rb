require File.expand_path '../../test_helper', __dir__

# Storage Blob Class
class TestMultipartSaveBlockBlob < Minitest::Test
  # This class posesses the test cases for the requests of saving storage block blob with multiple parts.
  def setup
    Fog.mock!
    @mock_service = Fog::Storage::AzureRM.new(storage_account_credentials)
    Fog.unmock!
    @mocked_response = mocked_storage_http_error

    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
  end

  def test_multipart_save_block_blob_success
    body = 'd' * 5 * 1024 * 1024 # MAXIMUM_CHUNK_SIZE is 4 * 1024 * 1024

    @service.stub :create_block_blob, true do
      @service.stub :put_blob_block, true do
        @service.stub :commit_blob_blocks, true do
          assert @service.multipart_save_block_blob('test_container', 'test_blob', body, worker_thread_num: 6, content_md5: 'oafL1+HS78x65+e39PGIIg==')
        end
      end
    end
  end

  def test_multipart_save_block_blob_with_file_handle_success
    i = 0
    multiple_values = lambda do |*|
      i += 1
      return 'd' * 4 * 1024 * 1024 if i == 1
      return 'd' * (1 * 1024 * 1024 + 1) if i == 2
      return nil
    end
    temp_file = '/dev/null'
    File.open(temp_file, 'r') do |file_handle|
      file_handle.stub :read, multiple_values do
        file_handle.stub :rewind, nil do
          @service.stub :create_block_blob, @raw_cloud_blob do
            @service.stub :put_blob_block, true do
              @service.stub :commit_blob_blocks, true do
                assert @service.multipart_save_block_blob('test_container', 'test_blob', file_handle, worker_thread_num: 0)
              end
            end
          end
        end
      end
    end
  end

  def test_multipart_save_block_blob_with_file_handle_do_not_support_rewind_success
    i = 0
    multiple_values = lambda do |*|
      i += 1
      return 'd' * 4 * 1024 * 1024 if i == 1
      return 'd' * (1 * 1024 * 1024 + 1) if i == 2
      return nil
    end
    temp_file = '/dev/null'
    exception = ->(*) { raise 'do not support rewind' }
    File.open(temp_file, 'r') do |file_handle|
      file_handle.stub :read, multiple_values do
        file_handle.stub :rewind, exception do
          @service.stub :create_block_blob, @raw_cloud_blob do
            @service.stub :put_blob_block, true do
              @service.stub :commit_blob_blocks, true do
                assert @service.multipart_save_block_blob('test_container', 'test_blob', file_handle, worker_thread_num: 'invalid')
              end
            end
          end
        end
      end
    end
  end

  def test_multipart_save_block_blob_http_exception
    body = 'd' * 5 * 1024 * 1024 # MAXIMUM_CHUNK_SIZE is 4 * 1024 * 1024

    http_exception = ->(*) { raise Azure::Core::Http::HTTPError.new(@mocked_response) }
    @service.stub :create_block_blob, http_exception do
      @service.stub :delete_blob, true do
        assert_raises(Azure::Core::Http::HTTPError) do
          @service.multipart_save_block_blob('test_container', 'test_blob', body, {})
        end
      end
    end
  end

  def test_multipart_save_block_blob_fail_when_delete_blob_http_exception
    body = 'd' * 5 * 1024 * 1024 # MAXIMUM_CHUNK_SIZE is 4 * 1024 * 1024

    http_exception = ->(*) { raise Azure::Core::Http::HTTPError.new(@mocked_response) }
    @service.stub :create_block_blob, http_exception do
      @service.stub :delete_blob, http_exception do
        assert_raises(Azure::Core::Http::HTTPError) do
          @service.multipart_save_block_blob('test_container', 'test_blob', body, {})
        end
      end
    end
  end

  def test_multipart_save_block_blob_mock
    assert @mock_service.multipart_save_block_blob('test_container', 'test_blob', 'content', {})
  end
end
