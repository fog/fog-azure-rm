require File.expand_path '../../test_helper', __dir__

# Test class for List Network Security Group
class TestListNetworkSecurityGroup < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @network_security_groups = client.network_security_groups
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_list_network_security_group_success
    mocked_response = ApiStub::Requests::Network::NetworkSecurityGroup.list_network_security_group_response
    expected_response = Azure::ARM::Network::Models::NetworkSecurityGroupListResult.serialize_object(mocked_response.body)['value']
    @promise.stub :value!, mocked_response do
      @network_security_groups.stub :list, @promise do
        assert_equal @service.list_network_security_groups('fog-test-rg'), expected_response
      end
    end
  end

  def test_list_network_security_group_failure
    response = -> { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @network_security_groups.stub :list, @promise do
        assert_raises RuntimeError do
          @service.list_network_security_groups('fog-test-rg')
        end
      end
    end
  end
end
