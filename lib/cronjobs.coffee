# -----------------------------
# Cron Jobs

# TODO: move json to json folder

cron = require __dirname + '/vendor/cron'
twittercb = require '../lib/twittercb'
fs = require 'fs'

# Set up a cron job to get my tweets every hour
# seconds - minutes - hour - day of month - month - day of week
new cron.CronJob '* * 0 * * *', () ->
  twittercb.getTweets (err, data) ->
    if err then return console.log err
    fs.writeFile 'out/tweets.json', JSON.stringify(data, null, 4), (err) ->
      if err then console.log err
      console.log 'JSON saved.'
