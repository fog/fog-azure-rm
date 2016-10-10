require File.expand_path '../../test_helper', __dir__

# Test class for Create Sql Server
class TestCreateOrUpdateSqlServer < Minitest::Test
  def setup
    @service = Fog::Sql::AzureRM.new(credentials)
    @databases = @service.sql_servers
    @token_provider = Fog::Credentials::AzureRM.instance_variable_get(:@token_provider)
  end

  def test_create_or_update_sql_server_success
    server_response = ApiStub::Requests::Sql::SqlServer.create_sql_server_response
    data_hash = ApiStub::Requests::Sql::SqlServer.sql_server_hash
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      RestClient.stub :put, server_response do
        assert_equal @service.create_or_update_sql_server(data_hash), JSON.parse(server_response)
      end
    end
  end

  def test_create_or_update_sql_server_failure
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      assert_raises ArgumentError do
        @service.create_or_update_sql_server('test-resource-group', 'test-server-name')
      end
    end
  end
end
