require File.expand_path '../../test_helper', __dir__

# Test class for List Availability Sets Request
class TestGetAvailabilitySet < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    @client = @service.instance_variable_get(:@compute_mgmt_client)
    @availability_sets = @client.availability_sets
  end

  def test_list_availability_set_success
    mocked_response = ApiStub::Requests::Compute::AvailabilitySet.get_availability_set_response(@client)
    @availability_sets.stub :get, mocked_response do
      assert_equal @service.get_availability_set('myrg1', 'myavset1'), mocked_response
    end
  end

  def test_list_availability_set_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @availability_sets.stub :get, response do
      assert_raises(MsRestAzure::AzureOperationError) { @service.get_availability_set('myrg1', 'myavset1') }
    end
  end
end
