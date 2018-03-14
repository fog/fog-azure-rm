require File.expand_path '../../test_helper', __dir__

# Test class for Get Records From Record Set Request
class TestGetRecordsFromRecordSet < Minitest::Test
  def setup
    @service = Fog::DNS::AzureRM.new(credentials)
    @dns_client = @service.instance_variable_get(:@dns_client)
    @record_sets = @dns_client.record_sets
  end

  def test_get_records_from_record_set_of_a_type_success
    mocked_response = ApiStub::Requests::DNS::RecordSet.record_set_response_for_a_type_response(@dns_client)
    @record_sets.stub :get, mocked_response do
      assert_equal @service.get_records_from_record_set('fog-test-rg', 'fog-test-record-set', 'fog-test-zone', 'A'), mocked_response.arecords
    end
  end

  def test_get_records_from_record_set_of_cname_type_success
    mocked_response = ApiStub::Requests::DNS::RecordSet.record_set_response_for_cname_type(@dns_client)
    @record_sets.stub :get, mocked_response do
      assert_equal @service.get_records_from_record_set('fog-test-rg', 'fog-test-record-set', 'fog-test-zone', 'CNAME'), mocked_response.cname_record
    end
  end

  def test_get_records_from_record_set_failure
    response = ApiStub::Requests::DNS::RecordSet.list_record_sets_response(@dns_client)
    @record_sets.stub :get, response do
      assert_raises ArgumentError do
        @service.get_records_from_record_set('fog-test-rg', 'fog-test-record-set', 'fog-test-zone')
      end
    end
  end

  def test_get_records_from_record_set_exception
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @record_sets.stub :get, response do
      assert_raises MsRestAzure::AzureOperationError do
        @service.get_records_from_record_set('fog-test-rg', 'fog-test-record-set', 'fog-test-zone', 'CNAME')
      end
    end
  end
end
