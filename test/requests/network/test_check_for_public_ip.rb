require File.expand_path '../../../test_helper', __FILE__

# Test class for Check for Public Ip Request
class TestCheckForPublicIp < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    network_client = @service.instance_variable_get(:@network_client)
    @public_ips = network_client.public_ipaddresses
  end

  def test_check_for_public_ip_success
    @public_ips.stub :get, true do
      assert @service.check_for_public_ip('fog-test-rg', 'fog-test-public-ip')
    end
  end

  def test_check_for_public_ip_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceNotFound' }) }
    @public_ips.stub :get, response do
      assert !@service.check_for_public_ip('fog-test-rg', 'fog-test-public-ip')
    end
  end

  def test_check_for_public_ip_exception
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceGroupNotFound' }) }
    @public_ips.stub :get, response do
      assert_raises(RuntimeError) { @service.check_for_public_ip('fog-test-rg', 'fog-test-public-ip') }
    end
  end
end
