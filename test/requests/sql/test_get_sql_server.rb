require File.expand_path '../../test_helper', __dir__

# Test class for Get Sql Server
class TestGetSqlServer < Minitest::Test
  def setup
    @service = Fog::Sql::AzureRM.new(credentials)
    @token_provider = Fog::Credentials::AzureRM.instance_variable_get(:@token_provider)
  end

  def test_get_sql_server_success
    create_response = ApiStub::Requests::Sql::SqlServer.create_sql_server_response
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      RestClient.stub :get, create_response do
        assert_equal @service.get_sql_server('fog-test-rg', 'fog-test-server-name'), JSON.parse(create_response)
      end
    end
  end

  def test_get_sql_server_failure
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      assert_raises ArgumentError do
        @service.get_sql_server('fog-test-rg')
      end
    end
  end

  def test_get_sql_server_exception
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @token_provider.stub :get_authentication_header, response do
      assert_raises Exception do
        @service.get_sql_server('fog-test-rg', 'fog-test-server-name')
      end
    end
  end
end
