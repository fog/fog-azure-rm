require File.expand_path '../../test_helper', __dir__

# Test class for Subnet Model
class TestSubnet < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @subnet = subnet(@service)
    @client = @service.instance_variable_get(:@network_client)
  end

  def test_model_methods
    methods = [
      :save,
      :attach_network_security_group,
      :detach_network_security_group,
      :attach_route_table,
      :detach_route_table,
      :destroy
    ]

    methods.each do |method|
      assert @subnet.respond_to? method
    end
  end

  def test_model_attributes
    response = ApiStub::Models::Network::Subnet.create_subnet_response(@client)
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
    @service.stub :create_subnet, response do
      attributes.each do |attribute|
        assert @subnet.respond_to? attribute
      end
    end
  end

  def test_save_method_response
    response = ApiStub::Models::Network::Subnet.create_subnet_response(@client)
    @service.stub :create_subnet, response do
      assert_instance_of Fog::Network::AzureRM::Subnet, @subnet.save
    end
  end

  def test_attach_network_security_group_method_response
    response = ApiStub::Models::Network::Subnet.create_subnet_response(@client)
    @service.stub :attach_network_security_group_to_subnet, response do
      assert_instance_of Fog::Network::AzureRM::Subnet, @subnet.attach_network_security_group('resource-id')
    end
  end

  def test_detach_network_security_group_method_response
    response = ApiStub::Models::Network::Subnet.create_subnet_response(@client)
    @service.stub :detach_network_security_group_from_subnet, response do
      assert_instance_of Fog::Network::AzureRM::Subnet, @subnet.detach_network_security_group
    end
  end

  def test_attach_route_table_method_response
    response = ApiStub::Models::Network::Subnet.create_subnet_response(@client)
    @service.stub :attach_route_table_to_subnet, response do
      assert_instance_of Fog::Network::AzureRM::Subnet, @subnet.attach_route_table('resource-id')
    end
  end

  def test_detach_route_table_method_response
    response = ApiStub::Models::Network::Subnet.create_subnet_response(@client)
    @service.stub :detach_route_table_from_subnet, response do
      assert_instance_of Fog::Network::AzureRM::Subnet, @subnet.detach_route_table
    end
  end

  def test_destroy_method_response
    @service.stub :delete_subnet, true do
      assert @subnet.destroy
    end
  end
end
