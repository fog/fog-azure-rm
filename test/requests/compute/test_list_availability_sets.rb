require File.expand_path '../../test_helper', __dir__

# Test class for List Availability Sets Request
class TestListAvailabilitySet < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    @client = @service.instance_variable_get(:@compute_mgmt_client)
    @availability_sets = @client.availability_sets
  end

  def test_list_availability_set_success
    mocked_response = ApiStub::Requests::Compute::AvailabilitySet.list_availability_set_response(@client)
    @availability_sets.stub :list, mocked_response do
      assert_equal @service.list_availability_sets('fog-test-rg'), mocked_response.value
    end
  end

  def test_list_availability_set_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @availability_sets.stub :list, response do
      assert_raises(Fog::AzureRm::OperationError) { @service.list_availability_sets('fog-test-rg') }
    end
  end
end
