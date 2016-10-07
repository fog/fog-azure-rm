require File.expand_path '../../test_helper', __dir__

# Test class for List Sql Server Request
class TestListSqlServers < Minitest::Test
  def setup
    @service = Fog::Sql::AzureRM.new(credentials)
    @token_provider = Fog::Credentials::AzureRM.instance_variable_get(:@token_provider)
  end

  def test_list_sql_servers_success
    list_response = ApiStub::Requests::Sql::SqlServer.list_sql_server_response
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      RestClient.stub :get, list_response do
        assert_equal @service.list_sql_servers('fog-test-rg'), JSON.parse(list_response)['value']
      end
    end
  end

  def test_list_sql_servers_failure
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      assert_raises ArgumentError do
        @service.list_sql_servers('fog-test-rg', 'server-name')
      end
    end
  end

  def test_list_sql_servers_exception
    response = -> { fail Exception.new('mocked exception') }
    @token_provider.stub :get_authentication_header, response do
      assert_raises Exception do
        @service.list_sql_servers('fog-test-rg')
      end
    end
  end
end
