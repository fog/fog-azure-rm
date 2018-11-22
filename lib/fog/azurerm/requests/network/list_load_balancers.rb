module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def list_load_balancers(resource_group)
          msg = "Getting list of Load-Balancers from Resource Group #{resource_group}"
          Fog::Logger.debug msg
          begin
            load_balancers = @network_client.load_balancers.list_as_lazy(resource_group)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Successfully retrieved load balancers from Resource Group #{resource_group}"
          load_balancers.value
        end
      end

      # Mock class for Network Request
      class Mock
        def list_load_balancers(_resource_group)
          lb = Azure::Network::Profiles::Latest::Mgmt::Models::LoadBalancer.new
          lb.name = 'fogtestloadbalancer'
          lb.location = 'West US'
          lb.properties = Azure::Network::Profiles::Latest::Mgmt::Models::LoadBalancerPropertiesFormat.new
          [lb]
        end
      end
    end
  end
end
