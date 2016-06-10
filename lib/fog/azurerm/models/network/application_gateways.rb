require 'fog/core/collection'
require 'fog/azurerm/models/network/application_gateway'

module Fog
  module Network
    class AzureRM
      # Application Gateway collection class for Network Service
      class ApplicationGateways < Fog::Collection
        model Fog::Network::AzureRM::ApplicationGateway
        attribute :resource_group

        def all
          requires :resource_group
          application_gateways = []
          service.list_application_gateways(resource_group).each do |gateway|
            application_gateways << Fog::Network::AzureRM::ApplicationGateway.parse(gateway)
          end
          load(application_gateways)
        end

        def get(identity)
          all.find { |f| f.name == identity }
        end
      end
    end
  end
end
