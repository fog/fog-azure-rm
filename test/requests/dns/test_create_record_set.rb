require File.expand_path '../../test_helper', __dir__

# Test class for Create Record Set Request
class TestCreateRecordSet < Minitest::Test
  def setup
    @service = Fog::DNS::AzureRM.new(credentials)
    @record_sets = @service.record_sets
    @token_provider = Fog::Credentials::AzureRM.instance_variable_get(:@token_provider)
  end

  def test_create_record_set_a_type
    response = ApiStub::Requests::DNS::RecordSet.rest_client_put_method_for_record_set_A_Type_response
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      RestClient.stub :put, response do
        assert_equal @service.create_record_set('fog-test-rg', 'fog-test-record-set', 'fog-test-zone', ['1.2.3.4', '1.2.3.3'], 'A', 60), JSON.parse(response)
      end
    end
  end

  def test_create_record_set_cname_type
    response = ApiStub::Requests::DNS::RecordSet.rest_client_put_method_for_record_set_cname_Type_response
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      RestClient.stub :put, response do
        assert_equal @service.create_record_set('fog-test-rg', 'fog-test-record-set', 'fog-test-zone', ['test.fog.com'], 'CNAME', 60), JSON.parse(response)
      end
    end
  end

  def test_create_record_set_failure
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      assert_raises ArgumentError do
        @service.create_record_set('fog-test-rg', 'fog-test-record-set', 'fog-test-zone', ['test.fog.com'], 'CNAME')
      end
    end
  end

  def test_create_record_set_exception
    response = -> { fail Exception.new('mocked exception') }
    @token_provider.stub :get_authentication_header, response do
      assert_raises Exception do
        @service.create_record_set('fog-test-rg', 'fog-test-record-set', 'fog-test-zone', ['test.fog.com'], 'CNAME', 60)
      end
    end
  end
end
