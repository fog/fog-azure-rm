require 'fog/core/collection'
require 'fog/azurerm/models/network/load_balancer'

module Fog
  module Network
    class AzureRM
      # LoadBalancers collection class for Network Service
      class LoadBalancers < Fog::Collection
        model Fog::Network::AzureRM::LoadBalancer
        attribute :resource_group

        def all
          requires :resource_group
          load_balancers = []
          service.list_load_balancers(resource_group).each do |load_balancer|
            load_balancers << Fog::Network::AzureRM::LoadBalancer.parse(load_balancer)
          end
          load(load_balancers)
        end

        def get(identity)
          all.find { |f| f.name == identity }
        end
      end
    end
  end
end
