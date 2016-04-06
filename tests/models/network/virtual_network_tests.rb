require File.expand_path('../../../helper', __FILE__)

Shindo.tests('Fog::Network[:azurerm] | virtual_network model', %w(azurerm network)) do
  vnet = fog_virtual_network

  tests('The virtual_network model should') do
    tests('have the action') do
      test('reload') { vnet.respond_to? 'reload' }
    end
    tests('have attributes') do
      model_attribute_hash = vnet.attributes
      attributes = [
        :id,
        :name,
        :location,
        :resource_group
      ]
      tests('The virtual_network model should respond to') do
        attributes.each do |attribute|
          test("#{attribute}") { vnet.respond_to? attribute }
        end
      end
      tests('The attributes hash should have key') do
        attributes.each do |attribute|
          test("#{attribute}") { model_attribute_hash.key? attribute }
        end
      end
    end
  end
end
