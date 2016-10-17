require File.expand_path '../../test_helper', __dir__

# Test class for Create Database
class TestCreateOrUpdateDatabase < Minitest::Test
  def setup
    @service = Fog::Sql::AzureRM.new(credentials)
    @databases = @service.sql_databases
    @token_provider = Fog::Credentials::AzureRM.instance_variable_get(:@token_provider)
  end

  def test_create_or_update_database_success
    database_response = ApiStub::Requests::Sql::SqlDatabase.create_database_response
    data_hash = ApiStub::Requests::Sql::SqlDatabase.database_hash
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      RestClient.stub :put, database_response do
        assert_equal @service.create_or_update_database(data_hash), JSON.parse(database_response)
      end
    end
  end

  def test_create_or_update_database_failure
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      assert_raises ArgumentError do
        @service.create_or_update_database('test-resource-group', 'test-server-name')
      end
    end
  end
end
