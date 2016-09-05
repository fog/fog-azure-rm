require File.expand_path '../../test_helper', __dir__

# Test class for Zone Collection
class TestZones < Minitest::Test
  def setup
    @service = Fog::DNS::AzureRM.new(credentials)
    @zones = Fog::DNS::AzureRM::Zones.new(service: @service)
    @response = [ApiStub::Models::DNS::Zone.list_zones]
  end

  def test_collection_methods
    methods = [
      :all,
      :get,
      :check_for_zone
    ]
    methods.each do |method|
      assert @zones.respond_to? method, true
    end
  end

  def test_all_method_response
    @service.stub :list_zones, @response do
      assert_instance_of Fog::DNS::AzureRM::Zones, @zones.all
      assert @zones.all.size >= 1
      @zones.all.each do |s|
        assert_instance_of Fog::DNS::AzureRM::Zone, s
      end
    end
  end

  def test_get_method_response
    response = ApiStub::Models::DNS::Zone.create_zone_obj
    @service.stub :get_zone, response do
      assert_instance_of Fog::DNS::AzureRM::Zone, @zones.get('fog-test-rg', 'fog-test-zone.com')
    end
  end

  def test_check_for_zone_true_response
    @service.stub :check_for_zone, true do
      assert @zones.check_for_zone('fog-test-rg', 'fog-test-zone.com')
    end
  end

  def test_check_for_zone_false_response
    @service.stub :check_for_zone, false do
      assert !@zones.check_for_zone('fog-test-rg', 'fog-test-zone.com')
    end
  end
end
