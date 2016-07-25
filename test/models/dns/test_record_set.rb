require File.expand_path '../../test_helper', __dir__

# Test class for Record Set Model
class TestRecordSet < Minitest::Test
  def setup
    @service = Fog::DNS::AzureRM.new(credentials)
    @record_set = record_set(@service)
    @response = ApiStub::Models::DNS::RecordSet.create_record_set_obj
  end

  def test_model_methods
    methods = [
      :save,
      :destroy,
      :get_records
    ]
    methods.each do |method|
      assert @record_set.respond_to? method, true
    end
  end

  def test_model_attributes
    attributes = [
      :name,
      :resource_group,
      :zone_name,
      :records,
      :type,
      :ttl
    ]
    attributes.each do |attribute|
      assert @record_set.respond_to? attribute, true
    end
  end

  def test_save_method_response
    @service.stub :create_record_set, @response do
      assert_instance_of Fog::DNS::AzureRM::RecordSet, @record_set.save
    end
  end

  def test_destroy_method_true_response
    @service.stub :delete_record_set, true do
      assert @record_set.destroy
    end
  end

  def test_destroy_method_false_response
    @service.stub :delete_record_set, false do
      assert !@record_set.destroy
    end
  end

  def test_get_records_response
    @service.stub :get_records_from_record_set, ['4.3.2.1', '5.3.2.1'] do
      assert_equal @record_set.get_records('fog-test-rg', 'fog-test-record-set', 'fog-test-zone', 'A'), ['4.3.2.1', '5.3.2.1']
    end
  end

  def test_update_response
    @service.stub :create_record_set, @response do
      assert_instance_of Fog::DNS::AzureRM::RecordSet, @record_set.update(ttl: 70)
      assert_raises RuntimeError do
        @record_set.update(type: 'CNAME')
      end
      assert_raises RuntimeError do
        @record_set.update(ttl: 70, name: 'fog-test-record-set')
      end
      assert_raises RuntimeError do
        @record_set.update(records: ['4.3.2.1', '5.3.2.1'])
      end
    end
  end

  def test_add_a_type_record_response
    @service.stub :create_record_set, @response do
      assert_instance_of Fog::DNS::AzureRM::RecordSet, @record_set.add_a_type_record('5.3.2.1')
    end
  end

  def test_remove_a_type_record_response
    @service.stub :create_record_set, @response do
      assert_instance_of Fog::DNS::AzureRM::RecordSet, @record_set.remove_a_type_record('5.3.2.1')
    end
  end
end
