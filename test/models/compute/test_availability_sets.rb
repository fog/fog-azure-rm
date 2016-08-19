require File.expand_path '../../test_helper', __dir__

# Test class for Availability Set Collection
class TestAvailabilitySets < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    @availability_sets = Fog::Compute::AzureRM::AvailabilitySets.new(resource_group: 'fog-test-rg', service: @service)
    client = @service.instance_variable_get(:@compute_mgmt_client)
    @response_list = [ApiStub::Models::Compute::AvailabilitySet.list_availability_set_response(client)]
    @response_get = ApiStub::Models::Compute::AvailabilitySet.get_availability_set_response(client)
  end

  def test_collection_methods
    methods = [
      :all,
      :get
    ]
    methods.each do |method|
      assert @availability_sets.respond_to? method, true
    end
  end

  def test_collection_attributes
    assert @availability_sets.respond_to? :resource_group, true
  end

  def test_all_method_response
    @service.stub :list_availability_sets, @response_list do
      assert_instance_of Fog::Compute::AzureRM::AvailabilitySets, @availability_sets.all
      assert @availability_sets.all.size >= 1
      @availability_sets.all.each do |s|
        assert_instance_of Fog::Compute::AzureRM::AvailabilitySet, s
      end
    end
  end

  def test_get_method_response
    @service.stub :get_availability_set, @response_get do
      assert_instance_of Fog::Compute::AzureRM::AvailabilitySet, @availability_sets.get('fog-test-rg', 'fog-test-availability-set')
    end
  end
end
