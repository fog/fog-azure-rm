
Fog.mock!

# if in mocked mode, fill in some fake credentials for us
if Fog.mock?
  Fog.credentials = {
      :tenant_id                     => '<TENANT-ID>',
      :client_id                        => '<CLIENT-ID>',
      :client_secret                        => '<CLIENT-SECRET>',
      :subscription_id                        => '<SUBSCRIPTION-ID>'

  }.merge(Fog.credentials)
end