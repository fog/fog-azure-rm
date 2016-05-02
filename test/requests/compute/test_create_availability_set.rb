require File.expand_path '../../test_helper', __dir__

# Test class for Create Availability Set Request
class TestCreateAvailabilitySet < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@compute_mgmt_client)
    @availability_sets = client.availability_sets
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_create_availability_set_success
    response = ApiStub::Requests::Compute::AvailabilitySet.create_availability_set_response
    @promise.stub :value!, response do
      @availability_sets.stub :create_or_update, @promise do
        assert_equal @service.create_availability_set('fog-test-rg', 'fog-test-as', 'west us'), response
      end
    end
  end

  def test_create_availability_set_failure
    response = -> { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @availability_sets.stub :create_or_update, @promise do
        assert_raises(RuntimeError) { @service.create_availability_set('fog-test-rg', 'fog-test-as', 'west us') }
      end
    end
  end
end
