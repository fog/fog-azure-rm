require 'fog/azurerm'
require 'yaml'

# Network Security Rule Integration Test using RSpec

describe 'Integration Testing of Network Security Rule' do
  before :all do
    azure_credentials = YAML.load_file(File.expand_path('credentials/azure.yml', __dir__))

    @rs = Fog::Resources::AzureRM.new(
      tenant_id: azure_credentials['tenant_id'],
      client_id: azure_credentials['client_id'],
      client_secret: azure_credentials['client_secret'],
      subscription_id: azure_credentials['subscription_id']
    )

    @network = Fog::Network::AzureRM.new(
      tenant_id: azure_credentials['tenant_id'],
      client_id: azure_credentials['client_id'],
      client_secret: azure_credentials['client_secret'],
      subscription_id: azure_credentials['subscription_id']
    )

    @location = 'eastus'
    @net_sec_group_name = 'testNetSecGroup'
    @net_sec_rule_name = 'testRule'

    @resource_group = @rs.resource_groups.create(
      name: 'TestRG-NSR',
      location: @location
    )

    @net_sec_group = @network.network_security_groups.create(
      name: @net_sec_group_name,
      resource_group: @resource_group.name,
      location: LOCATION
    )

    @security_rule = {
      name: @net_sec_rule_name,
      resource_group: @resource_group.name,
      protocol: Fog::ARM::Network::Models::SecurityRuleProtocol::Tcp,
      network_security_group_name: @net_sec_group_name,
      source_port_range: '22',
      destination_port_range: '22',
      source_address_prefix: '0.0.0.0/0',
      destination_address_prefix: '0.0.0.0/0',
      access: Fog::ARM::Network::Models::SecurityRuleAccess::Allow,
      priority: '100',
      direction: Fog::ARM::Network::Models::SecurityRuleDirection::Inbound
    }
  end

  describe 'Check Existence' do
    before 'checks existence of network security rule' do
      @nsr_exists = @network.network_security_rules.check_net_sec_rule_exists(@resource_group.name, @net_sec_group_name, @net_sec_rule_name)
    end

    it 'should not exist yet' do
      expect(@nsr_exists).to eq(false)
    end
  end

  describe 'Create' do
    before :all do
      @network_security_rule = @network.network_security_rules.create(@security_rule)
    end

    it 'should have name: \'testRule\'' do
      expect(@network_security_rule.name).to eq(@security_rule[:name])
    end

    it 'should belong to resource group: \'TestRG-NSG\'' do
      expect(@network_security_rule.resource_group).to eq(@security_rule[:resource_group])
    end

    it 'should belong to network security group: \'testNetSecGroup\'' do
      expect(@network_security_rule.network_security_group_name).to eq(@security_rule[:network_security_group_name])
    end

    it 'should have protocol: \'TCP\'' do
      expect(@network_security_rule.protocol).to eq(@security_rule[:protocol])
    end
    
    it 'should have priority: \'100\'' do
      expect(@network_security_rule.priority).to eq(@security_rule[:priority].to_i)
    end

    it 'should have source_port_range & destination_port_range: \'22\'' do
      expect(@network_security_rule.source_port_range).to eq(@security_rule[:source_port_range])
      expect(@network_security_rule.destination_port_range).to eq(@security_rule[:destination_port_range])
    end

    it 'should have source_address_prefix & destination_address_prefix: \'10.0.0.0\'' do
      expect(@network_security_rule.source_address_prefix).to eq(@security_rule[:source_address_prefix])
      expect(@network_security_rule.destination_address_prefix).to eq(@security_rule[:destination_address_prefix])
    end

    it 'should have allowed access' do
      expect(@network_security_rule.access).to eq(@security_rule[:access])
    end

    it 'should have direction: Inbound' do
      expect(@network_security_rule.direction).to eq(@security_rule[:direction])
    end
  end

  describe 'Get' do
    before 'gets network security rule' do
      @network_security_rule = @network.network_security_rules.get(@resource_group.name, @net_sec_group_name, @net_sec_rule_name)
    end

    it 'should have name: \'testRule\'' do
      expect(@network_security_rule.name).to eq(@security_rule[:name])
    end
  end

  describe 'List' do
    before :all do
      @network_security_rules = @network.network_security_rules(resource_group: @resource_group.name, network_security_group_name: @net_sec_group_name)
    end

    it 'should not be empty' do
      expect(@network_security_rules.length).to_not eq(0)
    end

    it 'should contain security rule: \'testRule\'' do
      contains_nsr = false
      @network_security_rules.each do |sec_rule|
        contains_nsr = true if sec_rule.name == @net_sec_rule_name
      end
      expect(contains_nsr).to eq(true)
    end
  end

  describe 'Delete' do
    before 'gets network security group' do
      @network_security_group = @network.network_security_groups.get(@resource_group.name, @net_sec_group_name)
    end

    it 'should not exist anymore' do
      expect(@network_security_group.destroy).to eq(true)
      expect(@resource_group.destroy).to eq(true)
    end
  end

end