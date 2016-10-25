module ApiStub
  module Requests
    module Storage
      # Mock class for RecoveryVault request
      class RecoveryVault
        def self.create_recovery_vault_response
          '{
            "location": "westus",
            "name": "fog-test-vault",
            "properties": {
              "provisioningState": "Succeeded"
            },
            "id": "/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.RecoveryServices/vaults/fog-test-vault",
            "type": "Microsoft.RecoveryServices\/vaults",
            "sku": {
              "name": "standard"
            }
          }'
        end

        def self.get_recovery_vault_response
          '{
            "value": [{
              "location": "westus",
              "name": "fog-test-vault",
              "properties": {
                "provisioningState": "Succeeded"
              },
              "id": "/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.RecoveryServices/vaults/fog-test-vault",
              "type": "Microsoft.RecoveryServices/vaults",
              "sku": {
                "name": "standard"
              }
            }]
          }'
        end

        def self.get_all_backup_jobs_response
          '{
            "value": [{
              "id": "/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.RecoveryServices/vaults/fog-test-vault/backupJobs/########-####-####-####-############",
              "name": "########-####-####-####-############",
              "type": "Microsoft.RecoveryServices/vaults/backupJobs",
              "properties": {
                "jobType": "AzureIaaSVMJob",
                "duration": "XX:XX:XX.XXXXXXX",
                "actionsInfo": [
                  1
                ],
                "virtualMachineVersion": "Compute",
                "entityFriendlyName": "fog-test-vm",
                "backupManagementType": "AzureIaasVM",
                "operation": "Backup",
                "status": "InProgress",
                "startTime": "2016-10-19T07:49:31.1466534Z",
                "activityId": "########-####-####-####-############"
              }
            }]
          }'
        end

        def self.get_backup_container_response
          '{
            "value": [{
              "id": "/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.RecoveryServices/vaults/fog-test-vault/backupFabrics/Azure/protectionContainers/IaasVMContainer;iaasvmcontainerv2;fog-test-vm-rg;fog-test-vm",
              "name": "IaasVMContainer;iaasvmcontainerv2;fog-test-vm-rg;fog-test-vm",
              "type": "Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers",
              "properties": {
                "virtualMachineId": "/subscriptions/########-####-####-####-############/resourceGroups/TestRG/providers/Microsoft.Compute/virtualMachines/TestVM",
                "virtualMachineVersion": "Compute",
                "resourceGroup": "fog-test-vm-rg",
                "friendlyName": "fog-test-vm",
                "backupManagementType": "AzureIaasVM",
                "registrationStatus": "Registered",
                "healthStatus": "Healthy",
                "containerType": "Microsoft.Compute/virtualMachines",
                "protectableObjectType": "Microsoft.Compute/virtualMachines"
              }
            }]
          }'
        end

        def self.get_backup_item_response
          '{
            "value": [{
              "id": "/Subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.RecoveryServices/vaults/fog-test-vault/backupFabrics/Azure/protectionContainers/IaasVMContainer;iaasvmcontainerv2;testrg;testvm/protectedItems/VM;fog-test-container-name",
              "name": "iaasvmcontainerv2;fog-test-vm-rg;fog-test-vm",
              "type": "Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems",
              "properties": {
                "friendlyName": "fog-test-vm",
                "virtualMachineId": "/subscriptions/########-####-####-####-############/resourceGroups/fog-test-vm-rg/providers/Microsoft.Compute/virtualMachines/fog-test-vm",
                "protectionStatus": "Healthy",
                "protectionState": "Protected",
                "lastBackupStatus": "Completed",
                "lastBackupTime": "2016-10-17T10:30:47.2289274Z",
                "protectedItemType": "Microsoft.Compute/virtualMachines",
                "backupManagementType": "AzureIaasVM",
                "workloadType": "VM",
                "containerName": "iaasvmcontainerv2;fog-test-vm-rg;fog-test-vm",
                "sourceResourceId": "/subscriptions/########-####-####-####-############/resourceGroups/fog-test-vm-rg/providers/Microsoft.Compute/virtualMachines/fog-test-vm",
                "policyId": "/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.RecoveryServices/vaults/fog-test-vault/backupPolicies/DefaultPolicy",
                "policyName": "DefaultPolicy",
                "lastRecoveryPoint": "2016-10-17T10:32:38.4666692Z"
              }
            }]
          }'
        end

        def self.list_recovery_vault_response
          '{
            "value": [{
              "location": "westus",
              "name": "fog-test-vault",
              "properties": {
                "provisioningState": "Succeeded"
              },
              "id": "/subscriptions/########-####-####-####-############/resourceGroups/fog-test-vault/providers/Microsoft.RecoveryServices/vaults/fog-test-vault",
              "type": "Microsoft.RecoveryServices/vaults",
              "sku": {
                "name": "standard"
              }
            }]
          }'
        end

        def self.get_backup_protection_policy_response
          '{
            "value": [{
              "id": "/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.RecoveryServices/vaults/fog-test-vault/backupPolicies/DefaultPolicy",
              "name": "DefaultPolicy",
              "type": "Microsoft.RecoveryServices/vaults/backupPolicies",
              "properties": {
                "backupManagementType": "AzureIaasVM",
                "schedulePolicy": {
                  "schedulePolicyType": "SimpleSchedulePolicy",
                  "scheduleRunFrequency": "Daily",
                  "scheduleRunTimes": [
                    "2016-10-13T19:30:00Z"
                  ],
                  "scheduleWeeklyFrequency": 0
                },
                "retentionPolicy": {
                  "retentionPolicyType": "LongTermRetentionPolicy",
                  "dailySchedule": {
                    "retentionTimes": [
                      "2016-10-13T19:30:00Z"
                    ],
                    "retentionDuration": {
                      "count": 30,
                      "durationType": "Days"
                    }
                  }
                },
                "protectedItemsCount": 0
              }
            }]
          }'
        end

        def self.get_backup_job_for_vm_response
          '{
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
        end
      end
    end
  end
end
