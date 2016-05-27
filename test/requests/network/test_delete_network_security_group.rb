require File.expand_path '../../test_helper', __dir__

# Test class for Delete Network Security Group
class TestDeleteNetworkSecurityGroup < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @network_security_groups = client.network_security_groups
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_delete_network_security_group_success
    response = ApiStub::Requests::Network::NetworkSecurityGroup.delete_network_security_group_response
    @promise.stub :value!, response do
      @network_security_groups.stub :delete, @promise do
        assert_equal @service.delete_network_security_group('fog-test-rg', 'fog-test-nsg'), true
      end
    end
  end

  def test_delete_network_security_group_failure
    response = -> { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @network_security_groups.stub :delete, @promise do
        assert_raises RuntimeError do
          @service.delete_network_security_group('fog-test-rg', 'fog-test-nsg')
        end
      end
    end
  end
end
