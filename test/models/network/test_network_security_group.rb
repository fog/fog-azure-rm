require File.expand_path '../../test_helper', __dir__

# Test class for Network Security Group Model
class TestNetworkSecurityGroup < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_security_group = network_security_group(@service)
  end

  def test_model_methods
    methods = [
      :save,
      :destroy
    ]
    methods.each do |method|
      assert @network_security_group.respond_to? method
    end
  end

  def test_model_attributes
    attributes = [
      :name,
      :id,
      :resource_group,
      :location,
      :network_interfaces_ids,
      :subnets_ids,
      :security_rules,
      :default_security_rules
    ]
    attributes.each do |attribute|
      assert @network_security_group.respond_to? attribute
    end
  end

  def test_save_method_response
    response = ApiStub::Models::Network::NetworkSecurityGroup.create_network_security_group_response
    @service.stub :create_network_security_group, response do
      assert_instance_of Fog::Network::AzureRM::NetworkSecurityGroup, @network_security_group.save
    end
  end

  def test_destroy_method_response
    @service.stub :delete_network_security_group, true do
      assert @network_security_group.destroy
    end
  end
end
