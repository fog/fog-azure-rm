require File.expand_path('../../../helper', __FILE__)
# rubocop:disable LineLength
Shindo.tests('Fog::Compute[:azurerm] | availability_sets request', %w(azurerm compute)) do
  tests('#availability_sets') do
    availability_sets = azurerm_compute_service.availability_sets(resource_group: rg_name)
    availability_sets = [fog_availability_set] if availability_sets.empty?

    test 'returns a Array' do
      availability_sets.is_a? Array
    end

    test('should return valid availability set name') do
      availability_sets.first.name.is_a? String
    end

    test('should return records') do
      availability_sets.size >= 1
    end
  end
end
