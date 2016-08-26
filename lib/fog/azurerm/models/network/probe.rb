module Fog
  module Network
    class AzureRM
      # Probe model for Network Service
      class Probe < Fog::Model
        identity :name
        attribute :id
        attribute :protocol
        attribute :port
        attribute :request_path
        attribute :interval_in_seconds
        attribute :number_of_probes

        def self.parse(probe)
          hash = {}
          hash['id'] = probe.id
          hash['name'] = probe.name
          hash['protocol'] = probe.protocol
          hash['port'] = probe.port
          hash['request_path'] = probe.request_path
          hash['interval_in_seconds'] = probe.interval_in_seconds
          hash['number_of_probes'] = probe.number_of_probes
          hash
        end
      end
    end
  end
end
