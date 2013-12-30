# -----------------------------
# LinkedIn Functions

linkedin = require 'linkedin-js'

#
getMyWorkHistory = (callback) ->
  li = new linkedin '75f2f8091kx322', 'JXlKtLExWl1Jiyj9', 'http://localhost:9779'
  li.getAccessToken
