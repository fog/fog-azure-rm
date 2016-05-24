require File.expand_path '../../test_helper', __dir__

# Test class for Delete Availability Set Request
class TestDeleteAvailabilitySet < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@compute_mgmt_client)
    @availability_sets = client.availability_sets
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_delete_availability_set_success
    @promise.stub :value!, true do
      @availability_sets.stub :delete, @promise do
        assert @service.delete_availability_set('fog-test-rg', 'fog-test-as')
      end
    end
  end

  def test_delete_availability_set_failure
    response = -> { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @availability_sets.stub :delete, @promise do
        assert_raises(RuntimeError) { @service.delete_availability_set('fog-test-rg', 'fog-test-as') }
      end
    end
  end
end
