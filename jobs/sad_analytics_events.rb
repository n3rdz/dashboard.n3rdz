require 'google/api_client'
require 'date'

# Update these to match your own apps credentials
service_account_email = 'dashing-analytics@dashing-analytics-1290.iam.gserviceaccount.com' # Email of service account
key_file = 'dashing-analytics-5c1250e911fb.p12' # File containing your private key
key_secret = 'notasecret' # Password to unlock private key
profileID = '114596524' # Analytics profile ID.

# Get the Google API client
sad_events_client = Google::APIClient.new(:application_name => 'dashing-analytics', 
  :application_version => '0.01')

# Load your credentials for the service account
key = Google::APIClient::KeyUtils.load_from_pkcs12(key_file, key_secret)
sad_events_client.authorization = Signet::OAuth2::Client.new(
  :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
  :audience => 'https://accounts.google.com/o/oauth2/token',
  :scope => 'https://www.googleapis.com/auth/analytics.readonly',
  :issuer => service_account_email,
  :signing_key => key)

# Start the scheduler
SCHEDULER.every '1m', :first_in => 0 do

  # Request a token for our service account
  sad_events_client.authorization.fetch_access_token!

  # Get the analytics API
  analytics = sad_events_client.discovered_api('analytics','v3')

  # Start and end dates
  startDate = DateTime.now.strftime("%Y-%m-01") # first day of current month
  endDate = DateTime.now.strftime("%Y-%m-%d")  # now

  # Execute the query
  visitCount = sad_events_client.execute(:api_method => analytics.data.ga.get, :parameters => { 
    'ids' => "ga:" + profileID, 
    'start-date' => startDate,
    'end-date' => endDate,
    # 'dimensions' => "ga:month",
    'metrics' => "ga:visitors",
    # 'sort' => "ga:month"
  })

  # Update the dashboard
  # Note the trailing to_i - See: https://github.com/Shopify/dashing/issues/33
  send_event('sad_analytics_events',   { current: visitCount.data.rows[0][0].to_i })
end