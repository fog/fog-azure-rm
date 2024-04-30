require 'fog/azurerm'
require 'yaml'

# Traffic Manager integration test using RSpec

describe 'Integration testing of Traffic Manager' do
  before :all do
    azure_credentials = YAML.load_file(File.expand_path('credentials/azure.yml', __dir__))

    @resource_service = Fog::Resources::AzureRM.new(
      tenant_id: azure_credentials['tenant_id'],
      client_id: azure_credentials['client_id'],
      client_secret: azure_credentials['client_secret'],
      subscription_id: azure_credentials['subscription_id']
    )

    @traffic_manager_service = Fog::TrafficManager::AzureRM.new(
      tenant_id: azure_credentials['tenant_id'],
      client_id: azure_credentials['client_id'],
      client_secret: azure_credentials['client_secret'],
      subscription_id: azure_credentials['subscription_id']
    )

    @resource_group_name = 'TestRG-TM'
    @location = 'eastus'
    @traffic_manager_profile_name = 'test-tmp'
    @traffic_manager_endpoint_name = 'myendpoint'
    @endpoint_type = 'externalEndpoints'
    @resource_group = @resource_service.resource_groups.create(name: @resource_group_name, location: @location)
  end

  describe 'Check Existence of Traffic Manager Profile' do
    before :all do
      @traffic_manager_profile_exits = @traffic_manager_service.traffic_manager_profiles.check_traffic_manager_profile_exists(@resource_group_name, @traffic_manager_profile_name)
    end

    it 'should not exist yet' do
      expect(@traffic_manager_profile_exits).to eq(false)
    end
  end

  describe 'Create Profile' do
    before :all do
      @tags = { key1: 'value1', key2: 'value2' }
      @traffic_manager_profile = @traffic_manager_service.traffic_manager_profiles.create(
        name: @traffic_manager_profile_name,
        resource_group: @resource_group_name,
        tags: @tags,
        traffic_routing_method: 'Performance',
        relative_name: 'testapplication',
        ttl: '30',
        protocol: 'http',
        port: '80',
        path: '/monitorpage.aspx',
        endpoints: [{
          name: 'endpoint1',
          type: @endpoint_type,
          target: 'test-app.com',
          endpoint_location: 'eastus',
          endpoint_status: 'Enabled',
          priority: 5,
          weight: 10
        }]
      )
    end

    it 'it\'s name is test-tmp' do
      expect(@traffic_manager_profile.name).to eq(@traffic_manager_profile_name)
    end

    it 'should exist in resource group: \'TestRG-TM\'' do
      expect(@traffic_manager_profile.resource_group).to eq(@resource_group_name.downcase)
    end

    it 'it\'s in global' do
      expect(@traffic_manager_profile.location).to eq('global')
    end

    it 'it\'s tag values are \'value1\' and \'value2\'' do
      expect(@traffic_manager_profile.tags['key1']).to eq(@tags[:key1])
      expect(@traffic_manager_profile.tags['key2']).to eq(@tags[:key2])
    end

    it 'it\'s traffic routing method is \'Performance\'' do
      expect(@traffic_manager_profile.traffic_routing_method).to eq('Performance')
    end

    it 'it\'s ttl is \'30\'' do
      expect(@traffic_manager_profile.ttl).to eq(30)
    end

    it 'it\'s protocol is \'HTTP\'' do
      expect(@traffic_manager_profile.protocol).to eq('HTTP')
    end

    it 'it\'s port is \'80\'' do
      expect(@traffic_manager_profile.port).to eq(80)
    end
  end

  describe 'Check Existence of Traffic Manager Endpoint' do
    before :all do
      @traffic_manager_endpoint_exits = @traffic_manager_service.traffic_manager_end_points.check_traffic_manager_endpoint_exists(@resource_group_name, @traffic_manager_profile_name, @traffic_manager_endpoint_name, @endpoint_type)
    end

    it 'should not exist yet' do
      expect(@traffic_manager_endpoint_exits).to eq(false)
    end
  end

  describe 'Create Endpoint' do
    before :all do
      @traffic_manager_endpoint = @traffic_manager_service.traffic_manager_end_points.create(
        name: @traffic_manager_endpoint_name,
        resource_group: @resource_group_name,
        traffic_manager_profile_name: @traffic_manager_profile_name,
        type: @endpoint_type,
        target: 'test-app1.com',
        endpoint_location: @location
      )
    end

    it 'it\'s name is: \'myendpoint\'' do
      expect(@traffic_manager_endpoint.name).to eq(@traffic_manager_endpoint_name)
    end

    it 'should exist in resource group: \'TestRG-TM\'' do
      expect(@traffic_manager_endpoint.resource_group).to eq(@resource_group_name.downcase)
    end

    it 'it\'s endpoint location is: \'East US\'' do
      expect(@traffic_manager_endpoint.endpoint_location).to eq('East US')
    end

    it 'it\'s type is: \'externalEndpoints\'' do
      expect(@traffic_manager_endpoint.type).to eq(@endpoint_type)
    end

    it 'it\'s in: \'test-tmp\' profile' do
      expect(@traffic_manager_endpoint.traffic_manager_profile_name).to eq(@traffic_manager_profile_name)
    end

    it 'it\'s target is: \'test-app1.com\'' do
      expect(@traffic_manager_endpoint.target).to eq('test-app1.com')
    end
  end

  describe 'Get Endpoint' do
    before :all do
      @traffic_manager_endpoint = @traffic_manager_service.traffic_manager_end_points.get(@resource_group_name, @traffic_manager_profile_name, @traffic_manager_endpoint_name, @endpoint_type)
    end

    it 'should have name: \'myendpoint\'' do
      expect(@traffic_manager_endpoint.name).to eq(@traffic_manager_endpoint_name)
    end
    it 'should have profile: \'test-tmp\'' do
      expect(@traffic_manager_endpoint.traffic_manager_profile_name).to eq(@traffic_manager_profile_name)
    end
  end

  describe 'Update Endpoint' do
    before :all do
      @traffic_manager_endpoint = @traffic_manager_service.traffic_manager_end_points.get(@resource_group_name, @traffic_manager_profile_name, @traffic_manager_endpoint_name, @endpoint_type)
      @traffic_manager_endpoint.update(
        type: @endpoint_type,
        target: 'test-app2.com',
        endpoint_location: 'centralus'
      )
    end

    it 'it\'s endpoint location is: \'Central US\'' do
      expect(@traffic_manager_endpoint.endpoint_location).to eq('Central US')
    end

    it 'it\'s type is \'externalEndpoints\'' do
      expect(@traffic_manager_endpoint.type).to eq(@endpoint_type)
    end

    it 'it\'s target is: \'test-app2.com\'' do
      expect(@traffic_manager_endpoint.target).to eq('test-app2.com')
    end
  end

  describe 'Delete Endpoint' do
    before :all do
      @traffic_manager_endpoint = @traffic_manager_service.traffic_manager_end_points.get(@resource_group_name, @traffic_manager_profile_name, @traffic_manager_endpoint_name, @endpoint_type)
    end

    it 'should not exist anymore' do
      expect(@traffic_manager_endpoint.destroy).to eq(true)
    end
  end

  describe 'Get Profile' do
    before :all do
      @traffic_manager_profile = @traffic_manager_service.traffic_manager_profiles.get(@resource_group_name, @traffic_manager_profile_name)
    end

    it 'should have name: \'test-tmp\'' do
      expect(@traffic_manager_profile.name).to eq(@traffic_manager_profile_name)
    end
  end

  describe 'Update Profile' do
    before :all do
      @traffic_manager_profile = @traffic_manager_service.traffic_manager_profiles.get(@resource_group_name, @traffic_manager_profile_name)
      @traffic_manager_profile.update(
        traffic_routing_method: 'Weighted',
        ttl: '35',
        protocol: 'https',
        port: '90',
        path: '/monitorpage1.aspx'
      )
    end

    it 'it\'s traffic routing method is \'Weighted\'' do
      expect(@traffic_manager_profile.traffic_routing_method).to eq('Weighted')
    end

    it 'it\'s ttl is \'35\'' do
      expect(@traffic_manager_profile.ttl).to eq(35)
    end

    it 'it\'s protocol is \'HTTPS\'' do
      expect(@traffic_manager_profile.protocol).to eq('HTTPS')
    end

    it 'it\'s port is \'90\'' do
      expect(@traffic_manager_profile.port).to eq(90)
    end
  end

  describe 'Delete Profile' do
    before :all do
      @traffic_manager_profile = @traffic_manager_service.traffic_manager_profiles.get(@resource_group_name, @traffic_manager_profile_name)
    end

    it 'should not exist anymore' do
      expect(@traffic_manager_profile.destroy).to eq(true)
      expect(@resource_group.destroy).to eq(true)
    end
  end
end
