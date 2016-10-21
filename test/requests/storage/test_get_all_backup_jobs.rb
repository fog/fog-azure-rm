require File.expand_path '../../test_helper', __dir__

# Test class for Get All Backup Jobs request
class TestGetAllBackupJobs < Minitest::Test
  def setup
    @service = Fog::Storage::AzureRM.new(credentials)
    @recovery_vaults = @service.recovery_vaults
    @token_provider = Fog::Credentials::AzureRM.instance_variable_get(:@token_provider)
  end

  def test_get_all_backup_jobs_success
    response = ApiStub::Requests::Storage::RecoveryVault.get_all_backup_jobs_response
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      RestClient.stub :get, response do
        assert_equal @service.get_all_backup_jobs('fog-test-vault', 'fog-test-rg'), JSON.parse(response)['value']
      end
    end
  end

  def test_get_all_backup_jobs_argument_error
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      assert_raises ArgumentError do
        @service.get_all_backup_jobs('fog-test-vault')
      end
    end
  end

  def test_get_all_backup_jobs_exception
    response = -> { fail Exception.new('mocked exception') }
    @token_provider.stub :get_authentication_header, response do
      assert_raises Exception do
        @service.get_all_backup_jobs('fog-test-vault', 'fog-test-rg')
      end
    end
  end
end
