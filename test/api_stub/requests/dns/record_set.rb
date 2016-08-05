module ApiStub
  module Requests
    module DNS
      # Mock class for Record Set
      class RecordSet
        def self.rest_client_put_method_for_record_set_a_type_response
          '{
              "id":"\/subscriptions\/########-####-####-####-############\/resourceGroups\/Fog_test_rg\/providers\/Microsoft.Network\/dnszones\/fog-test-zone.com\/CNAME\/fog-test-record_set",
              "name":"fog-test-record_set",
              "type":"Microsoft.Network\/dnszones\/A",
              "etag":"2cce3e93-fc64-43e4-835c-27581c28502b",
              "location":"global",
              "tags":{},
              "properties":
                          {
                              "metadata":{},
                              "fqdn":"fog-test-record_set.fog-test-zone.com.",
                              "TTL":60,
                              "ARecords":[{"ipv4Address":"1.2.3.4"},{"ipv4Address":"1.2.3.3"}]
                          }
          }'
        end

        def self.rest_client_put_method_for_record_set_cname_type_response
          '{
              "id":"\/subscriptions\/########-####-####-####-############\/resourceGroups\/Fog_test_rg\/providers\/Microsoft.Network\/dnszones\/fog-test-zone.com\/CNAME\/fog-test-record_set",
              "name":"fog-test-record_set",
              "type":"Microsoft.Network\/dnszones\/CNAME",
              "etag":"2cce3e93-fc64-43e4-835c-27581c28502b",
              "location":"global",
              "tags":{},
              "properties":
                          {
                              "metadata":{},
                              "fqdn":"fog-test-record_set.fog-test-zone.com.",
                              "TTL":60,
                              "CNAMERecord":{"cname":"1.2.3.4"}
                          }
          }'
        end

        def self.list_record_sets_response
          '{
              "value": [{
              "id":"\/subscriptions\/########-####-####-####-############\/resourceGroups\/Fog_test_rg\/providers\/Microsoft.Network\/dnszones\/fog-test-zone.com\/CNAME\/fog-test-record_set",
              "name":"fog-test-record_set",
              "type":"Microsoft.Network\/dnszones\/A",
              "etag":"2cce3e93-fc64-43e4-835c-27581c28502b",
              "location":"global",
              "tags":{},
              "properties":
                          {
                              "metadata":{},
                              "fqdn":"fog-test-record_set.fog-test-zone.com.",
                              "TTL":60,
                              "ARecords":[{"ipv4Address":"1.2.3.4"},{"ipv4Address":"1.2.3.3"}]
                          }
          }]
          }'
        end

        def self.record_set_response_for_a_type_response
          '{
            "id": "/subscriptions/########-####-####-####-############/resourceGroups/EdgeMonitoring2/providers/Microsoft.Network/dnszones/edgemonitoring2.com./A/www",
            "location": "global",
            "name": "www",
            "tags": {},
            "type": "Microsoft.Network/dnszones/A",
            "etag": "5b83020b-b59c-44be-8f19-a052ebe80fe7",
            "properties": {
              "TTL": 3600,
              "ARecords": [
              {
                "ipv4Address": "4.3.2.1"
              },
              {
                "ipv4Address": "5.3.2.1"
              }
              ]
            }
          }'
        end

        def self.record_set_response_for_cname_type
          '{
            "id": "/subscriptions/########-####-####-####-############/resourceGroups/EdgeMonitoring2/providers/Microsoft.Network/dnszones/edgemonitoring2.com./CNAME/www",
            "location": "global",
            "name": "www",
            "tags": {},
            "type": "Microsoft.Network/dnszones/CNAME",
            "etag": "5b83020b-b59c-44be-8f19-a052ebe80fe7",
            "properties": {
              "metadata": "nil",
              "fqdn": "fog-test-record_set.fog-test-zone.com.",
              "TTL": "60",
              "CNAMERecord": {
                "cname": "test.fog.com"
              }
            }
          }'
        end
      end
    end
  end
end
