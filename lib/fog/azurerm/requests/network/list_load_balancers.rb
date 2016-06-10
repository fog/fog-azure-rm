module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def list_load_balancers(resource_group)
          Fog::Logger.debug "Getting list of Load-Balancers from Resource Group #{resource_group}."
          begin
            promise = @network_client.load_balancers.list(resource_group)
            result = promise.value!
            Azure::ARM::Network::Models::LoadBalancerListResult.serialize_object(result.body)['value']
          rescue MsRestAzure::AzureOperationError => e
            msg = "Exception listing Load-Balancers from Resource Group '#{resource_group}'. #{e.body['error']['message']}."
            raise msg
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def list_load_balancers(_resource_group)
          lb = Azure::ARM::Network::Models::LoadBalancer.new
          lb.name = 'fogtestloadbalancer'
          lb.location = 'West US'
          lb.properties = Azure::ARM::Network::Models::LoadBalancerPropertiesFormat.new
          [lb]
        end
      end
    end
  end
end
