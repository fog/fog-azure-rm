require File.expand_path '../../test_helper', __dir__

# Test class for Check Public Ip Exists Request
class TestCheckPublicIpExists < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    network_client = @service.instance_variable_get(:@network_client)
    @public_ips = network_client.public_ipaddresses
  end

  def test_check_public_ip_exists_success
    @public_ips.stub :get, true do
      assert @service.check_public_ip_exists('fog-test-rg', 'fog-test-public-ip')
    end
  end

  def test_check_public_ip_exists_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, get_mock_response, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceNotFound' }) }
    @public_ips.stub :get, response do
      assert !@service.check_public_ip_exists('fog-test-rg', 'fog-test-public-ip')
    end
  end

  def test_check_public_ip_exists_exception
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, get_mock_response, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceGroupNotFound' }) }
    @public_ips.stub :get, response do
      assert !@service.check_public_ip_exists('fog-test-rg', 'fog-test-public-ip')
    end
  end
end
