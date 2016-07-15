require File.expand_path '../../test_helper', __dir__

# Test class for Container Collection
class TestContainers < Minitest::Test
  def setup
    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @containers = Fog::Storage::AzureRM::Containers.new(service: @service)
    @response = ApiStub::Models::Storage::Container.test_get_container_metadata
  end

  def test_collection_methods
    methods = [
      :set_container_metadata,
      :get_container_metadata
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
end
