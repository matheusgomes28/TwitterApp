require 'sinatra'
require 'twitter'
require 'thin'

config = {
    :consumer_key => '0PjuwaszRC2e90eJJHXpPEcPD',
    :consumer_secret => 'mQu0dEFa5TdQw4sjsSbBUCauJfg09EX6niJDP9BlVi7VYr2wGT',
    :access_token => '266130775-hHLandrpZdjMiCUPY7792InYD4jThic8EScsf1GR',
    :access_token_secret => 'dCwl3V9CUbn1VPvBhSia00o4vsObnIqPjYbksKRlROS6M'
}

client = Twitter::REST::Client.new(config)
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE


# Core code ended

get '/' do

  if !(params['search'] == nil)
    search_items = client.search(params['search'].chomp).take(10)

    tweets = Array.new(10) {Array.new(2, nil)}

    counter = 0
    search_items.each do |item|
      tweets[counter][0] = item.text
      tweets[counter][1] = item.id

      counter += 1
    end

    @data = tweets
    erb :index

  else

    erb :search

   end

end