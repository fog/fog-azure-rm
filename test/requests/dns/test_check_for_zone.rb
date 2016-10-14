require File.expand_path '../../test_helper', __dir__

# Test class for Check for Zone Request
class TestCheckForZone < Minitest::Test
  def setup
    @service = Fog::DNS::AzureRM.new(credentials)
    @dns_client = @service.instance_variable_get(:@dns_client)
    @zones = @dns_client.zones
  end

  def test_check_for_zone_success
    mocked_response = ApiStub::Requests::DNS::Zone.zone_response(@dns_client)
    @zones.stub :get, mocked_response do
      assert_equal @service.check_for_zone('fog-test-rg', 'fog-test-zone'), true
    end
  end

  def test_check_for_zone_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @zones.stub :get, response do
      assert_raises(RuntimeError) { @service.check_for_zone('fog-test-rg', 'fog-test-zone') }
    end
  end
end
