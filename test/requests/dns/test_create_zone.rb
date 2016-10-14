require File.expand_path '../../test_helper', __dir__

# Test class for Create Zone Request
class TestCreateZone < Minitest::Test
  def setup
    @service = Fog::DNS::AzureRM.new(credentials)
    @dns_client1 = @service.instance_variable_get(:@dns_client)
    @zones = @dns_client1.zones
  end

  def test_create_or_update_zone_success
    mocked_response = ApiStub::Requests::DNS::Zone.zone_response(@dns_client1)
    zone_params = {}
    @zones.stub :create_or_update, mocked_response do
      assert_equal @service.create_or_update_zone(zone_params), mocked_response
    end
  end

  def test_create_or_update_zone_failure
    response = ApiStub::Requests::DNS::RecordSet.list_record_sets_response(@dns_client1)
    @zones.stub :create_or_update, response do
      assert_raises ArgumentError do
        @service.create_or_update_zone
      end
    end
  end

  def test_create_or_update_zone_exception
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    zone_params = {}
    @zones.stub :create_or_update, response do
      assert_raises RuntimeError do
        @service.create_or_update_zone(zone_params)
      end
    end
  end
end
