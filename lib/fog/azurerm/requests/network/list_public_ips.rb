module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def list_public_ips(resource_group)
          Fog::Logger.debug "Getting list of PublicIPs from Resource Group #{resource_group}."
          begin
            public_ips = @network_client.public_ipaddresses.list_as_lazy(resource_group)
            public_ips.next_link = '' if public_ips.next_link.nil?
            public_ips.value
          rescue  MsRestAzure::AzureOperationError => e
            raise Fog::AzureRm::OperationError.new(e)
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def list_public_ips(resource_group)
          [
            {
              'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/Microsoft.Network/publicIPAddresses/test-PubIP",
              'name' => 'test-PubIP',
              'type' => 'Microsoft.Network/publicIPAddresses',
              'location' => 'westus',
              'properties' =>
                {
                  'publicIPAllocationMethod' => 'Static',
                  'ipAddress' => '13.93.203.153',
                  'idleTimeoutInMinutes' => 4,
                  'resourceGuid' => 'c78f0c95-d8b9-409b-897c-74260b686392',
                  'provisioningState' => 'Succeeded'
                }
            }
          ]
        end
      end
    end
  end
end
