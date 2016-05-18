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
          pip_properties = pip['properties']
          hash = {}
          hash['id'] = pip['id']
          hash['name'] = pip['name']
          hash['location'] = pip['location']
          hash['resource_group'] = pip['id'].split('/')[4]
          hash['public_ip_allocation_method'] = pip_properties['publicIPAllocationMethod']
          hash['ip_address'] = pip_properties['ipAddress']
          hash['idle_timeout_in_minutes'] = pip_properties['idleTimeoutInMinutes']
          hash['ip_configuration_id'] = pip_properties['ipConfiguration']['id'] unless pip_properties['ipConfiguration'].nil?

          unless pip_properties['dnsSettings'].nil?
            hash['domain_name_label'] = pip_properties['dnsSettings']['domainNameLabel']
            hash['fqdn'] = pip_properties['dnsSettings']['fqdn']
            hash['reverse_fqdn'] = pip_properties['dnsSettings']['reverseFqdn']
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
