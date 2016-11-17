require File.expand_path '../../test_helper', __dir__

# Test class for Storage Container Model
class TestFile < Minitest::Test
  def setup
    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @directory = directory(@service)
    @file = file(@service)
    @raw_cloud_blob = storage_blob

    @mocked_response = mocked_storage_http_error
    @blob = ApiStub::Models::Storage::File.blob
    @metadata = ApiStub::Models::Storage::File.blob_metadata
    @blob_list = ApiStub::Models::Storage::File.blob_list
    @blob_https_url = ApiStub::Models::Storage::File.blob_https_url
  end

  def test_model_methods
    methods = [
      :save,
      :body,
      :body=,
      :copy,
      :copy_from_uri,
      :destroy,
      :public?,
      :public_url,
      :url
    ]
    methods.each do |method|
      assert_respond_to @file, method
    end
  end

  def test_model_attributes
    attributes = [
      :key,
      :body,
      :directory,
      :accept_ranges,
      :content_length,
      :content_type,
      :content_md5,
      :content_encoding,
      :content_language,
      :cache_control,
      :content_disposition,
      :copy_completion_time,
      :copy_status,
      :copy_status_description,
      :copy_id,
      :copy_progress,
      :copy_source,
      :etag,
      :last_modified,
      :lease_duration,
      :lease_state,
      :lease_status,
      :sequence_number,
      :blob_type,
      :metadata
    ]
    attributes.each do |attribute|
      assert_respond_to @file, attribute
    end
  end

  def test_save_method_with_small_block_blob_success
    @file.body = 'd' * 1025 # SINGLE_BLOB_PUT_THRESHOLD is 32 * 1024 * 1024

    @service.stub :create_block_blob, @raw_cloud_blob do
      assert @file.save
    end
  end

  def test_save_method_with_large_block_blob_success
    @file.body = 'd' * (32 * 1024 * 1024 + 1) # SINGLE_BLOB_PUT_THRESHOLD is 32 * 1024 * 1024

    @service.stub :multipart_save_block_blob, true do
      @service.stub :get_blob_properties, @raw_cloud_blob do
        assert @file.save
      end
    end
  end

  def test_save_method_with_page_blob_success
    options = { blob_type: 'PageBlob' }
    @file.metadata = @metadata
    @file.body = 'd' * 5 * 1024 * 1024 # MAXIMUM_CHUNK_SIZE is 4 * 1024 * 1024

    @service.stub :save_page_blob, true do
      @service.stub :get_blob_properties, @raw_cloud_blob do
        assert @file.save(options)
      end
    end
  end

  def test_save_method_with_not_update_body_success
    options = { update_body: false }
    @file.metadata = @metadata

    @service.stub :put_blob_metadata, true do
      @service.stub :put_blob_properties, true do
        @service.stub :get_blob_properties, @raw_cloud_blob do
          assert @file.save(options)
        end
      end
    end
  end

  def test_save_method_without_directory_exception
    assert_raises(ArgumentError) do
      @file.attributes.delete(:directory)
      @file.save
    end
  end

  def test_save_method_without_key_exception
    assert_raises(ArgumentError) do
      @file.attributes.delete(:key)
      @file.save
    end
  end

  def test_save_method_create_without_body_exception
    assert_raises(ArgumentError) do
      @file.attributes.delete(:body)
      @file.save
    end
  end

  def test_get_body_method_local_success
    @file.attributes[:body] = 'body'
    assert_equal 'body', @file.body

    @file.attributes[:body] = nil
    @file.attributes[:last_modified] = nil
    assert_equal '', @file.body
  end

  def test_get_body_method_remote_success
    @file.attributes[:body] = nil
    remote_file = @file.dup
    body_content = 'data'
    @file.collection.stub :get, remote_file do
      remote_file.stub :body, body_content do
        body = @file.body
        assert_equal body_content, body
        assert_equal body_content, @file.attributes[:body]
      end
    end
  end

  def test_get_body_method_remote_not_found_success
    @file.attributes[:body] = nil
    @file.collection.stub :get, nil do
      body = @file.body
      assert_equal '', body
      assert_equal '', @file.attributes[:body]
    end
  end

  def test_set_body_method_success
    @file.body = 'new_body'
    assert_equal 'new_body', @file.attributes[:body]
  end

  def test_copy_method_success
    copy_id = @raw_cloud_blob.properties[:copy_id]
    copy_status = 'pending'

    @service.stub :get_blob_properties, @raw_cloud_blob do
      @service.stub :copy_blob, [copy_id, copy_status] do
        @service.stub :wait_blob_copy_operation_to_finish, true do
          target_file = @file.copy('target_container', 'target_blob')
          assert_instance_of Fog::Storage::AzureRM::File, target_file
        end
      end
    end
  end

  def test_copy_from_uri_method_success
    copy_id = @raw_cloud_blob.properties[:copy_id]
    copy_status = 'pending'

    @service.stub :get_blob_properties, @raw_cloud_blob do
      @service.stub :copy_blob_from_uri, [copy_id, copy_status] do
        @service.stub :wait_blob_copy_operation_to_finish, true do
          assert @file.copy_from_uri('source_uri')
        end
      end
    end
  end

  def test_copy_from_uri_method_without_directory_exception
    assert_raises(ArgumentError) do
      @file.attributes.delete(:directory)
      @file.copy_from_uri('source_uri')
    end
  end

  def test_copy_from_uri_method_without_key_exception
    assert_raises(ArgumentError) do
      @file.attributes.delete(:key)
      @file.copy_from_uri('source_uri')
    end
  end

  def test_destroy_method_success
    @service.stub :delete_blob, true do
      assert @file.destroy
      assert @file.attributes[:body].nil?
    end
  end

  def test_destroy_method_without_directory_exception
    assert_raises(ArgumentError) do
      @file.attributes.delete(:directory)
      @file.destroy
    end
  end

  def test_destroy_method_without_key_exception
    assert_raises(ArgumentError) do
      @file.attributes.delete(:key)
      @file.destroy
    end
  end

  def test_public_method_success
    @file.directory.acl = 'container'
    assert @file.public?

    @file.directory.acl = 'blob'
    assert @file.public?

    @file.directory.acl = nil
    assert !@file.public?
  end

  def test_public_method_without_directory_exception
    assert_raises(ArgumentError) do
      @file.attributes.delete(:directory)
      @file.public?
    end
  end

  def test_public_url_method_success
    @file.stub :public?, false do
      assert @file.public_url.nil?
    end

    @file.stub :public?, true do
      @service.stub :get_blob_url, @blob_https_url do
        assert @file.public_url, @blob_https_url
      end
    end

    http_url = @blob_https_url.gsub('https:', 'http:')
    options = { scheme: 'https' }
    @file.stub :public?, true do
      @service.stub :get_blob_url, http_url do
        assert @file.public_url(options), http_url
      end
    end
  end

  def test_public_url_method_without_directory_exception
    assert_raises(ArgumentError) do
      @file.attributes.delete(:directory)
      @file.public_url
    end
  end

  def test_public_url_method_without_key_exception
    assert_raises(ArgumentError) do
      @file.attributes.delete(:key)
      @file.public_url
    end
  end

  def test_url_method_success
    @file.collection.stub :get_url, @blob_https_url do
      assert @file.url(Time.now + 3600), @blob_https_url
    end
  end

  def test_url_method_without_key_exception
    assert_raises(ArgumentError) do
      @file.attributes.delete(:key)
      @file.url(Time.now + 3600)
    end
  end
end
