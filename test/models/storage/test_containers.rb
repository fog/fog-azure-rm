require File.expand_path '../../../test_helper', __FILE__

# Test class for Container Collection
class TestContainers < Minitest::Test
  def setup
    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @containers = Fog::Storage::AzureRM::Containers.new(service: @service)
    @response = ApiStub::Models::Storage::Container.test_get_container_metadata
    @list_results = ApiStub::Models::Storage::Container.list_containers
    @acl_results = ApiStub::Models::Storage::Container.get_container_access_control_list
  end

  def test_collection_methods
    methods = [
      :set_container_metadata,
      :get_container_metadata,
      :all,
      :get
    ]
    methods.each do |method|
      assert @containers.respond_to? method, true
    end
  end

  def test_get_container_metadata
    @service.stub :get_container_metadata, @response do
      assert_equal @response, @containers.get_container_metadata('Test-container')
    end
  end

  def test_set_container_metadata
    @service.stub :set_container_metadata, true do
      assert @containers.set_container_metadata('Test-container', @response)
    end
  end

  def test_all_method
    containers = Fog::Storage::AzureRM::Containers.new(service: @service)
    @service.stub :list_containers, @list_results do
      assert_instance_of Fog::Storage::AzureRM::Containers, containers.all
      assert containers.all.size >= 1
      containers.all.each do |container|
        assert_instance_of Fog::Storage::AzureRM::Container, container
      end
    end
  end

  def test_get_method
    @service.stub :list_containers, @list_results do
      @service.stub :get_container_access_control_list, @acl_results do
        assert_instance_of Fog::Storage::AzureRM::Container, @containers.get('testcontainer1')
        assert @containers.get('wrong-name').nil?, true
      end
    end
  end
end
