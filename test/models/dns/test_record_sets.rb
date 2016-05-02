require File.expand_path '../../test_helper', __dir__

# Test class for Record Set Collection
class TestRecordSets < Minitest::Test
  def setup
    @service = Fog::DNS::AzureRM.new(credentials)
    @record_sets = Fog::DNS::AzureRM::RecordSets.new(resource_group: 'fog-test-rg', zone_name: 'fog-test-zone.com', type: 'A', service: @service)
    @response = [ApiStub::Models::DNS::RecordSet.list_record_sets]
  end

  def test_collection_methods
    methods = [
      :all,
      :get
    ]
    methods.each do |method|
      assert @record_sets.respond_to? method, true
    end
  end

  def test_collection_attributes
    assert @record_sets.respond_to? :resource_group, true
    assert @record_sets.respond_to? :zone_name, true
    assert @record_sets.respond_to? :type, true
  end

  def test_all_method_response
    @service.stub :list_record_sets, @response do
      assert_instance_of Fog::DNS::AzureRM::RecordSets, @record_sets.all
      assert @record_sets.all.size >= 1
      @record_sets.all.each do |s|
        assert_instance_of Fog::DNS::AzureRM::RecordSet, s
      end
    end
  end

  def test_all_method_name_response
    name_response = ApiStub::Models::DNS::RecordSet.list_record_sets
    name_response['name'] = '@'
    response = [name_response]
    @service.stub :list_record_sets, response do
      assert_instance_of Fog::DNS::AzureRM::RecordSets, @record_sets.all
    end
  end

  def test_get_method_response
    @service.stub :list_record_sets, @response do
      assert_instance_of Fog::DNS::AzureRM::RecordSet, @record_sets.get('fog-test-record_set', 'A')
    end
  end
end
