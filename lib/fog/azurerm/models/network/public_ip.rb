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

        def self.parse(pip)
          hash = {}
          hash['id'] = pip.id
          hash['name'] = pip.name
          hash['location'] = pip.location
          hash['resource_group'] = pip.id.split('/')[4]
          hash['public_ip_allocation_method'] = pip.public_ipallocation_method
          hash['ip_address'] = pip.ip_address
          hash['idle_timeout_in_minutes'] = pip.idle_timeout_in_minutes
          hash['ip_configuration_id'] = pip.ip_configuration.id unless pip.ip_configuration.nil?

          unless pip.dns_settings.nil?
            hash['domain_name_label'] = pip.dns_settings.domain_name_label
            hash['fqdn'] = pip.dns_settings.fqdn
            hash['reverse_fqdn'] = pip.dns_settings.reverse_fqdn
          end

          hash
        end

        def save
          requires :name
          requires :public_ip_allocation_method
          requires :location
          requires :resource_group
          pip = service.create_public_ip(resource_group, name, location, public_ip_allocation_method)
          merge_attributes(Fog::Network::AzureRM::PublicIp.parse(pip))
        end

        def destroy
          service.delete_public_ip(resource_group, name)
        end
      end
    end
  end
end
