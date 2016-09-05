require File.expand_path '../../test_helper', __dir__

# Test class for Network Security Rule Model
class TestNetworkSecurityRule < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
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
end
