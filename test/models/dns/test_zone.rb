require File.expand_path '../../test_helper', __dir__

# Test class for Zone Model
class TestZone < Minitest::Test
  def setup
    @service = Fog::DNS::AzureRM.new(credentials)
    @zone = zone(@service)
    @dns_client1 = @service.instance_variable_get(:@dns_client)
    @response = ApiStub::Models::DNS::Zone.create_zone_obj(@dns_client1)
  end

  def test_model_methods
    methods = [
      :save,
      :destroy
    ]
    methods.each do |method|
      assert_respond_to @zone, method
    end
  end

  def test_model_attributes
    attributes = [
      :name,
      :id,
      :resource_group,
      :tags
    ]
    attributes.each do |attribute|
      assert_respond_to @zone, attribute
    end
  end

  def test_save_method_response
    @service.stub :create_or_update_zone, @response do
      assert_instance_of Fog::DNS::AzureRM::Zone, @zone.save
    end
  end

  def test_destroy_method_true_response
    @service.stub :delete_zone, true do
      assert @zone.destroy
    end
  end

  def test_destroy_method_false_response
    @service.stub :delete_zone, false do
      assert !@zone.destroy
    end
  end
end
