module Fog
  module DNS
    class AzureRM
      # This class is giving an implementation of 'A' RecordSet type
      class ARecord < Fog::Model
        attribute :ipv4address

        def self.parse(arecord)
          hash = get_hash_from_object(arecord)
          hash
        end
      end
    end
  end
end
