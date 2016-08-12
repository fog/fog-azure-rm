require File.expand_path '../../test_helper', __dir__

# Test class for Blob Collection
class TestBlobs < Minitest::Test
  def setup
    Fog.mock!
    @mock_service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @mock_blobs = Fog::Storage::AzureRM::Blobs.new(container_name: 'test-container', service: @mock_service)
    Fog.unmock!
    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)
    @blobs = Fog::Storage::AzureRM::Blobs.new(container_name: 'test-container', service: @service)
    @mocked_response = mocked_storage_http_error
    @list_results = ApiStub::Models::Storage::Blob.list_blobs
  end

  def test_collection_methods
    methods = [
      :all,
      :get
    ]
    methods.each do |method|
      assert @blobs.respond_to? method, true
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

  def test_all_method_http_exception
    http_exception = -> (_container_name, _option) { raise Azure::Core::Http::HTTPError.new(@mocked_response) }
    @blob_client.stub :list_blobs, http_exception do
      assert_raises(RuntimeError) do
        @blobs.all
      end
    end
  end

  def test_all_method_mock
    assert_instance_of Fog::Storage::AzureRM::Blobs, @mock_blobs.all
    assert @mock_blobs.all.size >= 1
    @mock_blobs.all.each do |blob|
      assert_instance_of Fog::Storage::AzureRM::Blob, blob
    end
  end

  def test_get_method
    @service.stub :list_blobs, @list_results do
      assert_instance_of Fog::Storage::AzureRM::Blob, @blobs.get('test-container', 'testblob1')
      assert !@blobs.get('test-container', 'wrong-name').nil?
    end
  end

  def test_get_method_mock
    @service.stub :list_blobs, @list_results do
      assert_instance_of Fog::Storage::AzureRM::Blob, @mock_blobs.get('test-container', 'testblob1')
      assert !@mock_blobs.get('test-container', 'wrong-name').nil?
    end
  end
end
