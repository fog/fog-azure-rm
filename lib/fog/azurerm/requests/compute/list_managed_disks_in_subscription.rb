module Fog
  module Compute
    class AzureRM
      # Real class for Compute Request
      class Real
        def list_managed_disks_in_subscription
          msg = 'Listing all Managed Disks'
          Fog::Logger.debug msg
          begin
            managed_disks = @compute_mgmt_client.disks.list
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug 'Managed Disks listed successfully.'
          managed_disks
        end
      end

      # Mock class for Compute Request
      class Mock
        def list_managed_disks_in_subscription
          disks = [
            {
              'accountType' => 'Standard_LRS',
              'properties' => {
                'osType' => 'Windows',
                'creationData' => {
                  'createOption' => 'Empty'
                },
                'diskSizeGB' => 10,
                'encryptionSettings' => {
                  'enabled' => true,
                  'diskEncryptionKey' => {
                    'sourceVault' => {
                      'id' => '/subscriptions/{subscriptionId}/resourceGroups/myResourceGroup/providers/Microsoft.KeyVault/vaults/myVMVault'
                    },
                    'secretUrl' => 'https://myvmvault.vault-int.azure-int.net/secrets/{secret}'
                  },
                  'keyEncryptionKey' => {
                    'sourceVault' => {
                      'id' => '/subscriptions/{subscriptionId}/resourceGroups/myResourceGroup/providers/Microsoft.KeyVault/vaults/myVMVault'
                    },
                    'keyUrl' => 'https://myvmvault.vault-int.azure-int.net/keys/{key}'
                  }
                },
                'timeCreated' => '2016-12-28T02:46:21.3322041+00:00',
                'provisioningState' => 'Succeeded',
                'diskState' => 'Unattached'
              },
              'type' => 'Microsoft.Compute/disks',
              'location' => 'westus',
              'tags' => {
                'department' => 'Development',
                'project' => 'ManagedDisks'
              },
              'id' => '/subscriptions/{subscriptionId}/resourceGroups/myResourceGroup/providers/Microsoft.Compute/disks/myManagedDisk1',
              'name' => 'myManagedDisk1'
            }
          ]
          disk_mapper = Azure::Compute::Profiles::Latest::Mgmt::Models::DiskList.mapper
          @compute_mgmt_client.deserialize(disk_mapper, disks, 'result.body').value
        end
      end
    end
  end
end
