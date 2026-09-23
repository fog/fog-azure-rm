require File.expand_path '../../test_helper', __dir__

# Storage Blob Class
class TestWaitBlobCopyOperationToFinish < Minitest::Test
  # This class posesses the test cases for the requests of waiting storage blob copy operation to finish.
  def setup
    Fog.mock!
    @mock_service = Fog::Storage::AzureRM.new(storage_account_credentials)
    Fog.unmock!
    @mocked_response = mocked_storage_http_error
    @blob = storage_blob

    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)
  end

  def test_wait_blob_copy_operation_to_finish_with_success
    copy_id = @blob.properties[:copy_id]
    copy_status = 'pending'

    i = 0
    multiple_values = lambda do |*|
      i += 1
      if i == 1
        @blob.properties[:copy_status] = copy_status
        @blob.properties[:copy_progress] = '0/1024'
        @blob.properties[:copy_status_description] = 'in progress'
        return @blob
      end

      if i == 2
        @blob.properties[:copy_status] = copy_status
        @blob.properties[:copy_progress] = '2/1024'
        @blob.properties[:copy_status_description] = 'in progress'
        return @blob
      end

      if i == 3
        @blob.properties[:copy_status] = copy_status
        @blob.properties[:copy_progress] = '1023/1024'
        @blob.properties[:copy_status_description] = 'in progress'
        return @blob
      end

      @blob.properties[:copy_status] = 'success'
      @blob.properties[:copy_progress] = '1024/1024'
      @blob.properties[:copy_status_description] = 'finish'
      @blob
    end

    @service.stub :get_blob_properties, multiple_values do
      assert @service.wait_blob_copy_operation_to_finish('test_container', 'test_blob', copy_id, copy_status)
    end
  end

  def test_wait_blob_copy_operation_to_finish_with_copy_finished_success
    copy_id = nil
    copy_status = 'success'

    @service.stub :get_blob_properties, @blob do
      assert @service.wait_blob_copy_operation_to_finish('test_container', 'test_blob', copy_id, copy_status)
    end
  end

  def test_wait_blob_copy_operation_to_finish_with_copy_id_is_nil
    copy_id = nil
    copy_status = 'pending'

    @service.stub :get_blob_properties, @blob do
      assert @service.wait_blob_copy_operation_to_finish('test_container', 'test_blob', copy_id, copy_status)
    end
  end

  def test_wait_blob_copy_operation_to_finish_with_copy_id_not_match_exception
    copy_id = 'copy_id'
    copy_status = 'pending'

    @service.stub :get_blob_properties, @blob do
      @service.stub :delete_blob, true do
        assert_raises(RuntimeError) do
          @service.wait_blob_copy_operation_to_finish('test_container', 'test_blob', copy_id, copy_status)
        end
      end
    end
  end

  def test_wait_blob_copy_operation_to_finish_with_timeout_exception
    copy_id = @blob.properties[:copy_id]
    copy_status = 'pending'

    i = 0
    multiple_values = lambda do |*|
      i += 1
      if i == 1
        @blob.properties[:copy_status] = copy_status
        @blob.properties[:copy_progress] = '0/1024'
        @blob.properties[:copy_status_description] = 'in progress'
        return @blob
      end

      @blob.properties[:copy_status] = copy_status
      @blob.properties[:copy_progress] = '0/1024'
      @blob.properties[:copy_status_description] = 'in progress'
      @blob
    end

    @service.stub :get_blob_properties, multiple_values do
      @service.stub :delete_blob, true do
        assert_raises(Timeout::Error) do
          @service.wait_blob_copy_operation_to_finish('test_container', 'test_blob', copy_id, copy_status, 2)
        end
      end
    end
  end

  def test_wait_blob_copy_operation_to_finish_with_fail_exception
    copy_id = @blob.properties[:copy_id]
    copy_status = 'pending'

    @blob.properties[:copy_status] = 'failed'
    @service.stub :get_blob_properties, @blob do
      @service.stub :delete_blob, true do
        assert_raises(RuntimeError) do
          @service.wait_blob_copy_operation_to_finish('test_container', 'test_blob', copy_id, copy_status)
        end
      end
    end
  end

  def test_wait_blob_copy_operation_to_finish_with_fail_when_delete_blob_http_exception
    copy_id = @blob.properties[:copy_id]
    copy_status = 'pending'

    @blob.properties[:copy_status] = 'failed'
    http_exception = ->(*) { raise Azure::Core::Http::HTTPError.new(@mocked_response) }
    @service.stub :get_blob_properties, @blob do
      @service.stub :delete_blob, http_exception do
        assert_raises(RuntimeError) do
          @service.wait_blob_copy_operation_to_finish('test_container', 'test_blob', copy_id, copy_status)
        end
      end
    end
  end

  def test_wait_blob_copy_operation_to_finish_mock
    assert @mock_service.wait_blob_copy_operation_to_finish('test_container', 'test_blob', 'copy_id', 'pending')
  end
end
