# Integration Tests

To run Integration Tests, first enter following information from your Azure subscription in **credentials\azure.yml** file:

- tenant_id
- client_id
- client_secret
- subscription_id

Then run **ruby file_name.rb** to run integration test for a specific service e.g. For integration tests of storage account, run:

**ruby storage_account.rb**

Also make sure the **DEBUG** flag is set in your fog environment to see proper logging.
