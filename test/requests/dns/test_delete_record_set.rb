require File.expand_path '../../test_helper', __dir__

# Test class for Delete Record Set Request
class TestDeleteRecordSet < Minitest::Test
  def setup
    @service = Fog::DNS::AzureRM.new(credentials)
    @dns_client = @service.instance_variable_get(:@dns_client)
    @record_sets = @dns_client.record_sets
  end

  def test_delete_record_set_success
    response = true
    @record_sets.stub :delete, response do
      assert @service.delete_record_set('fog-test-rg', 'fog-test-record-set', 'fog-test-zone', ''), response
    end
  end

  def test_delete_record_set_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @record_sets.stub :delete, response do
      assert_raises(MsRestAzure::AzureOperationError) { @service.delete_record_set('fog-test-rg', 'fog-test-record-set', 'fog-test-zone', '') }
    end
  end
end
