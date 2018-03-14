require 'fog/azurerm'
require 'yaml'

# Network Security Group Integration Test using RSpec

describe 'Integration Testing of Network Security Group' do
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
    @security_rules = [
      {
          name: 'testRule',
          protocol: Fog::ARM::Network::Models::SecurityRuleProtocol::Tcp,
          source_port_range: '22',
          destination_port_range: '22',
          source_address_prefix: '0.0.0.0/0',
          destination_address_prefix: '0.0.0.0/0',
          access: Fog::ARM::Network::Models::SecurityRuleAccess::Allow,
          priority: 500,
          direction: Fog::ARM::Network::Models::SecurityRuleDirection::Inbound
      }
    ]
    
    @resource_group = @rs.resource_groups.create(
      name: 'TestRG-NSG',
      location: @location
    )
  end

  describe 'Check Existence' do
    before 'checks existence' do
      @nsg_exists = @network.network_security_groups.check_net_sec_group_exists(@resource_group.name, @net_sec_group_name)
    end

    it 'should not exist yet' do
      expect(@nsg_exists).to eq(false)
    end
  end

  describe 'Create' do
    before :all do
      @tags = { key1: 'value1', key2: 'value2' }
      
      @network_security_group = @network.network_security_groups.create(
        name: @net_sec_group_name,
        resource_group: @resource_group.name,
        location: @location,
        security_rules: @security_rules,
        tags: @tags
      )
    end

    it 'should have name: \'testNetSecGroup\'' do
      expect(@network_security_group.name).to eq(@net_sec_group_name)
    end

    it 'should exist in location: \'eastus\'' do
      expect(@network_security_group.location).to eq(@location)
    end

    it 'should exist in resource group: \'TestRG-NSG\'' do
      expect(@network_security_group.resource_group).to eq(@resource_group.name)
    end

    it 'should have the correct security rules setting' do
      @security_rules.count.times do |i|
        expect(@security_rules[i][:name]).to eq(@network_security_group.security_rules[i].name)
        expect(@security_rules[i][:protocol]).to eq(@network_security_group.security_rules[i].protocol)
        expect(@security_rules[i][:source_port_range]).to eq(@network_security_group.security_rules[i].source_port_range)
        expect(@security_rules[i][:destination_port_range]).to eq(@network_security_group.security_rules[i].destination_port_range)
        expect(@security_rules[i][:source_address_prefix]).to eq(@network_security_group.security_rules[i].source_address_prefix)
        expect(@security_rules[i][:destination_address_prefix]).to eq(@network_security_group.security_rules[i].destination_address_prefix)
        expect(@security_rules[i][:access]).to eq(@network_security_group.security_rules[i].access)
        expect(@security_rules[i][:priority]).to eq(@network_security_group.security_rules[i].priority)
        expect(@security_rules[i][:direction]).to eq(@network_security_group.security_rules[i].direction)
      end
    end

    it 'should contain tag values \'value1\' and \'value2\'' do
      expect(@network_security_group.tags['key1']).to eq(@tags[:key1])
      expect(@network_security_group.tags['key2']).to eq(@tags[:key2])
    end
  end

  describe 'Get' do
    before 'gets network security group' do
      @network_security_group = @network.network_security_groups.get(@resource_group.name, @net_sec_group_name)
    end

    it 'should have name: \'testNetSecGroup\'' do
      expect(@network_security_group.name).to eq(@net_sec_group_name)
    end
  end

  describe 'Update Security Rule' do
    before 'updates security rule' do
      @network_security_group = @network.network_security_groups.get(@resource_group.name, @net_sec_group_name)
      @security_rules[0][:priority] = 500
      temp_nsg_hash = {security_rules: @security_rules}
      @updated_nsg = @network_security_group.update_security_rules(temp_nsg_hash)
    end

    it 'should have updated the security rule \'testRule\' correctly' do
      @security_rules.count.times do |i|
        expect(@security_rules[i][:name]).to eq(@updated_nsg.security_rules[i].name)
        expect(@security_rules[i][:protocol]).to eq(@updated_nsg.security_rules[i].protocol)
        expect(@security_rules[i][:source_port_range]).to eq(@updated_nsg.security_rules[i].source_port_range)
        expect(@security_rules[i][:destination_port_range]).to eq(@updated_nsg.security_rules[i].destination_port_range)
        expect(@security_rules[i][:source_address_prefix]).to eq(@updated_nsg.security_rules[i].source_address_prefix)
        expect(@security_rules[i][:destination_address_prefix]).to eq(@updated_nsg.security_rules[i].destination_address_prefix)
        expect(@security_rules[i][:access]).to eq(@updated_nsg.security_rules[i].access)
        expect(@security_rules[i][:priority]).to eq(@updated_nsg.security_rules[i].priority)
        expect(@security_rules[i][:direction]).to eq(@updated_nsg.security_rules[i].direction)
      end
    end
  end

  describe 'Add Security Rule' do
    before 'adds a new security rule' do
      @network_security_group = @network.network_security_groups.get(@resource_group.name, @net_sec_group_name)
      
      new_security_rules = [
        {
          name: 'testRule2',
          protocol: Fog::ARM::Network::Models::SecurityRuleProtocol::Tcp,
          source_port_range: '22',
          destination_port_range: '22',
          source_address_prefix: '0.0.0.0/0',
          destination_address_prefix: '0.0.0.0/0',
          access: Fog::ARM::Network::Models::SecurityRuleAccess::Allow,
          priority: 102,
          direction: Fog::ARM::Network::Models::SecurityRuleDirection::Inbound
        }
      ]
      @security_rules << new_security_rules[0]
      @updated_nsg = @network_security_group.add_security_rules(new_security_rules)
    end

    it 'should have added a new security rule \'testRule2\' correctly' do
      @security_rules.count.times do |i|
        expect(@security_rules[i][:name]).to eq(@updated_nsg.security_rules[i].name)
        expect(@security_rules[i][:protocol]).to eq(@updated_nsg.security_rules[i].protocol)
        expect(@security_rules[i][:source_port_range]).to eq(@updated_nsg.security_rules[i].source_port_range)
        expect(@security_rules[i][:destination_port_range]).to eq(@updated_nsg.security_rules[i].destination_port_range)
        expect(@security_rules[i][:source_address_prefix]).to eq(@updated_nsg.security_rules[i].source_address_prefix)
        expect(@security_rules[i][:destination_address_prefix]).to eq(@updated_nsg.security_rules[i].destination_address_prefix)
        expect(@security_rules[i][:access]).to eq(@updated_nsg.security_rules[i].access)
        expect(@security_rules[i][:priority]).to eq(@updated_nsg.security_rules[i].priority)
        expect(@security_rules[i][:direction]).to eq(@updated_nsg.security_rules[i].direction)
      end
    end
  end

  describe 'Remove Security Rule' do
    before 'removes security rule' do
      @network_security_group = @network.network_security_groups.get(@resource_group.name, @net_sec_group_name)
      @rule_removed = @network_security_group.remove_security_rule('testRule')
    end

    it 'should have removed the security rule \'testRule\'' do
      expect(@rule_removed).not_to eq(nil)
    end
  end

  describe 'List' do
    before :all do
      @network_security_groups_list = @network.network_security_groups(resource_group: @resource_group.name)
    end

    it 'should not be empty' do
      expect(@network_security_groups_list.length).to_not eq(0)
    end

    it 'should contain \'testNetSecGroup\'' do
      contains_nsg = false
      @network_security_groups_list.each do |sec_group|
        contains_nsg = true if sec_group.name == @net_sec_group_name
      end
      expect(contains_nsg).to eq(true)
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