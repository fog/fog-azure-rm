module Fog
  module Storage
    class AzureRM
      # Real class for Recovery Vault request
      class Real
        def get_backup_job_for_vm(rv_name, rv_resource_group, vm_name, vm_resource_group, operation)
          msg = "Getting backup job for VM #{vm_name} in Resource Group #{vm_resource_group}"
          Fog::Logger.debug msg

          backup_jobs = get_all_backup_jobs(rv_name, rv_resource_group)
          backup_job = backup_jobs.select { |job|
            (job['properties']['status'].eql? 'InProgress') &&
            (job['properties']['entityFriendlyName'].eql? vm_name.downcase) &&
            (job['properties']['operation'].eql? operation)
          }

          backup_job[0]
        end
      end

      # Mock class for Recovery Vault request
      class Mock
        def get_backup_job_for_vm(*)

        end
      end
    end
  end
end