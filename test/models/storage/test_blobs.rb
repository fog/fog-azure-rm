require File.expand_path '../../test_helper', __dir__

# Test class for Blob Collection
class TestBlobs < Minitest::Test
  def setup
    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blobs = Fog::Storage::AzureRM::Blobs.new(service: @service)
    @response = ApiStub::Models::Storage::Blob.test_get_blob_metadata
  end

  def test_collection_methods
    methods = [
      :set_blob_metadata,
      :get_blob_metadata
    ]
    methods.each do |method|
      assert @blobs.respond_to? method, true
    end
  end

  def test_get_blob_metadata
    @service.stub :get_blob_metadata, @response do
      assert_equal @response, @blobs.get_blob_metadata('Test-container', 'Test_Blob')
    end
  end

  def test_set_blob_metadata
    @service.stub :set_blob_metadata, true do
      assert @blobs.set_blob_metadata('Test-container', 'Test_Blob', @response)
    end
  end
end
