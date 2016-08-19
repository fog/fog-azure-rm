module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def get_public_ip(resource_group_name, public_ip_name)
          Fog::Logger.debug "Getting Public IP #{public_ip_name} from Resource Group #{resource_group_name}"
          begin
            result = @network_client.public_ipaddresses.get(resource_group_name, public_ip_name)
            Fog::Logger.debug "Public IP #{public_ip_name} retrieved successfully"
            result
          rescue MsRestAzure::AzureOperationError => e
            raise Fog::AzureRm::OperationError.new(e)
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def get_public_ip(resource_group_name, public_ip_name)
          {
            'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group_name}/providers/Microsoft.Network/publicIPAddresses/#{public_ip_name}",
            'name' => public_ip_name,
            'type' => 'Microsoft.Network/publicIPAddresses',
            'location' => 'westus',
            'properties' =>
              {
                'publicIPAllocationMethod' => 'Dynamic',
                'ipAddress' => '13.91.253.67',
                'idleTimeoutInMinutes' => 4,
                'resourceGuid' => '767b1955-94de-433c-8e4a-ea0ad25e8d0c',
                'provisioningState' => 'Succeeded'
              }
          }
        end
      end
    end
  end
end
