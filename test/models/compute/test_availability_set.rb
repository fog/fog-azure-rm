require File.expand_path '../../test_helper', __dir__

# Test class for Availability Set Model
class TestAvailabilitySet < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    @availability_set = availability_set(@service)
    @response = ApiStub::Models::Compute::AvailabilitySet.create_availability_set_response
  end

  def test_model_methods
    methods = [
      :save,
      :destroy
    ]
    methods.each do |method|
      assert @availability_set.respond_to? method, true
    end
  end

  def test_model_attributes
    attributes = [
      :id,
      :name,
      :type,
      :location,
      :tags,
      :resource_group,
      :properties
    ]
    attributes.each do |attribute|
      assert @availability_set.respond_to? attribute, true
    end
  end

  def test_save_method_response
    @service.stub :create_availability_set, @response do
      assert_instance_of MsRestAzure::AzureOperationResponse, @availability_set.save
    end
  end

  def test_destroy_method_response
    @service.stub :delete_availability_set, @response do
      assert_instance_of MsRestAzure::AzureOperationResponse, @availability_set.destroy
    end
  end
end
