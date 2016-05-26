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
          probe_prop = probe['properties']
          hash = {}
          hash['id'] = probe['id']
          hash['name'] = probe['name']
          hash['protocol'] = probe_prop['protocol']
          hash['port'] = probe_prop['port']
          hash['request_path'] = probe_prop['requestPath']
          hash['interval_in_seconds'] = probe_prop['intervalInSeconds']
          hash['number_of_probes'] = probe_prop['numberOfProbes']
          hash
        end
      end
    end
  end
end
