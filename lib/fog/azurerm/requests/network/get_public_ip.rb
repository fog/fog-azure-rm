module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def get_public_ip(resource_group_name, public_ip_name)
          Fog::Logger.debug "Getting Public IP #{public_ip_name} from Resource Group #{resource_group_name}"
          begin
            public_ip = @network_client.public_ipaddresses.get(resource_group_name, public_ip_name)
            Fog::Logger.debug "Public IP #{public_ip_name} retrieved successfully"
            public_ip
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, "Getting Public IP #{public_ip_name} from Resource Group #{resource_group_name}")
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def get_public_ip(resource_group_name, public_ip_name)
          public_ip = {
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
          public_ip_mapper = Azure::Network::Profiles::Latest::Mgmt::Models::PublicIPAddress.mapper
          @network_client.deserialize(public_ip_mapper, public_ip, 'result.body')
        end
      end
    end
  end
end
