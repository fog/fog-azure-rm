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
          hash = {}
          hash['name'] = probe.name
          hash['protocol'] = probe.protocol
          hash['host'] = probe.host
          hash['path'] = probe.path
          hash['interval'] = probe.interval
          hash['timeout'] = probe.timeout
          hash['unhealthy_threshold'] = probe.unhealthy_threshold
          hash
        end
      end
    end
  end
end
