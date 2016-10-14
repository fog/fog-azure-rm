require File.expand_path '../../test_helper', __dir__

# Test class for List Record Sets Request
class TestListRecordSets < Minitest::Test
  def setup
    @service = Fog::DNS::AzureRM.new(credentials)
    @dns_client1 = @service.instance_variable_get(:@dns_client)
    @record_sets = @dns_client1.record_sets
  end

  def test_list_record_sets_success
    mocked_response = [ApiStub::Requests::DNS::RecordSet.list_record_sets_response(@dns_client1)]
    @record_sets.stub :list_all_in_resource_group, mocked_response do
      assert_equal @service.list_record_sets('fog-test-rg', 'fog-test-zone'), mocked_response
    end
  end

  def test_list_record_sets_failure
    response = ApiStub::Requests::DNS::RecordSet.list_record_sets_response(@dns_client1)
    @record_sets.stub :list_all_in_resource_group, response do
      assert_raises ArgumentError do
        @service.list_record_sets('fog-test-rg')
      end
    end
  end

  def test_list_record_sets_exception
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @record_sets.stub :list_all_in_resource_group, response do
      assert_raises RuntimeError do
        @service.list_record_sets('fog-test-rg', 'fog-test-zone')
      end
    end
  end
end
