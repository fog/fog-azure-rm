require File.expand_path '../../test_helper', __dir__

# Test class for Subnet Model
class TestSubnet < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @subnet = subnet(@service)
    network_client = @service.instance_variable_get(:@network_client)
    @response = ApiStub::Models::Network::Subnet.create_subnet_response(network_client)
  end

  def test_model_methods
    methods = [
      :save,
      :attach_network_security_group,
      :detach_network_security_group,
      :attach_route_table,
      :detach_route_table,
      :get_available_ipaddresses_count,
      :destroy
    ]

    methods.each do |method|
      assert_respond_to @subnet, method
    end
  end

  def test_model_attributes
    attributes = [
      :name,
      :id,
      :resource_group,
      :virtual_network_name,
      :address_prefix,
      :network_security_group_id,
      :route_table_id,
      :ip_configurations_ids
    ]
    attributes.each do |attribute|
      assert_respond_to @subnet, attribute
    end
  end

  def test_save_method_response
    @service.stub :create_subnet, @response do
      assert_instance_of Fog::Network::AzureRM::Subnet, @subnet.save
    end
  end

  def test_attach_network_security_group_method_response
    @service.stub :attach_network_security_group_to_subnet, @response do
      assert_instance_of Fog::Network::AzureRM::Subnet, @subnet.attach_network_security_group('resource-id')
    end
  end

  def test_detach_network_security_group_method_response
    @service.stub :detach_network_security_group_from_subnet, @response do
      assert_instance_of Fog::Network::AzureRM::Subnet, @subnet.detach_network_security_group
    end
  end

  def test_attach_route_table_method_response
    @service.stub :attach_route_table_to_subnet, @response do
      assert_instance_of Fog::Network::AzureRM::Subnet, @subnet.attach_route_table('resource-id')
    end
  end

  def test_detach_route_table_method_response
    @service.stub :detach_route_table_from_subnet, @response do
      assert_instance_of Fog::Network::AzureRM::Subnet, @subnet.detach_route_table
    end
  end

  def test_get_available_ipaddresses_count_response
    assert_instance_of Fixnum, @subnet.get_available_ipaddresses_count(false)
  end

  def test_destroy_method_response
    @service.stub :delete_subnet, true do
      assert @subnet.destroy
    end
  end
end
