module ApiStub
  module Requests
    module Compute
      # Mock class for Managed Disk Requests
      class ManagedDisk
        def self.create_or_update_managed_disk_response(compute_client)
          body = '{
            "accountType": "Standard_LRS",
            "properties": {
              "osType": "Windows",
              "creationData": {
                "createOption": "Empty"
              },
              "diskSizeGB": 10,
              "encryptionSettings": {
                "enabled": true,
                "diskEncryptionKey": {
                  "sourceVault": {
                    "id": "/subscriptions/{subscriptionId}/resourceGroups/myResourceGroup/providers/Microsoft.KeyVault/vaults/myVMVault"
                  },
                  "secretUrl": "https://myvmvault.vault-int.azure-int.net/secrets/{secret}"
                },
                "keyEncryptionKey": {
                  "sourceVault": {
                    "id": "/subscriptions/{subscriptionId}/resourceGroups/myResourceGroup/providers/Microsoft.KeyVault/vaults/myVMVault"
                  },
                  "keyUrl": "https://myvmvault.vault-int.azure-int.net/keys/{key}"
                }
              },
              "timeCreated": "2016-12-28T02:46:21.3322041+00:00",
              "provisioningState": "Succeeded",
              "diskState": "Unattached"
            },
            "type": "Microsoft.Compute/disks",
            "location": "westus",
            "tags": {
              "department": "Development",
              "project": "ManagedDisks"
            },
            "id": "/subscriptions/{subscriptionId}/resourceGroups/myResourceGroup/providers/Microsoft.Compute/disks/myManagedDisk1",
            "name": "myManagedDisk1"
          }'
          disk_mapper = Azure::Compute::Profiles::Latest::Mgmt::Models::Disk.mapper
          compute_client.deserialize(disk_mapper, Fog::JSON.decode(body), 'result.body')
        end

        def self.get_managed_disk_response(sdk_compute_client)
          body = '{
             "value": [ {
                "accountType": "Standard_LRS",
                "properties": {
                  "osType": "Windows",
                  "creationData": {
                    "createOption": "Empty"
                  },
                  "diskSizeGB": 10,
                  "encryptionSettings": {
                    "enabled": true,
                    "diskEncryptionKey": {
                      "sourceVault": {
                        "id": "/subscriptions/{subscriptionId}/resourceGroups/myResourceGroup/providers/Microsoft.KeyVault/vaults/myVMVault"
                      },
                      "secretUrl": "https://myvmvault.vault-int.azure-int.net/secrets/{secret}"
                    },
                    "keyEncryptionKey": {
                      "sourceVault": {
                        "id": "/subscriptions/{subscriptionId}/resourceGroups/myResourceGroup/providers/Microsoft.KeyVault/vaults/myVMVault"
                      },
                      "keyUrl": "https://myvmvault.vault-int.azure-int.net/keys/{key}"
                    }
                  },
                  "timeCreated": "2016-12-28T02:46:21.3322041+00:00",
                  "provisioningState": "Succeeded",
                  "diskState": "Unattached"
                },
                "type": "Microsoft.Compute/disks",
                "location": "westus",
                "tags": {
                  "department": "Development",
                  "project": "ManagedDisks"
                },
                "id": "/subscriptions/{subscriptionId}/resourceGroups/myResourceGroup/providers/Microsoft.Compute/disks/myManagedDisk1",
                "name": "myManagedDisk1"
             } ]
          }'
          disk_mapper = Azure::Compute::Profiles::Latest::Mgmt::Models::Disk.mapper
          sdk_compute_client.deserialize(disk_mapper, Fog::JSON.decode(body), 'result.body')
        end

        def self.operation_status_response(sdk_compute_client)
          response = {
            'name' => 'xxxx-xxxxx-xxxx',
            'status' => 'success',
            'error' => 'ERROR'
          }
          response_mapper = Azure::Compute::Profiles::Latest::Mgmt::Models::OperationStatusResponse.mapper
          sdk_compute_client.deserialize(response_mapper, response, 'result.body')
        end
      end
    end
  end
end
