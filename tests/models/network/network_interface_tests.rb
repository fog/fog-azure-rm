require File.expand_path('../../../helper', __FILE__)

Shindo.tests('Fog::Network[:azurerm] | network_interface model', %w(azurerm network)) do
  nic = fog_network_interface

  tests('The network_interface model should') do
    tests('have attributes') do
      model_attribute_hash = nic.attributes
      attributes = [
        :name,
        :location,
        :properties
      ]
      tests('The network_interface model should respond to') do
        attributes.each do |attribute|
          test(attribute) { nic.respond_to? attribute }
        end
      end
      tests('The attributes hash should have key') do
        attributes.each do |attribute|
          test(attribute) { model_attribute_hash.key? attribute }
        end
      end
    end
  end
end
