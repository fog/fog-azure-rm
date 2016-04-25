require File.expand_path '../../test_helper', __dir__

# Test class for Availability Set Model
class TestAvailabilitySet < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    @availability_set = availability_set(@service)
  end

  def test_model_methods
    response = ApiStub::Models::Compute::AvailabilitySet.create_availability_set_response
    methods = [
      :save,
      :destroy
    ]
    @service.stub :create_availability_set, response do
      methods.each do |method|
        assert @availability_set.respond_to? method, true
      end
    end
  end

  def test_model_attributes
    response = ApiStub::Models::Compute::AvailabilitySet.create_availability_set_response
    attributes = [
      :id,
      :name,
      :type,
      :location,
      :tags,
      :resource_group,
      :properties
    ]
    @service.stub :create_availability_set, response do
      attributes.each do |attribute|
        assert @availability_set.respond_to? attribute, true
      end
    end
  end

  def test_save_method_response
    response = ApiStub::Models::Compute::AvailabilitySet.create_availability_set_response
    @service.stub :create_availability_set, response do
      # assert_instance_of MsRestAzure::AzureOperationResponse, @availability_set.save
    end
  end
end
