require File.expand_path '../../test_helper', __dir__

# Test class for Get Database
class TestGetDatabase < Minitest::Test
  def setup
    @service = Fog::Sql::AzureRM.new(credentials)
    @token_provider = Fog::Credentials::AzureRM.instance_variable_get(:@token_provider)
  end

  def test_get_database_success
    create_response = ApiStub::Requests::Sql::SqlDatabase.create_database_response
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      RestClient.stub :get, create_response do
        assert_equal @service.get_database('fog-test-rg', 'fog-test-server-name', 'fog-test-database-name'), JSON.parse(create_response)
      end
    end
  end

  def test_get_database_failure
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      assert_raises ArgumentError do
        @service.get_database('fog-test-rg')
      end
    end
  end

  def test_get_database_exception
    response = -> { fail Exception.new('mocked exception') }
    @token_provider.stub :get_authentication_header, response do
      assert_raises Exception do
        @service.get_database('fog-test-rg', 'fog-test-server-name', 'fog-test-database-name')
      end
    end
  end

end
