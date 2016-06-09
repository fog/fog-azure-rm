require File.expand_path '../../test_helper', __dir__

# Test class for Delete Application Gateway Request
class TestDeleteApplicationGateway < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @gateways = client.application_gateways
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_delete_application_gateway_success
    response = true
    @promise.stub :value!, response do
      @gateways.stub :delete, @promise do
        assert @service.delete_application_gateway('fogRM-rg', 'gateway'), response
      end
    end
  end

  def test_delete_application_gateway_failure
    response = -> { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @gateways.stub :delete, @promise do
        assert_raises(RuntimeError) { @service.delete_application_gateway('fogRM-rg', 'gateway') }
      end
    end
  end
end
