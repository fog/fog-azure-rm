require File.expand_path '../../test_helper', __dir__

# Test class for Sql Server Firewall Rule Model
class TestFirewallRule < Minitest::Test
  def setup
    @service = Fog::Sql::AzureRM.new(credentials)
    @firewall_rule = sql_server_firewall_rule(@service)
    @firewall_client = @service.instance_variable_get(:@sql_mgmt_client)
  end

  def test_model_methods
    methods = [
      :save,
      :destroy
    ]
    methods.each do |method|
      assert_respond_to @firewall_rule, method
    end
  end

  def test_model_attributes
    attributes = [
      :name,
      :id,
      :type,
      :resource_group,
      :location,
      :start_ip,
      :end_ip,
      :server_name
    ]
    attributes.each do |attribute|
      assert_respond_to @firewall_rule, attribute
    end
  end

  def test_save_method_response
    create_response = ApiStub::Models::Sql::SqlFirewallRule.create_firewall_rule(@firewall_client)
    @service.stub :create_or_update_firewall_rule, create_response do
      assert_instance_of Fog::Sql::AzureRM::FirewallRule, @firewall_rule.save
    end
  end

  def test_destroy_method_true_response
    @service.stub :delete_firewall_rule, true do
      assert @firewall_rule.destroy
    end
  end

  def test_destroy_method_false_response
    @service.stub :delete_firewall_rule, false do
      assert !@firewall_rule.destroy
    end
  end
end
