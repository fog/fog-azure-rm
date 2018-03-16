require 'fog/azurerm'
require 'yaml'

# Sql Serverintegration test using RSpec

describe 'Integration testing of Sql Server' do
  before :all do
    azure_credentials = YAML.load_file(File.expand_path('credentials/azure.yml', __dir__))

    @resource_service = Fog::Resources::AzureRM.new(
      tenant_id: azure_credentials['tenant_id'],
      client_id: azure_credentials['client_id'],
      client_secret: azure_credentials['client_secret'],
      subscription_id: azure_credentials['subscription_id']
    )

    @azure_sql_service = Fog::Sql::AzureRM.new(
      tenant_id: azure_credentials['tenant_id'],
      client_id: azure_credentials['client_id'],
      client_secret: azure_credentials['client_secret'],
      subscription_id: azure_credentials['subscription_id']
    )

    @resource_group_name = 'TestRG-SQL'
    @location = 'eastus2'
    @tags = { key1: 'value1', key2: 'value2' }
    @server_name = rand(0...999_99)
    @database_name = rand(0...999_99)
    @version = '12.0'
    @administrator_username = 'testserveradmin',
    @administrator_login_password = 'db@admin=123'
    @resource_group = @resource_service.resource_groups.create(name: @resource_group_name, location: @location)
  end

  describe 'Check Sql Server Existence' do
    before :all do
      @sql_server_exits = @azure_sql_service.sql_servers.check_sql_server_exists(@resource_group_name, @server_name)
    end

    it 'should not exist yet' do
      expect(@sql_server_exits).to eq(false)
    end
  end

  describe 'Create Sql Server' do
    before :all do
      @sql_server = @azure_sql_service.sql_servers.create(
        name: @server_name,
        resource_group: @resource_group_name,
        location: @location,
        tags: @tags,
        version: @version,
        administrator_username: @administrator_username,
        administrator_login_password: @administrator_login_password
      )
    end

    it "it\'s name is #{@server_name}" do
      expect(@sql_server.name).to eq(@server_name)
    end

    it 'should exist in resource group: \'TestRG-SQL\'' do
      expect(@sql_server.resource_group).to eq(@resource_group_name)
    end

    it 'it\'s in eastus' do
      expect(@sql_server.location).to eq(@location)
    end

    it 'it\'s tag values are \'value1\' and \'value2\'' do
      expect(@sql_server.tags['key1']).to eq(@tags[:key1])
      expect(@sql_server.tags['key2']).to eq(@tags[:key2])
    end
  end

  describe 'Check Sql Database Existence' do
    before :all do
      @sql_database = @azure_sql_service.sql_databases.check_database_exists(@resource_group_name, @server_name, @database_name)
    end

    it "should have name: '#{@database_name}'" do
      expect(@sql_database.name).to eq(@database_name)
    end
  end

  describe 'Create Sql Database' do
    before :all do
      @sql_database = @azure_sql_service.sql_databases.create(
        name: @database_name,
        resource_group: @resource_group_name,
        location: @location,
        tags: @tags,
        server_name: @server_name
      )
    end

    it "it\'s name is #{@database_name}" do
      expect(@sql_database.name).to eq(@database_name)
    end

    it 'should exist in resource group: \'TestRG-SQL\'' do
      expect(@sql_database.resource_group).to eq(@resource_group_name)
    end

    it 'it\'s in eastus' do
      expect(@sql_database.location).to eq(@location)
    end

    it "it's in sql server: '#{@server_name}'" do
      expect(@sql_database.server_name).to eq(@server_name)
    end

    it 'it\'s tag values are \'value1\' and \'value2\'' do
      expect(@sql_database.tags['key1']).to eq(@tags[:key1])
      expect(@sql_database.tags['key2']).to eq(@tags[:key2])
    end
  end
end
