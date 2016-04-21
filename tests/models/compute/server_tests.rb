require File.expand_path('../../../helper', __FILE__)

Shindo.tests('Fog::Compute[:azurerm] | server model', %w(azurerm compute)) do
  server = fog_server

  tests('The server model should') do
    tests('have the action') do
      test('reload') { server.respond_to? 'reload' }
    end
    tests('have attributes') do
      model_attribute_hash = server.attributes
      attributes = [
        :id,
        :name,
        :location,
        :resource_group,
        :vm_size,
        :os_disk_name,
        :vhd_uri,
        :publisher,
        :offer,
        :sku,
        :version,
        :username,
        :disable_password_authentication,
        :network_interface_card_id
      ]
      tests('The server model should respond to') do
        attributes.each do |attribute|
          test(attribute) { server.respond_to? attribute }
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
