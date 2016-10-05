require File.expand_path '../../test_helper', __dir__

# Test class for Blob Collection
class TestFiles < Minitest::Test
  def setup
    Fog.mock!
    @mock_service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @mock_files = Fog::Storage::AzureRM::Files.new(directory: 'test-container', service: @mock_service)
    Fog.unmock!
    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)
    @files = Fog::Storage::AzureRM::Files.new(directory: 'test-container', service: @service)
    @mocked_response = mocked_storage_http_error
    @list_results = ApiStub::Models::Storage::File.list_blobs
  end

  def test_collection_methods
    methods = [
      :all,
      :get
    ]
    methods.each do |method|
      assert_respond_to @files, method
    end
  end

  def test_all_method
    @service.stub :list_blobs, @list_results do
      assert_instance_of Fog::Storage::AzureRM::Files, @files.all
      assert @files.all.size >= 1
      @files.all.each do |file|
        assert_instance_of Fog::Storage::AzureRM::File, file
      end
    end
  end

  def test_all_method_http_exception
    http_exception = -> (_container_name, _option) { raise Azure::Core::Http::HTTPError.new(@mocked_response) }
    @blob_client.stub :list_blobs, http_exception do
      assert_raises(RuntimeError) do
        @files.all
      end
    end
  end

  def test_all_method_mock
    assert_instance_of Fog::Storage::AzureRM::Files, @mock_files.all
    assert @mock_files.all.size >= 1
    @mock_files.all.each do |file|
      assert_instance_of Fog::Storage::AzureRM::File, file
    end
  end

  def test_get_method
    @service.stub :list_blobs, @list_results do
      assert_instance_of Fog::Storage::AzureRM::File, @files.get('test-container', 'testblob1')
      assert !@files.get('test-container', 'wrong-name').nil?
    end
  end

  def test_get_method_mock
    @service.stub :list_blobs, @list_results do
      assert_instance_of Fog::Storage::AzureRM::File, @mock_files.get('test-container', 'testblob1')
      assert !@mock_files.get('test-container', 'wrong-name').nil?
    end
  end
end
