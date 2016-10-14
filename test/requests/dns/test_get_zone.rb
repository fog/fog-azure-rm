require File.expand_path '../../test_helper', __dir__

# Test class for Get Zone
class TestGetZone < Minitest::Test
  def setup
    @service = Fog::DNS::AzureRM.new(credentials)
    @dns_client = @service.instance_variable_get(:@dns_client)
    @zones = @dns_client.zones
  end

  def test_get_zone_success
    mocked_response = ApiStub::Requests::DNS::Zone.zone_response(@dns_client)
    @zones.stub :get, mocked_response do
      assert_equal @service.get_zone('fog-test-rg', 'zone_name'), mocked_response
    end
  end

  def test_get_zone_failure
    response = ApiStub::Requests::DNS::RecordSet.list_record_sets_response(@dns_client)
    @zones.stub :get, response do
      assert_raises ArgumentError do
        @service.get_zone('fog-test-rg')
      end
    end
  end

  def test_get_zone_exception
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @zones.stub :get, response do
      assert_raises RuntimeError do
        @service.get_zone('fog-test-rg', 'zone_name')
      end
    end
  end
end
