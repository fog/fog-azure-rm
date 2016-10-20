require File.expand_path '../../test_helper', __dir__

class TestGetBackupJobForVM < Minitest::Test
  def setup
    @service = Fog::Storage::AzureRM.new(credentials)
    @recovery_vaults = @service.recovery_vaults
    @token_provider = Fog::Credentials::AzureRM.instance_variable_get(:@token_provider)
  end

  def test_get_backup_job_for_vm_success
    backup_jobs_response = ApiStub::Requests::Storage::RecoveryVault.get_all_backup_jobs_response
    single_backup_job_response = JSON.parse(backup_jobs_response)['value'][0]
    @service.stub :get_all_backup_jobs, JSON.parse(backup_jobs_response)['value'] do
      assert_equal @service.get_backup_job_for_vm('fog-test-vault', 'fog-test-vault', 'fog-test-vm', 'fog-test-vm-rg', 'Backup'), single_backup_job_response
    end
  end

  def test_get_backup_job_for_vm_argument_error
    backup_jobs_response = ApiStub::Requests::Storage::RecoveryVault.get_all_backup_jobs_response
    @service.stub :get_all_backup_jobs, JSON.parse(backup_jobs_response)['value'] do
      assert_raises ArgumentError do
        @service.get_backup_job_for_vm('fog-test-vault', 'fog-test-vault', 'fog-test-vm')
      end
    end
  end
end