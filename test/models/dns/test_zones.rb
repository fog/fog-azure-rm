require File.expand_path '../../test_helper', __dir__

# Test class for Zone Collection
class TestZones < Minitest::Test
  def setup
    @service = Fog::DNS::AzureRM.new(credentials)
    @zones = Fog::DNS::AzureRM::Zones.new(service: @service)
    @dns_client1 = @service.instance_variable_get(:@dns_client)
    @response = [ApiStub::Models::DNS::Zone.create_zone_obj(@dns_client1)]
  end

  def test_collection_methods
    methods = [
      :all,
      :get,
      :check_zone_exists?
    ]
    methods.each do |method|
      assert_respond_to @zones, method
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
    response = ApiStub::Models::DNS::Zone.create_zone_obj(@dns_client1)
    @service.stub :get_zone, response do
      assert_instance_of Fog::DNS::AzureRM::Zone, @zones.get('fog-test-rg', 'fog-test-zone.com')
    end
  end

  def test_check_zone_exists_true_response
    @service.stub :check_zone_exists?, true do
      assert @zones.check_zone_exists?('fog-test-rg', 'fog-test-zone.com')
    end
  end

  def test_check_zone_exists_false_response
    @service.stub :check_zone_exists?, true do
      assert @zones.check_zone_exists?('fog-test-rg', 'fog-test-zone.com')
    end
  end
end
