module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def list_load_balancers_in_subscription
          msg = 'Getting list of Load-Balancers in subscription'
          Fog::Logger.debug msg
          begin
            load_balancers = @network_client.load_balancers.list_all
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug 'Successfully retrieved load balancers in subscription'
          load_balancers
        end
      end

      # Mock class for Network Request
      class Mock
        def list_load_balancers_in_subscription
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
