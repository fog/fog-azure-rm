require File.expand_path '../../test_helper', __dir__

# Test class for Traffic Manager End Point Model
class TestTrafficManagerEndPoint < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @traffic_manager_end_point = traffic_manager_end_point(@service)
  end

  def test_model_methods
    methods = [
      :save,
      :destroy
    ]
    methods.each do |method|
      assert @traffic_manager_end_point.respond_to? method
    end
  end

  def test_model_attributes
    attributes = [
      :name,
      :traffic_manager_profile_name,
      :id,
      :resource_group,
      :type,
      :target_resource_id,
      :target,
      :endpoint_status,
      :endpoint_monitor_status,
      :weight,
      :priority,
      :endpoint_location,
      :min_child_endpoints
    ]
    attributes.each do |attribute|
      assert @traffic_manager_end_point.respond_to? attribute
    end
  end

  def test_save_method_response
    response = ApiStub::Models::Network::TrafficManagerEndPoint.create_traffic_manager_end_point_response
    @service.stub :create_traffic_manager_endpoint, response do
      assert_instance_of Fog::Network::AzureRM::TrafficManagerEndPoint, @traffic_manager_end_point.save
    end
  end

  def test_destroy_method_response
    @service.stub :delete_traffic_manager_endpoint, true do
      assert @traffic_manager_end_point.destroy
    end
  end
end
