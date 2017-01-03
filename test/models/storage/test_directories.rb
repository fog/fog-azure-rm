require File.expand_path '../../test_helper', __dir__

# Test class for Container Collection
class TestDirectories < Minitest::Test
  def setup
    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @directories = Fog::Storage::AzureRM::Directories.new(service: @service)

    @container_list = ApiStub::Models::Storage::Directory.container_list
    @container = ApiStub::Models::Storage::Directory.container
    @blob_list = ApiStub::Models::Storage::Directory.blob_list
  end

  def test_collection_methods
    methods = [
      :all,
      :get,
      :check_container_exists?
    ]
    methods.each do |method|
      assert_respond_to @directories, method
    end
  end

  def test_all_method_success
    @service.stub :list_containers, @container_list do
      dirs = @directories.all
      assert_instance_of Fog::Storage::AzureRM::Directories, dirs
      assert_equal @container_list.size, dirs.size
      dirs.each do |directory|
        assert_instance_of Fog::Storage::AzureRM::Directory, directory
        assert_equal 'unknown', directory.attributes[:acl]
      end
    end
  end

  def test_get_method_success
    @service.stub :get_container_properties, @container do
      @service.stub :list_blobs, @blob_list do
        directory = @directories.get('test_container')
        assert_instance_of Fog::Storage::AzureRM::Directory, directory
        assert_equal 'unknown', directory.attributes[:acl]
      end
    end
  end

  def test_get_method_container_not_found
    exception = ->(*) { raise 'NotFound' }
    @service.stub :get_container_properties, exception do
      assert @directories.get('test_container').nil?
    end
  end

  def test_get_method_exception
    exception = ->(*) { raise 'Error' }
    @service.stub :get_container_properties, exception do
      assert_raises(RuntimeError) do
        @directories.get('test_container')
      end
    end
  end

  def test_check_container_exists_true_response
    @service.stub :check_container_exists?, true do
      assert @directories.check_container_exists?('test_container')
    end
  end

  def test_check_container_exists_false_response
    @service.stub :check_container_exists?, false do
      assert !@directories.check_container_exists?('test_container')
    end
  end
end
