module Fog
  module Storage
    class AzureRM
      # Real class for Recovery Vault request
      class Real
        def get_backup_job_for_vm(rv_name, rv_resource_group, vm_name, vm_resource_group, operation)
          msg = "Getting backup job for VM #{vm_name} in Resource Group #{vm_resource_group}"
          Fog::Logger.debug msg

          backup_jobs = get_all_backup_jobs(rv_name, rv_resource_group)
          backup_jobs = backup_jobs.select do |job|
            (job['properties']['status'].eql? 'InProgress') &&
            (job['properties']['entityFriendlyName'].eql? vm_name.downcase) &&
            (job['properties']['operation'].eql? operation)
          end

          backup_jobs[0]
        end
      end

      # Mock class for Recovery Vault request
      class Mock
        def get_backup_job_for_vm(*)
          body = '{
            "id": "/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.RecoveryServices/vaults/fog-test-vault/backupJobs/########-####-####-####-############",
            "name": "########-####-####-####-############",
            "type": "Microsoft.RecoveryServices/vaults/backupJobs",
            "properties": {
              "jobType": "AzureIaaSVMJob",
              "duration": "00:00:52.3309441",
              "virtualMachineVersion": "Compute",
              "extendedInfo": {
                "tasksList": [],
                "propertyBag": {
                  "VM Name": "fog-test-vm",
                  "Policy Name": "DefaultPolicy"
                }
              },
              "entityFriendlyName": "fog-test-vm",
              "backupManagementType": "AzureIaasVM",
              "operation": "ConfigureBackup",
              "status": "Completed",
              "startTime": "2016-10-13T09:55:49.1168243Z",
              "endTime": "2016-10-13T09:56:41.4477684Z",
              "activityId": "383f05d9-a4bf-4b95-bb41-d39849b3a86e-2016-10-13 09:55:53Z-PS"
            }
          }'
          Fog::JSON.decode(body)
        end
      end
    end
  end
end
