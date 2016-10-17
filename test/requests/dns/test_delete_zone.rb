require File.expand_path '../../test_helper', __dir__

# Test class for Dellete Zone Request
class TestDeleteZone < Minitest::Test
  def setup
    @service = Fog::DNS::AzureRM.new(credentials)
    @dns_client = @service.instance_variable_get(:@dns_client)
    @zones = @dns_client.zones
  end

  def test_delete_zone_success
    response = true
    @zones.stub :delete, response do
      assert @service.delete_zone('fog-test-rg', 'fog-test-zone'), response
    end
  end

  def test_delete_zone_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @zones.stub :delete, response do
      assert_raises(RuntimeError) { @service.delete_zone('fog-test-rg', 'fog-test-zone') }
    end
  end
end
