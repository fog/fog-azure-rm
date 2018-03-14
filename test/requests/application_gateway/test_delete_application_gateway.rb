require File.expand_path '../../test_helper', __dir__

# Test class for Delete Application Gateway Request
class TestDeleteApplicationGateway < Minitest::Test
  def setup
    @service = Fog::ApplicationGateway::AzureRM.new(credentials)
    gateway_client = @service.instance_variable_get(:@network_client)
    @gateways = gateway_client.application_gateways
  end

  def test_delete_application_gateway_success
    @gateways.stub :delete, true do
      assert @service.delete_application_gateway('fogRM-rg', 'gateway'), true
    end
  end

  def test_delete_application_gateway_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @gateways.stub :delete, response do
      assert_raises(MsRestAzure::AzureOperationError) { @service.delete_application_gateway('fogRM-rg', 'gateway') }
    end
  end
end
