module Fog
  module ApplicationGateway
    class AzureRM
      # Probe model class for Application Gateway Service
      class Probe < Fog::Model
        identity :name
        attribute :protocol
        attribute :host
        attribute :path
        attribute :interval
        attribute :timeout
        attribute :unhealthy_threshold

        def self.parse(probe)
          probe_properties = probe['properties']

          hash = {}
          hash['name'] = probe['name']
          unless probe_properties.nil?
            hash['protocol'] = probe_properties['protocol']
            hash['host'] = probe_properties['host']
            hash['path'] = probe_properties['path']
            hash['interval'] = probe_properties['interval']
            hash['timeout'] = probe_properties['timeout']
            hash['unhealthy_threshold'] = probe_properties['unhealthyThreshold']
          end
          hash
        end
      end
    end
  end
end
