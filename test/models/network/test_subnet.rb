require File.expand_path '../../test_helper', __dir__

class TestSubnet < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @subnet = subnet(@service)
  end

  def test_model_methods
    response = ApiStub::Models::Network::Subnet.create_subnet_response
    methods = [
      :save,
      :destroy
    ]
    @service.stub :create_subnet, response do
      methods.each do |method|
        assert @subnet.respond_to? method
      end
    end
  end

  def test_model_attributes
    response = ApiStub::Models::Network::Subnet.create_subnet_response
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
    response = ApiStub::Models::Network::Subnet.create_subnet_response
    @service.stub :create_subnet, response do
      assert_instance_of Fog::Network::AzureRM::Subnet, @subnet.save
    end
  end

  def test_destroy_method_response
    @service.stub :delete_subnet, true do
      assert @subnet.destroy
    end
  end
end
