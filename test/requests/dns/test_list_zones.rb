require File.expand_path '../../test_helper', __dir__

# Test class for List Zones Request
class TestListZones < Minitest::Test
  def setup
    @service = Fog::DNS::AzureRM.new(credentials)
    @dns_client = @service.instance_variable_get(:@dns_client)
    @zones = @dns_client.zones
  end

  def test_list_zones_success
    mocked_response = ApiStub::Requests::DNS::Zone.zone_response(@dns_client)
    @zones.stub :list, mocked_response do
      assert_equal @service.list_zones, mocked_response
    end
  end

  def test_list_zones_exception
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @zones.stub :list, response do
      assert_raises MsRestAzure::AzureOperationError do
        @service.list_zones
      end
    end
  end
end
