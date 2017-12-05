require File.expand_path '../../test_helper', __dir__

# Test class for Check Record Set Exists
class TestCheckRecordSetExists < Minitest::Test
  def setup
    @service = Fog::DNS::AzureRM.new(credentials)
    @dns_client = @service.instance_variable_get(:@dns_client)
    @record_sets = @dns_client.record_sets
  end

  def test_check_record_set_exists_success
    mocked_response = ApiStub::Requests::DNS::RecordSet.record_set_response_for_cname_type(@dns_client)
    @record_sets.stub :get, mocked_response do
      assert @service.check_record_set_exists('fog-test-rg', 'fog-test-result', 'fog-test-zone', 'CNAME')
    end
  end

  def test_check_record_set_exists_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, create_mock_response, 'code' => 'NotFound') }
    @record_sets.stub :get, response do
      assert !@service.check_record_set_exists('fog-test-rg', 'fog-test-result', 'fog-test-zone', 'CNAME')
    end
  end

  def test_check_record_set_exists_exception
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, create_mock_response, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceGroupNotFound' }) }
    @record_sets.stub :get, response do
      assert !@service.check_record_set_exists('fog-test-rg', 'fog-test-result', 'fog-test-zone', 'CNAME')
    end
  end
end
