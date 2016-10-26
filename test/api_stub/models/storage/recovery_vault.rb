module ApiStub
  module Models
    module Storage
      # Mock class for Recovery Vault model
      class RecoveryVault
        def self.create_method_response
          {
            'id' => '/subscriptions/#{67f2116d}#######-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.RecoveryServices/vaults/fog-test-vault',
            'location' => 'westus',
            'name' => 'fog-test-vault',
            'properties' => {
              'provisioningState' => 'Succeeded'
            },
            'type' => 'Microsoft.RecoveryServices/vaults',
            'sku' => {
              'name' => 'standard'
            }
          }
        end
      end
    end
  end
end
