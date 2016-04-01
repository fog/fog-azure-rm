require File.expand_path('../../../helper', __FILE__)

Shindo.tests('Fog::Storage[:azurerm] | storage_account model', %w(azurerm storage)) do
  storage_account = fog_storage_account

  tests('The storage account model should') do
    tests('have the action') do
      test('reload') { storage_account.respond_to? 'reload' }
    end
    tests('have attributes') do
      model_attribute_hash = storage_account.attributes
      attributes = [
          :id,
          :name,
          :location,
          :resource_group_name
      ]
      tests('The storage account model should respond to') do
        attributes.each do |attribute|
          test("#{attribute}") { storage_account.respond_to? attribute }
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
