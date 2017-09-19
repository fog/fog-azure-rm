require File.expand_path '../../test_helper', __dir__

# Test class for Create Availability Set Request
class TestCreateAvailabilitySet < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    @client = @service.instance_variable_get(:@compute_mgmt_client)
    @availability_sets = @client.availability_sets
  end

  def test_create_unmanaged_availability_set_success
    mocked_response = ApiStub::Requests::Compute::AvailabilitySet.create_unmanaged_availability_set_response(@client)
    @availability_sets.stub :validate_params, true do
      @availability_sets.stub :create_or_update, mocked_response do
        assert_equal @service.create_availability_set('fog-test-rg', 'myavset1', 'west us', false), mocked_response
      end
    end
  end

  def test_create_unmanaged_availability_set_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @availability_sets.stub :validate_params, true do
      @availability_sets.stub :create_or_update, response do
        assert_raises(RuntimeError) { @service.create_availability_set('fog-test-rg', 'fog-test-as', 'west us', false) }
      end
    end
  end

  def test_create_managed_availability_set_success
    mocked_response = ApiStub::Requests::Compute::AvailabilitySet.create_managed_availability_set_response(@client)
    @availability_sets.stub :validate_params, true do
      @availability_sets.stub :create_or_update, mocked_response do
        assert_equal @service.create_availability_set('fog-test-rg', 'myavset1', 'west us', true), mocked_response
      end
    end
  end

  def test_create_managed_availability_set_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @availability_sets.stub :validate_params, true do
      @availability_sets.stub :create_or_update, response do
        assert_raises(RuntimeError) { @service.create_availability_set('fog-test-rg', 'fog-test-as', 'west us', true) }
      end
    end
  end
end
