require File.expand_path '../../test_helper', __dir__

# Test class for Get Records From Record Set Request
class TestGetRecordsFromRecordSet < Minitest::Test
  def setup
    @service = Fog::DNS::AzureRM.new(credentials)
    @record_sets = @service.record_sets
    @token_provider = Fog::Credentials::AzureRM.instance_variable_get(:@token_provider)
  end

  def test_get_records_from_record_set_of_a_type_success
    response = ApiStub::Requests::DNS::RecordSet.get_records_from_record_set_for_A_type_response
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      RestClient.stub :get, response do
        assert_equal @service.get_records_from_record_set('fog-test-rg', 'fog-test-record-set', 'fog-test-zone', 'A'), ['4.3.2.1', '5.3.2.1']
      end
    end
  end

  def test_get_records_from_record_set_of_cname_type_success
    response = ApiStub::Requests::DNS::RecordSet.get_records_from_record_set_for_CNAME_type_response
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      RestClient.stub :get, response do
        assert_equal @service.get_records_from_record_set('fog-test-rg', 'fog-test-record-set', 'fog-test-zone', 'CNAME'), ['test.fog.com']
      end
    end
  end

  def test_get_records_from_record_set_failure
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      assert_raises ArgumentError do
        @service.get_records_from_record_set('fog-test-record-set')
      end
    end
  end

  def test_get_records_from_record_set_exception
    response = -> { fail Exception.new('mocked exception') }
    @token_provider.stub :get_authentication_header, response do
      assert_raises Exception do
        @service.get_records_from_record_set('fog-test-rg', 'fog-test-record-set', 'fog-test-zone', 'A')
      end
    end
  end

  def test_get_records_from_record_set_parsing_exception
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      RestClient.stub :get, '{invalid json}' do
        assert_raises Exception do
          @service.get_records_from_record_set('fog-test-rg', 'fog-test-record-set', 'fog-test-zone', 'A')
        end
      end
    end
  end
end
