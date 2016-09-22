require File.expand_path '../../test_helper', __dir__

# Test class for Get Available IP Address Count
class TestGetAvailableIPAddressesCount < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
  end

  def test_get_available_ipaddresses_count_success
    assert_equal @service.get_available_ipaddresses_count('fog-test-subnet', '10.0.0.0/24', [], false), 254
  end

  def test_get_available_ipaddresses_count_argument_error
    assert_raises ArgumentError do
      @service.get_available_ipaddresses_count('fog-test-subnet', '10.0.0.0/24')
    end
  end
end
