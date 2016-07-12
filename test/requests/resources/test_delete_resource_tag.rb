require File.expand_path '../../test_helper', __dir__

# Test class for Delete Resource Tag Request
class TestDeleteResourceTag < Minitest::Test
  def setup
    @service = Fog::Resources::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@rmc)
    @resources = client.resources
  end

  def test_delete_resource_tag_success
    response = ApiStub::Requests::Resources::AzureResource.azure_resource_response
    promise_get = Concurrent::Promise.execute do
    end
    promise_update = Concurrent::Promise.execute do
    end
    promise_get.stub :value!, response do
      @resources.stub :get, promise_get do
        promise_update.stub :value!, response do
          @resources.stub :create_or_update, promise_update do
            resource_id = '/subscriptions/########-####-####-####-############/resourceGroups/{RESOURCE-GROUP}/providers/Microsoft.Network/{PROVIDER-NAME}/{RESOURCE-NAME}'
            assert @service.delete_resource_tag(resource_id, 'tag_name', 'tag_value')
          end
        end
      end
    end
  end

  def test_delete_resource_tag_failure
    response = -> { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    promise_get = Concurrent::Promise.execute do
    end
    promise_update = Concurrent::Promise.execute do
    end
    promise_get.stub :value!, response do
      @resources.stub :get, promise_get do
        promise_update.stub :value!, response do
          @resources.stub :create_or_update, promise_update do
            resource_id = '/subscriptions/########-####-####-####-############/resourceGroups/{RESOURCE-GROUP}/providers/Microsoft.Network/{PROVIDER-NAME}/{RESOURCE-NAME}'
            assert_raises(RuntimeError) { @service.delete_resource_tag(resource_id, 'tag_name', 'tag_value') }
          end
        end
      end
    end
  end

  def test_invalid_resource_id_exeception
    resource_id = 'Invalid-Resource-ID'
    assert_raises(RuntimeError) { @service.delete_resource_tag(resource_id, 'tag_name', 'tag_value') }
  end
end
