require File.expand_path('../../../helper', __FILE__)

Shindo.tests('Fog::Storage[:azurerm] | storage_accounts request', %w(azurerm storage)) do
  tests('#storage_accounts') do
    storage_accounts = azurerm_storage_service.storage_accounts
    storage_accounts = [fog_storage_account] if storage_accounts.empty?

    test 'returns a Array' do
      storage_accounts.is_a? Array
    end

    test('should return valid storage account name') do
      storage_accounts.first.name.is_a? String
    end

    test('should return records') do
      storage_accounts.size >= 1
    end
  end
end
