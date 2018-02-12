require File.expand_path '../../test_helper', __dir__

# Test class for Get Record Set
class TestGetRecordSet < Minitest::Test
  def setup
    @service = Fog::DNS::AzureRM.new(credentials)
    @dns_client = @service.instance_variable_get(:@dns_client)
    @record_sets = @dns_client.record_sets
  end

  def test_get_record_set_success
    mocked_response = ApiStub::Requests::DNS::RecordSet.record_set_response_for_cname_type(@dns_client)
    @record_sets.stub :get, mocked_response do
      assert_equal @service.get_record_set('fog-test-rg', 'fog-test-result', 'fog-test-zone', 'CNAME'), mocked_response
    end
  end

  def test_get_record_set_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @record_sets.stub :get, response do
      assert_raises(MsRestAzure::AzureOperationError) { @service.get_record_set('fog-test-rg', 'fog-test-result', 'fog-test-zone', 'CNAME') }
    end
  end
end
