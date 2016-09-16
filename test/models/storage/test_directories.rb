require File.expand_path '../../test_helper', __dir__

# Test class for Container Collection
class TestDirectories < Minitest::Test
  def setup
    Fog.mock!
    @mock_service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @mock_directories = Fog::Storage::AzureRM::Directories.new(service: @mock_service)
    Fog.unmock!
    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)
    @directories = Fog::Storage::AzureRM::Directories.new(service: @service)
    @get_metadata_result = ApiStub::Models::Storage::Directory.test_get_container_metadata
    @list_results = ApiStub::Models::Storage::Directory.list_containers
    @acl_results = ApiStub::Models::Storage::Directory.get_container_access_control_list
    @mocked_response = mocked_storage_http_error
  end

  def test_collection_methods
    methods = [
      :get_metadata,
      :set_metadata,
      :all,
      :get
    ]
    methods.each do |method|
      assert @directories.respond_to? method, true
    end
  end

  def test_all_method_http_exception
    http_exception = -> (_option) { raise Azure::Core::Http::HTTPError.new(@mocked_response) }
    @blob_client.stub :list_containers, http_exception do
      assert_raises(RuntimeError) do
        @directories.all
      end
    end
  end

  def test_all_method_mock
    assert_instance_of Fog::Storage::AzureRM::Directories, @mock_directories.all
    assert @mock_directories.all.size >= 1
    @mock_directories.all.each do |directory|
      assert_instance_of Fog::Storage::AzureRM::Directory, directory
    end
  end

  def test_get_container_metadata
    @service.stub :get_container_metadata, @get_metadata_result do
      assert_equal @get_metadata_result, @directories.get_metadata('Test-container')
    end
  end

  def test_get_container_metadata_http_exception
    http_exception = -> (_container_name, _option) { raise Azure::Core::Http::HTTPError.new(@mocked_response) }
    @blob_client.stub :get_container_metadata, http_exception do
      assert_raises(RuntimeError) do
        @directories.get_metadata 'Test-container'
      end
    end
  end

  def test_get_container_metadata_mock
    directory = @mock_directories.get_metadata 'Test-container'
    assert_instance_of Hash, directory
  end

  def test_set_container_metadata
    @service.stub :set_container_metadata, true do
      assert @directories.set_metadata('Test-container', @get_metadata_result)
    end
  end

  def test_set_container_metadata_http_exception
    http_exception = -> (_container_name, _metadata, _option) { raise Azure::Core::Http::HTTPError.new(@mocked_response) }
    @blob_client.stub :set_container_metadata, http_exception do
      assert_raises(RuntimeError) do
        @directories.set_metadata 'Test-container', @get_metadata_result
      end
    end
  end

  def test_set_container_metadata_mock
    assert @mock_directories.set_metadata('Test-container', @get_metadata_result)
  end

  def test_all_method
    directories = Fog::Storage::AzureRM::Directories.new(service: @service)
    @service.stub :list_containers, @list_results do
      assert_instance_of Fog::Storage::AzureRM::Directories, directories.all
      assert directories.all.size >= 1
      directories.all.each do |directory|
        assert_instance_of Fog::Storage::AzureRM::Directory, directory
      end
    end
  end

  def test_get_method
    @service.stub :list_containers, @list_results do
      @service.stub :get_container_access_control_list, @acl_results do
        assert_instance_of Fog::Storage::AzureRM::Directory, @directories.get('testcontainer1')
        assert @directories.get('wrong-name').nil?, true
      end
    end
  end
end
