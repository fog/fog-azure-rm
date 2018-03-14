require File.expand_path '../../test_helper', __dir__

# Test class for Stop Application Gateway Request
class TestStopApplicationGateway < Minitest::Test
  def setup
    @service = Fog::ApplicationGateway::AzureRM.new(credentials)
    gateway_client = @service.instance_variable_get(:@network_client)
    @gateways = gateway_client.application_gateways
  end

  def test_stop_application_gateway_success
    @gateways.stub :stop, nil do
      assert_equal @service.stop_application_gateway('test-rg', 'test-ag'), true
    end
  end

  def test_stop_application_gateway_exception_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @gateways.stub :stop, response do
      assert_raises MsRestAzure::AzureOperationError do
        @service.stop_application_gateway('test-rg', 'test-ag')
      end
    end
  end
end
