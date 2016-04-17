require 'twitter'


#### Get your twitter keys & secrets:
#### https://dev.twitter.com/docs/auth/tokens-devtwittercom
twitter = Twitter::REST::Client.new do |config|
  config.consumer_key = 'OY9bDHU1zNiH1BujNRKzPgSx3'
  config.consumer_secret =  'ztE0XxSJxIuzRPMnWlpNPWOnZXVU9lmUpVTmLwBa2vjv64oEJx'
  config.access_token = '22966522-K8jgoWOJXY1LN4BEmFyUif8bze92L53cRmxGEdZCK'
  config.access_token_secret = '0VDHqNi1w9TYdg2krRnhdwOl5kvDlo5HXTDvnofDjV2vL'
end

search_term = URI::encode('#jungesangebotvonardundzdf')

SCHEDULER.every '1m', :first_in => 0 do |job|
  begin
    tweets = twitter.search("#{search_term}")

    if tweets
      tweets = tweets.map do |tweet|
        { name: tweet.user.name, body: tweet.text, avatar: tweet.user.profile_image_url_https }
      end
      send_event('twitter_mentions', comments: tweets)
    end
  rescue Twitter::Error
    puts "\e[33mFor the twitter widget to work, you need to put in your twitter API keys in the jobs/twitter.rb file.\e[0m"
  end
end