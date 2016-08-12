require File.expand_path '../../test_helper', __dir__

# Test class for Storage Container Model
class TestBlob < Minitest::Test
  def setup
    Fog.mock!
    @mock_service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @mock_blob = storage_blob(@mock_service)
    Fog.unmock!
    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob = storage_blob(@service)
    @cloud_blob = storage_cloud_blob
    @blob_client = @service.instance_variable_get(:@blob_client)
    @mocked_response = mocked_storage_http_error
    @content = Array.new(1024 * 1024) { 'a' }.join
    @get_metadata_result = ApiStub::Models::Storage::Blob.test_get_blob_metadata
    @create_result = ApiStub::Models::Storage::Blob.upload_block_blob_from_file
    @download_result = ApiStub::Models::Storage::Blob.download_blob_to_file
    @get_properties_result = ApiStub::Models::Storage::Blob.get_blob_properties
  end

  def test_model_methods
    methods = [
      :save,
      :save_to_file,
      :get_properties,
      :set_properties,
      :set_metadata,
      :get_metadata,
      :destroy
    ]
    methods.each do |method|
      assert @blob.respond_to? method, true
    end
  end

  def test_model_attributes
    attributes = [
      :name,
      :accept_ranges,
      :cache_control,
      :committed_block_count,
      :container_name,
      :content_length,
      :content_type,
      :content_md5,
      :content_encoding,
      :content_language,
      :content_disposition,
      :copy_completion_time,
      :copy_status,
      :copy_status_description,
      :copy_id,
      :copy_progress,
      :copy_source,
      :etag,
      :lease_duration,
      :lease_state,
      :lease_status,
      :last_modified,
      :metadata,
      :sequence_number,
      :blob_type
    ]
    attributes.each do |attribute|
      assert_respond_to @blob, attribute
    end
  end

  def test_save_method_response
    @service.stub :upload_block_blob_from_file, @create_result do
      assert_instance_of Fog::Storage::AzureRM::Blob, @blob.save
    end
    @service.stub :upload_block_blob_from_file, @create_result do
      assert_instance_of Fog::Storage::AzureRM::Blob, @blob.create(file_path: 'test.txt')
    end
  end

  def test_save_small_blob_method_response
    small_file_name = 'small_test_file.dat'
    small_file = File.new(small_file_name, 'w')
    small_file.puts(@content)
    small_file.close
    @blob_client.stub :create_block_blob, @create_result do
      assert_instance_of Fog::Storage::AzureRM::Blob, @blob.create(file_path: small_file_name)
    end
    io_exception = -> (_container_name, _blob_name, _file_path, _option) { raise IOError.new }
    @blob_client.stub :create_block_blob, io_exception do
      assert_raises(RuntimeError) do
        @blob.create(file_path: small_file_name)
      end
    end
    http_exception = -> (_container_name, _blob_name, _file_path, _option) { raise Azure::Core::Http::HTTPError.new(@mocked_response) }
    @blob_client.stub :create_block_blob, http_exception do
      assert_raises(RuntimeError) do
        @blob.create(file_path: small_file_name)
      end
    end
    File.delete(small_file_name)
  end

  def test_save_large_blob_method_response
    large_file_name = 'large_test_file.dat'
    large_file = File.new(large_file_name, 'w')
    33.times do
      large_file.puts(@content)
    end
    large_file.close
    @blob_client.stub :put_blob_block, true do
      @blob_client.stub :commit_blob_blocks, @create_result do
        assert_instance_of Fog::Storage::AzureRM::Blob, @blob.create(file_path: large_file_name)
      end
    end
    File.delete(large_file_name)
  end

  def test_save_method_response_mock
    assert_instance_of Fog::Storage::AzureRM::Blob, @mock_blob.save
  end

  def test_save_to_file
    @service.stub :download_blob_to_file, @download_result do
      assert_instance_of Fog::Storage::AzureRM::Blob, @blob.save_to_file('test.txt')
    end
  end

  def test_save_to_file_io_exception
    io_exception = -> (_container_name, _blob_name, _option) { raise IOError.new }
    @blob_client.stub :get_blob, io_exception do
      assert_raises(RuntimeError) do
        @blob.save_to_file('test.txt')
      end
    end
  end

  def test_save_to_file_http_exception
    http_exception = -> (_container_name, _blob_name, _option) { raise Azure::Core::Http::HTTPError.new(@mocked_response) }
    @blob_client.stub :get_blob, http_exception do
      assert_raises(RuntimeError) do
        @blob.save_to_file('test.txt')
      end
    end
  end

  def test_save_to_file_mock
    assert_instance_of Fog::Storage::AzureRM::Blob, @mock_blob.save_to_file('test.txt')
  end

  def test_get_blob_properties
    @service.stub :get_blob_properties, @get_properties_result do
      assert_instance_of Fog::Storage::AzureRM::Blob, @blob.get_properties
    end
  end

  def test_get_cloud_blob_properties
    @service.stub :get_blob_properties, @cloud_blob do
      assert_instance_of Fog::Storage::AzureRM::Blob, @blob.get_properties
    end
  end

  def test_get_blob_properties_http_exception
    http_exception = -> (_container_name, _blob_name, _option) { raise Azure::Core::Http::HTTPError.new(@mocked_response) }
    @blob_client.stub :get_blob_properties, http_exception do
      assert_raises(RuntimeError) do
        @blob.get_properties
      end
    end
  end

  def test_get_blob_properties_mock
    assert_instance_of Fog::Storage::AzureRM::Blob, @mock_blob.get_properties
  end

  def test_set_blob_properties
    @service.stub :set_blob_properties, true do
      assert @blob.set_properties, true
    end
  end

  def test_set_blob_properties_http_exception
    http_exception = -> (_container_name, _blob_name, _properties) { raise Azure::Core::Http::HTTPError.new(@mocked_response) }
    @blob_client.stub :set_blob_properties, http_exception do
      assert_raises(RuntimeError) do
        @blob.set_properties
      end
    end
  end

  def test_set_blob_properties_mock
    assert @mock_blob.set_properties, true
  end

  def test_get_blob_metadata
    @service.stub :get_blob_metadata, @get_metadata_result do
      blob = @blob.get_metadata
      assert_instance_of Fog::Storage::AzureRM::Blob, blob
      assert_equal @get_metadata_result, blob.metadata
    end
  end

  def test_get_blob_metadata_http_exception
    http_exception = -> (_container_name, _blob_name, _option) { raise Azure::Core::Http::HTTPError.new(@mocked_response) }
    @blob_client.stub :get_blob_metadata, http_exception do
      assert_raises(RuntimeError) do
        @blob.get_metadata
      end
    end
  end

  def test_get_blob_metadata_mock
    blob = @mock_blob.get_metadata
    assert_instance_of Fog::Storage::AzureRM::Blob, blob
    assert_equal @get_metadata_result, blob.metadata
  end

  def test_set_blob_metadata
    @service.stub :set_blob_metadata, true do
      assert @blob.set_metadata(@get_metadata_result)
    end
  end

  def test_set_blob_metadata_http_exception
    http_exception = -> (_container_name, _blob_name, _metadata, _option) { raise Azure::Core::Http::HTTPError.new(@mocked_response) }
    @blob_client.stub :set_blob_metadata, http_exception do
      assert_raises(RuntimeError) do
        @blob.set_metadata(@get_metadata_result)
      end
    end
  end

  def test_set_blob_metadata_mock
    assert @mock_blob.set_metadata(@get_metadata_result)
  end

  def test_delete_method_true_response
    @service.stub :delete_blob, true do
      assert @blob.destroy
    end
  end

  def test_delete_method_exception
    exception = -> (_container_name, _blob_name, _option) { raise Azure::Core::Http::HTTPError.new(@mocked_response) }
    @blob_client.stub :delete_blob, exception do
      assert_raises(RuntimeError) do
        assert @blob.destroy
      end
    end
  end

  def test_delete_method_response_mock
    assert @mock_blob.destroy
  end
end
