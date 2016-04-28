require File.expand_path '../../test_helper', __dir__

# Test class for Create Availability Set Request
class TestListAvailabilitySet < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@compute_mgmt_client)
    @availability_sets = client.availability_sets
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_list_availability_set_success
    response = ApiStub::Requests::Compute::AvailabilitySet.list_availability_set_response
    @promise.stub :value!, response do
      @availability_sets.stub :list, @promise do
        assert @service.list_availability_sets('fog-test-rg'), response
      end
    end
  end

  def test_list_availability_set_failure
    response = -> { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @availability_sets.stub :list, @promise do
        assert_raises(RuntimeError) { @service.list_availability_sets('fog-test-rg') }
      end
    end
  end
end
