# -----------------------------
# Twitter Functions

twitter = require 'ntwitter'

#
getMyTweets = (callback) ->
  twit = new twitter
    consumer_key: 'ddIhXIe6D70EsqYyVLUBAQ'
    consumer_secret: 'HaNqmTtP7AdXv2XQqmxfXBu6qm0g2o2vWMqIAzPPKk'
    access_token_key: '14239125-hMrrsDPRPV8GwxvuVtzkcfKVsYurwEEkCQqNoKpAE'
    access_token_secret: 'nyLflflOUjXTShWPfwyOMQgifUhAokeaFP8ND47nXvw'

  twit.getUserTimeline 
    exclude_replies: true
    include_rts: false
    count: 20
    , (err, data)->
      if err then callback err, null
      callback null, data

exports.getTweets = getMyTweets
