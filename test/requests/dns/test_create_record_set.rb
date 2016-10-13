require File.expand_path '../../test_helper', __dir__

# Test class for Create Record Set Request
class TestCreateRecordSet < Minitest::Test
  def setup
    @service = Fog::DNS::AzureRM.new(credentials)
    @dns_client1 = @service.instance_variable_get(:@dns_client)
    @record_sets = @dns_client1.record_sets
  end

  def test_create_or_update_record_set_a_type
    mocked_response = ApiStub::Requests::DNS::RecordSet.record_set_response_for_a_type_response(@dns_client1)
    record_set_params = { records: %w(1.2.3.4 1.2.3.3) }
    @record_sets.stub :create_or_update, mocked_response do
      assert_equal @service.create_or_update_record_set(record_set_params, 'A'), mocked_response
    end
  end

  def test_create_or_update_record_set_cname_type
    mocked_response = ApiStub::Requests::DNS::RecordSet.record_set_response_for_cname_type(@dns_client1)
    record_set_params = { records: %w(1.2.3.4 1.2.3.3) }
    @record_sets.stub :create_or_update, mocked_response do
      assert_equal @service.create_or_update_record_set(record_set_params, 'CNAME'), mocked_response
    end
  end

  def test_create_or_update_record_set_failure
    response = ApiStub::Requests::DNS::RecordSet.list_record_sets_response(@dns_client1)
    record_set_params = { records: %w(1.2.3.4 1.2.3.3) }
    @record_sets.stub :create_or_update, response do
      assert_raises ArgumentError do
        @service.create_or_update_record_set(record_set_params)
      end
    end
  end

  def test_create_or_update_record_set_exception
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    record_set_params = { records: %w(1.2.3.4 1.2.3.3) }
    @record_sets.stub :create_or_update, response do
      assert_raises RuntimeError do
        @service.create_or_update_record_set(record_set_params, 'CNAME')
      end
    end
  end
end
