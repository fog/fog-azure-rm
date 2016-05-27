require File.expand_path '../../test_helper', __dir__

# Test class for Delete Record Set Request
class TestDeleteRecordSet < Minitest::Test
  def setup
    @service = Fog::DNS::AzureRM.new(credentials)
    @record_sets = @service.record_sets
    @token_provider = Fog::Credentials::AzureRM.instance_variable_get(:@token_provider)
  end

  def test_delete_record_set_success
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      RestClient.stub :delete, true do
        assert @service.delete_record_set('fog-test-rg', 'fog-test-record-set', 'fog-test-zone', 'A')
      end
    end
  end

  def test_delte_record_set_failure
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      assert_raises ArgumentError do
        @service.delete_record_set('fog-test-rg', 'fog-test-record-set', 'fog-test-zone')
      end
    end
  end

  def test_create_record_set_exception
    response = -> { fail Exception.new('mocked exception') }
    @token_provider.stub :get_authentication_header, response do
      assert_raises Exception do
        assert @service.delete_record_set('fog-test-rg', 'fog-test-record-set', 'fog-test-zone', 'A')
      end
    end
  end
end
