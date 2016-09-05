require File.expand_path '../../../test_helper', __FILE__

# Test class for List Network Interfaces Request
class TestListNetworkInterfaces < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @network_interfaces = @network_client.network_interfaces
  end

  def test_list_network_interfaces_success
    mocked_response = ApiStub::Requests::Network::NetworkInterface.list_network_interfaces_response(@network_client)
    @network_interfaces.stub :list_as_lazy, mocked_response do
      assert_equal @service.list_network_interfaces('fog-test-rg'), mocked_response.value
    end
  end

  def test_list_network_interfaces_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @network_interfaces.stub :list_as_lazy, response do
      assert_raises(RuntimeError) { @service.list_network_interfaces('fog-test-rg') }
    end
  end
end
