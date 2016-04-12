require File.expand_path('../../../helper', __FILE__)

Shindo.tests('Fog::Network[:azurerm] | subnet model', %w(azurerm network)) do
  subnet = fog_subnet

  tests('The subnet model should') do
    tests('have the action') do
      test('reload') { subnet.respond_to? 'reload' }
    end
    tests('have attributes') do
      model_attribute_hash = subnet.attributes
      attributes = [
        :id,
        :name,
        :resource_group,
        :virtual_network_name,
        :properties
      ]
      tests('The subnet model should respond to') do
        attributes.each do |attribute|
          test("#{attribute}") { subnet.respond_to? attribute }
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
