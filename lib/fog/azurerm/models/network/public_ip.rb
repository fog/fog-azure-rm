module Fog
  module Network
    class AzureRM
      # PublicIP model class for Network Service
      class PublicIp < Fog::Model
        identity :name
        attribute :id
        attribute :location
        attribute :resource_group
        attribute :ip_address
        attribute :public_ip_allocation_method
        attribute :idle_timeout_in_minutes
        attribute :ip_configuration_id
        attribute :domain_name_label
        attribute :fqdn
        attribute :reverse_fqdn

        def self.parse(public_ip)
          hash = {}
          hash['id'] = public_ip.id
          hash['name'] = public_ip.name
          hash['location'] = public_ip.location
          hash['resource_group'] = public_ip.id.split('/')[4]
          hash['public_ip_allocation_method'] = public_ip.public_ipallocation_method
          hash['ip_address'] = public_ip.ip_address
          hash['idle_timeout_in_minutes'] = public_ip.idle_timeout_in_minutes
          hash['ip_configuration_id'] = public_ip.ip_configuration.id unless public_ip.ip_configuration.nil?

          unless public_ip.dns_settings.nil?
            hash['domain_name_label'] = public_ip.dns_settings.domain_name_label
            hash['fqdn'] = public_ip.dns_settings.fqdn
            hash['reverse_fqdn'] = public_ip.dns_settings.reverse_fqdn
          end

          hash
        end

        def save
          requires :name
          requires :public_ip_allocation_method
          requires :location
          requires :resource_group
          public_ip = service.create_public_ip(resource_group, name, location, public_ip_allocation_method)
          merge_attributes(Fog::Network::AzureRM::PublicIp.parse(public_ip))
        end

        def destroy
          service.delete_public_ip(resource_group, name)
        end
      end
    end
  end
end
