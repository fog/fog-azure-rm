require File.expand_path '../../test_helper', __dir__

# Test class for Create Azure Resources Request
class TestTagResource < Minitest::Test
  def setup
    @service = Fog::Resources::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@rmc)
    @resources = client.resources
  end

  def test_tag_resource_success
    mocked_response = ApiStub::Requests::Resources::AzureResource.azure_resource_response
    promise_get = Concurrent::Promise.execute do
    end
    promise_create = Concurrent::Promise.execute do
    end
    promise_get.stub :value!, mocked_response do
      @resources.stub :get, promise_get do
        promise_create.stub :value!, mocked_response do
          @resources.stub :create_or_update, promise_create do
            resource_id = '/subscriptions/########-####-####-####-############/resourceGroups/{RESOURCE-GROUP}/providers/Microsoft.Network/{PROVIDER-NAME}/{RESOURCE-NAME}'
            assert_equal @service.tag_resource(resource_id, 'tag_name', 'tag_value'), true
          end
        end
      end
    end
  end

  def test_tag_resource_failure
    response = -> { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    promise_get = Concurrent::Promise.execute do
    end
    promise_create = Concurrent::Promise.execute do
    end
    promise_get.stub :value!, response do
      @resources.stub :get, promise_get do
        promise_create.stub :value!, response do
          @resources.stub :create_or_update, promise_create do
            resource_id = '/subscriptions/########-####-####-####-############/resourceGroups/{RESOURCE-GROUP}/providers/Microsoft.Network/{PROVIDER-NAME}/{RESOURCE-NAME}'
            assert_raises(RuntimeError) { @service.tag_resource(resource_id, 'tag_name', 'tag_value') }
          end
        end
      end
    end
  end

  def test_invalid_resource_id_exeception
    resource_id = 'Invalid-Resource-ID'
    assert_raises(RuntimeError) { @service.tag_resource(resource_id, 'tag_name', 'tag_value') }
  end
end
