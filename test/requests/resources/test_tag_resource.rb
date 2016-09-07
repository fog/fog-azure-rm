require File.expand_path '../../../test_helper', __FILE__

# Test class for Create Azure Resources Request
class TestTagResource < Minitest::Test
  def setup
    @service = Fog::Resources::AzureRM.new(credentials)
    @client = @service.instance_variable_get(:@rmc)
    @resources = @client.resources
    @resource_response = ApiStub::Requests::Resources::AzureResource.azure_resource_response(@client)
  end

  def test_tag_resource_success
    @resources.stub :get, @resource_response do
      @resources.stub :create_or_update, @resource_response do
        resource_id = '/subscriptions/########-####-####-####-############/resourceGroups/{RESOURCE-GROUP}/providers/Microsoft.Network/{PROVIDER-NAME}/{RESOURCE-NAME}'
        assert_equal @service.tag_resource(resource_id, 'tag_name', 'tag_value'), true
      end
    end
  end

  def test_tag_resource_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @resources.stub :get, @resource_response do
      @resources.stub :create_or_update, response do
        resource_id = '/subscriptions/########-####-####-####-############/resourceGroups/{RESOURCE-GROUP}/providers/Microsoft.Network/{PROVIDER-NAME}/{RESOURCE-NAME}'
        assert_raises(RuntimeError) { @service.tag_resource(resource_id, 'tag_name', 'tag_value') }
      end
    end
  end

  def test_invalid_resource_id_exeception
    resource_id = 'Invalid-Resource-ID'
    assert_raises(RuntimeError) { @service.tag_resource(resource_id, 'tag_name', 'tag_value') }
  end
end
