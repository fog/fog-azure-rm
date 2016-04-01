module Fog
  module DNS
    class AzureRM
      class Real
        def list_record_sets(dns_resource_group, zone_name)
          @record_set.list_record_sets(dns_resource_group, zone_name)
        end
      end

      class Mock
        def list_record_sets(dns_resource_group, zone_name)
          rset = {
            :name => 'fogtestrecordset',
            :resource_group => 'fog-test-resource-group',
            :zone_name => 'fogtestzone.com',
            :records => ['1.2.3.4', '1.2.3.3'],
            :type => 'A',
            :ttl => 60
          }
          [rset]
        end
      end
    end
  end
end