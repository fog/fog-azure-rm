require File.expand_path '../../test_helper', __dir__

# Test class for Blob Collection
class TestBlobs < Minitest::Test
  def setup
    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blobs = Fog::Storage::AzureRM::Blobs.new(container_name: 'test-container', service: @service)
    @response = ApiStub::Models::Storage::Blob.test_get_blob_metadata
    @list_results = ApiStub::Models::Storage::Blob.list_blobs
  end

  def test_collection_methods
    methods = [
      :set_blob_metadata,
      :get_blob_metadata,
      :all,
      :get
    ]
    methods.each do |method|
      assert @blobs.respond_to? method, true
    end
  end

  def test_get_blob_metadata
    @service.stub :get_blob_metadata, @response do
      assert_equal @response, @blobs.get_blob_metadata('test-container', 'Test_Blob')
    end
  end

  def test_set_blob_metadata
    @service.stub :set_blob_metadata, true do
      assert @blobs.set_blob_metadata('test-container', 'Test_Blob', @response)
    end
  end

  def test_all_method
    @service.stub :list_blobs, @list_results do
      assert_instance_of Fog::Storage::AzureRM::Blobs, @blobs.all
      assert @blobs.all.size >= 1
      @blobs.all.each do |blob|
        assert_instance_of Fog::Storage::AzureRM::Blob, blob
      end
    end
  end

  def test_get_method
    @service.stub :list_blobs, @list_results do
      assert_instance_of Fog::Storage::AzureRM::Blob, @blobs.get('testblob1')
      assert @blobs.get('wrong-name').nil?, true
    end
  end
end
