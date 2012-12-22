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

  twit.getUserTimeline '', (err, data)->
    if err then console.log err
    callback data

exports.getTweets = getMyTweets
