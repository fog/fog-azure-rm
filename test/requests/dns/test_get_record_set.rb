require File.expand_path '../../../test_helper', __FILE__

# Test class for Get Record Set
class TestGetRecordSet < Minitest::Test
  def setup
    @service = Fog::DNS::AzureRM.new(credentials)
    @record_sets = @service.record_sets
    @token_provider = Fog::Credentials::AzureRM.instance_variable_get(:@token_provider)
  end

  def test_get_record_set_success
    response = ApiStub::Requests::DNS::RecordSet.rest_client_put_method_for_record_set_a_type_response
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      RestClient.stub :get, response do
        assert_equal @service.get_record_set('fog-test-rg', 'fog-test-record-set', 'fog-test-zone', 'A'), JSON.parse(response)
      end
    end
  end

  def test_get_record_set_failure
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      assert_raises ArgumentError do
        @service.get_record_set('fog-test-rg')
      end
    end
  end

  def test_get_record_set_exception
    response = -> { fail Exception.new('mocked exception') }
    @token_provider.stub :get_authentication_header, response do
      assert_raises Exception do
        @service.get_record_set('fog-test-rg', 'fog-test-record-set', 'fog-test-zone', 'A')
      end
    end
  end

  def test_get_record_set_parsing_exception
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      RestClient.stub :get, '{invalid json}' do
        assert_raises Exception do
          @service.get_record_set('fog-test-rg', 'fog-test-record-set', 'fog-test-zone', 'A')
        end
      end
    end
  end
end
