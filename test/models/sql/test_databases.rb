require File.expand_path '../../test_helper', __dir__

# Test class for Database Collection
class TestDatabases < Minitest::Test
  def setup
    @service = Fog::Sql::AzureRM.new(credentials)
    @databases = Fog::Sql::AzureRM::SqlDatabases.new(resource_group: 'fog-test-rg', server_name: 'fog-test-server-name', name: 'database-name', location: 'eastus', service: @service)
    @list_database_response = [ApiStub::Models::Sql::SqlDatabase.create_database]
  end

  def test_collection_methods
    methods = [
      :all,
      :get
    ]
    methods.each do |method|
      assert_respond_to @databases, method
    end
  end

  def test_collection_attributes
    assert_respond_to @databases, :resource_group
    assert_respond_to @databases, :server_name
  end

  def test_all_method_response
    @service.stub :list_databases, @list_database_response do
      assert_instance_of Fog::Sql::AzureRM::SqlDatabases, @databases.all
      assert @databases.all.size >= 1
      @databases.all.each do |s|
        assert_instance_of Fog::Sql::AzureRM::SqlDatabase, s
      end
    end
  end

  def test_get_method_response
    response = ApiStub::Models::Sql::SqlDatabase.create_database
    @service.stub :get_database, response do
      assert_instance_of Fog::Sql::AzureRM::SqlDatabase, @databases.get('fog-test-rg', 'fog-test-server-name', 'fog-test-database-name')
    end
  end
end
