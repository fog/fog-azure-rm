require File.expand_path '../../test_helper', __dir__

# Test class for Check Zone Exists
class TestCheckZoneExists < Minitest::Test
  def setup
    @service = Fog::DNS::AzureRM.new(credentials)
    @dns_client = @service.instance_variable_get(:@dns_client)
    @zones = @dns_client.zones
  end

  def test_check_zone_exists_success
    mocked_response = ApiStub::Requests::DNS::Zone.zone_response(@dns_client)
    @zones.stub :get, mocked_response do
      assert_equal @service.check_zone_exists('fog-test-rg', 'zone_name'), true
    end
  end

  def test_check_zone_exists_failure
    response = ApiStub::Requests::DNS::RecordSet.list_record_sets_response(@dns_client)
    @zones.stub :get, response do
      assert_raises ArgumentError do
        @service.check_zone_exists('fog-test-rg')
      end
    end
  end

  def test_check_zone_exists_exception
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, mock_response, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceNotFound' }) }
    @zones.stub :get, response do
      assert !@service.check_zone_exists('fog-test-rg', 'zone_name')
    end
  end
end
