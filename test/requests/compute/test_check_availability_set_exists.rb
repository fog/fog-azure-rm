require File.expand_path '../../test_helper', __dir__

# Test class for Check Availability Set Exists Request
class TestCheckAvailabilitySetExists < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    @client = @service.instance_variable_get(:@compute_mgmt_client)
    @availability_sets = @client.availability_sets
  end

  def test_check_availability_set_exists_success
    mocked_response = ApiStub::Requests::Compute::AvailabilitySet.get_availability_set_response(@client)
    @availability_sets.stub :get, mocked_response do
      assert @service.check_availability_set_exists('myrg1', 'myavset1')
    end
  end

  def test_check_availability_set_exists_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, create_mock_response, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceNotFound' }) }
    @availability_sets.stub :get, response do
      assert !@service.check_availability_set_exists('myrg1', 'myavset1')
    end
  end

  def test_check_availability_set_exists_exception
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, create_mock_response, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceGroupNotFound' }) }
    @availability_sets.stub :get, response do
      assert !@service.check_availability_set_exists('myrg1', 'myavset1')
    end
  end
end
