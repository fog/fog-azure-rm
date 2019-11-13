module Fog
  module ApplicationGateway
    class AzureRM
      # Real class for Application Gateway Request
      class Real
        def list_application_gateways(resource_group)
          msg = "Getting list of Application-Gateway from Resource Group #{resource_group}."
          Fog::Logger.debug msg
          begin
            gateways = @network_client.application_gateways.list_as_lazy(resource_group)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          gateways.value
        end
      end

      # Mock class for Network Request
      class Mock
        def list_application_gateways(_resource_group)
          ag = Azure::Network::Profiles::Latest::Mgmt::Models::ApplicationGateway.new
          ag.name = 'fogtestgateway'
          ag.location = 'East US'
          [ag]
        end
      end
    end
  end
end
