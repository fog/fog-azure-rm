module Fog
  module Network
    class AzureRM
      # PublicIPs collection class for Network Service
      class PublicIps < Fog::Collection
        model Fog::Network::AzureRM::PublicIp
        attribute :resource_group

        def all
          requires :resource_group
          public_ips = []
          service.list_public_ips(resource_group).each do |pip|
            public_ips << Fog::Network::AzureRM::PublicIp.parse(pip)
          end
          load(public_ips)
        end

        def get(resource_group_name, public_ip_name)
          public_ip = service.get_public_ip(resource_group_name, public_ip_name)
          public_ip_fog = Fog::Network::AzureRM::PublicIp.new(service: service)
          public_ip_fog.merge_attributes(Fog::Network::AzureRM::PublicIp.parse(public_ip))
        end

        def check_public_ip_exists(resource_group, name)
          service.check_public_ip_exists(resource_group, name)
        end
      end
    end
  end
end
