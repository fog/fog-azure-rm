require File.expand_path '../../test_helper', __dir__

# Test class for List Record Sets Request
class TestListRecordSets < Minitest::Test
  def setup
    @service = Fog::DNS::AzureRM.new(credentials)
    @record_sets = @service.record_sets
    @token_provider = Fog::Credentials::AzureRM.instance_variable_get(:@token_provider)
  end

  def test_list_record_sets_success
    response = ApiStub::Requests::DNS::RecordSet.list_record_sets_response
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      RestClient.stub :get, response do
        assert_equal @service.list_record_sets('fog-test-rg', 'fog-test-zone'), response['value']
      end
    end
  end

  def test_list_record_sets_failure
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      assert_raises ArgumentError do
        @service.list_record_sets('fog-test-rg')
      end
    end
  end

  def test_list_record_sets_exception
    response = -> { fail Exception.new('mocked exception') }
    @token_provider.stub :get_authentication_header, response do
      assert_raises Exception do
        @service.list_record_sets('fog-test-rg', 'fog-test-zone')
      end
    end
  end
end
