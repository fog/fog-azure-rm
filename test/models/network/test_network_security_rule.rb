require File.expand_path '../../test_helper', __dir__

# Test class for Network Security Rule Model
class TestNetworkSecurityRule < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @client = @service.instance_variable_get(:@network_client)
    @network_security_rule = network_security_rule(@service)
  end

  def test_model_attributes
    attributes = [
      :name,
      :id,
      :resource_group,
      :network_security_group_name,
      :description,
      :protocol,
      :source_port_range,
      :destination_port_range,
      :source_address_prefix,
      :destination_address_prefix,
      :access,
      :priority,
      :direction
    ]
    attributes.each do |attribute|
      assert @network_security_rule.respond_to? attribute
    end
  end

  def test_save_method_response
    response = ApiStub::Models::Network::NetworkSecurityRule.create_network_security_rule_response(@client)
    @service.stub :create_or_update_network_security_rule, response do
      assert_instance_of Fog::Network::AzureRM::NetworkSecurityRule, @network_security_rule.save
    end
  end

  def test_destroy_method_response
    @service.stub :delete_network_security_rule, true do
      assert @network_security_rule.destroy
    end
  end
end
