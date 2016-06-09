module Fog
  module Network
    class AzureRM
      # Probe model class for Network Service
      class Probe < Fog::Model
        identity :name
        attribute :id
        attribute :protocol
        attribute :host
        attribute :path
        attribute :interval
        attribute :timeout
        attribute :unhealthyThreshold

        def self.parse(probe)
          probe_properties = probe['properties']

          hash = {}
          hash['name'] = probe['name']
          hash['id'] = probe['id']
          unless probe_properties.nil?
            hash['protocol'] = probe_properties['protocol']
            hash['host'] = probe_properties['host']
            hash['path'] = probe_properties['path']
            hash['interval'] = probe_properties['interval']
            hash['timeout'] = probe_properties['timeout']
            hash['unhealthyThreshold'] = probe_properties['unhealthyThreshold']
          end
          hash
        end
      end
    end
  end
end
