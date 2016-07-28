require File.expand_path '../../test_helper', __dir__

# Test class for Storage Container Model
class TestBlob < Minitest::Test
  def setup
    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob = storage_blob(@service)
    @get_properties_result = ApiStub::Models::Storage::Blob.get_blob_properties
  end

  def test_model_methods
    methods = [
      :get_properties,
      :set_properties
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

  def test_get_blob_properties
    @service.stub :get_blob_properties, @get_properties_result do
      assert_instance_of Fog::Storage::AzureRM::Blob, @blob.get_properties
    end
  end

  def test_set_blob_properties
    @service.stub :set_blob_properties, true do
      assert @blob.set_properties, true
    end
  end
end
