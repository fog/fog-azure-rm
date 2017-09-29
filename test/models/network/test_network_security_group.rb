require File.expand_path '../../test_helper', __dir__

# Test class for Network Security Group Model
class TestNetworkSecurityGroup < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @client = @service.instance_variable_get(:@network_client)
    @network_security_group = network_security_group(@service)
    @response = ApiStub::Models::Network::NetworkSecurityGroup.create_network_security_group_response(@client)
  end

  def test_model_methods
    methods = [
      :save,
      :destroy,
      :update_security_rules,
      :add_security_rules,
      :remove_security_rule
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
      :default_security_rules,
      :tags
    ]
    attributes.each do |attribute|
      assert_respond_to @network_security_group, attribute
    end
  end

  def test_save_method_response
    @service.stub :create_or_update_network_security_group, @response do
      assert_instance_of Fog::Network::AzureRM::NetworkSecurityGroup, @network_security_group.save
    end
  end

  def test_destroy_method_response
    @service.stub :delete_network_security_group, true do
      assert @network_security_group.destroy
    end
  end

  def test_update_method_response
    @service.stub :create_or_update_network_security_group, @response do
      assert_instance_of Fog::Network::AzureRM::NetworkSecurityGroup,
                         @network_security_group.update_security_rules(
                           security_rules:
                             [
                               {
                                 name: 'testRule',
                                 protocol: 'tcp',
                                 source_port_range: '*',
                                 destination_port_range: '*',
                                 source_address_prefix: '0.0.0.0/0',
                                 destination_address_prefix: '0.0.0.0/0',
                                 access: 'Allow',
                                 priority: '100',
                                 direction: 'Inbound'
                               }
                             ]
                         )
    end
  end

  def test_add_security_rules_method_response
    @service.stub :add_security_rules, @response do
      assert_instance_of Fog::Network::AzureRM::NetworkSecurityGroup, @network_security_group.add_security_rules(ApiStub::Models::Network::NetworkSecurityGroup.security_rules_array)
    end
  end

  def test_remove_security_rule_method_response
    @service.stub :remove_security_rule, @response do
      assert_instance_of Fog::Network::AzureRM::NetworkSecurityGroup, @network_security_group.remove_security_rule('myNsRule')
    end
  end
end
