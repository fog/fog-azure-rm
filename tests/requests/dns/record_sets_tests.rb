require File.expand_path('../../../helper', __FILE__)

Shindo.tests('Fog::DNS[:azurerm] | record_sets request', %w(azurerm dns)) do
  tests('#record_sets') do
    rsets = azurerm_dns_service.record_sets({:resource_group => rg_name, :zone_name => zone_name})
    rsets = [fog_record_set] if rsets.empty?

    test 'returns a Array' do
      rsets.is_a? Array
    end

    test('should return valid record_set name') do
      puts rsets.first.name
      rsets.first.name.is_a? String
    end

    test('should return recordsets') do
      rsets.size >= 1
    end
  end
end
