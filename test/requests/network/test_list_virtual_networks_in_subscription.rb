require File.expand_path '../../test_helper', __dir__

# Test class for List Virtual Networks in a subscription Request
class TestListVirtualNetworksInSubscription < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @virtual_networks = @network_client.virtual_networks
  end

  def test_list_virtual_networks_in_subscription_success
    mocked_response = ApiStub::Requests::Network::VirtualNetwork.list_virtual_networks_response(@network_client)
    @virtual_networks.stub :list_all, mocked_response do
      assert_equal @service.list_virtual_networks_in_subscription, mocked_response
    end
  end

  def test_list_virtual_networks_in_subscription_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @virtual_networks.stub :list_all, response do
      assert_raises(RuntimeError) { @service.list_virtual_networks_in_subscription }
    end
  end
end
