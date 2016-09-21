require File.expand_path '../../test_helper', __dir__

# Test class for Get Available IP Address Count
class TestGetAvailableIPAddressCount < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
  end

  def test_get_available_ipaddress_count_success
    assert_equal @service.get_available_ipaddress_count('fog-test-subnet', '10.0.0.0/24', []), 254
  end

  def test_get_available_ipaddress_count_argument_error
    assert_raises ArgumentError do
      @service.get_available_ipaddress_count('fog-test-subnet', '10.0.0.0/24')
    end
  end
end