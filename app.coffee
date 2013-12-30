express = require 'express'
http = require 'http'
twittercb = require __dirname + '/lib/twittercb'
linkedin = require 'linkedin-js'
cronjobs = require __dirname + '/lib/cronjobs'
fs = require 'fs'

app = express()
server = http.createServer(app).listen 9779
io = require('socket.io').listen server
li = new linkedin '75f2f8091kx322', 'JXlKtLExWl1Jiyj9', 'http://localhost:9779'


app.use express.bodyParser()
app.use express.methodOverride()
app.use express.cookieParser '237goats'
app.use express.session()
app.use app.router

# Errors
###
app.use (req, res, next) ->
  res.status 404

  # respond with html page
  if req.accepts 'html'
    res.render '404', url: req.url
    return

  # respond with json
  if req.accepts 'json'
    res.send error: 'Not found'
    return

  # default to plain-text. send()
  res.type('txt').send('Not found')
###

###
 error-handling middleware, take the same form
 as regular middleware, however they require an
 arity of 4, aka the signature (err, req, res, next).
 when connect has an error, it will invoke ONLY error-handling
 middleware.

 If we were to next() here any remaining non-error-handling
 middleware would then be executed, or if we next(err) to
 continue passing the error, only error-handling middleware
 would remain being executed, however here
 we simply respond with an error page.


app.use (err, req, res, next) ->
  # we may use properties of the error object
  # here and next(err) appropriately, or if
  # we possibly recovered from the error, simply next().
  res.status err.status || 500
  res.render '500', error: err
###


# all environments
app.configure ()->
  app.set 'title', 'My Application CB'
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.set 'view options', layout: true

  app.use express.static(__dirname + '/out')

# development only
app.configure 'development', () ->
  console.log 'development configuration'
  #app.set 'db uri', 'localhost/dev'

# production only
app.configure 'production', () ->
  console.log 'production configuration'
  #app.set 'db uri', 'n.n.n.n/prod'

# docpad configuration
docpadInstanceConfiguration =
  serverExpress: app
  serverHttp: server
  middlewareStandard: false

docpadInstance = require('docpad').createInstance docpadInstanceConfiguration, (err) ->
  if err then return console.log err.stack
  docpad.action 'generate server watch', (err) ->
    if err then console.log err.stack
  @

# -----------------------------
# Router Functions

# Homepage
app.get '/', (req, res, next) ->
  jsonContents = fs.readFileSync 'out/tweets.json', 'utf8'
  tweets = JSON.parse jsonContents
  req.templateData =
    customVar : 'some custom variable'
    tweetData : tweets
  document = docpadInstance.getFile relativePath:'index.html.eco'
  docpadInstance.serveDocument {document, req, res, next}

# About
app.get '/ajax/about', (req, res, next) ->
  req.templateData =
    customVar: 'some custom variable'
  document = docpadInstance.getFile relativePath:'pages/about.html.md'
  docpadInstance.serveDocument {document, req, res, next}

# Posts
app.get '/ajax/blog/:id', (req, res, next) ->
  doc = req.params.id
  document = docpadInstance.getFile relativePath:'posts/' + doc + '.html.eco'
  docpadInstance.serveDocument {document, req, res, next}

# LinkedIn Auth
app.get '/liauth', (req, res, next) ->
  li.getAccessToken req, res, (e, token) ->
    req.session = token
    res.render 'liauth'
    return
  return

# Linked In get data
app.get '/lidata', (req, res, next) ->
  li.apiCall 'GET', '/people/~',
    token:
      oauth_token_secret: req.session.token.oauth_token_secret
      oauth_token: req.session.token.oauth_token
  , (error, result) ->
    console.log result
    return
  return

# Twitter data - need to run this once if you have a new setup
app.get '/twitterdata', (req, res, next) ->
  twittercb.getTweets (err, data) ->
    if err then return console.log err
    fs.writeFile 'out/tweets.json', JSON.stringify(data, null, 4), (err) ->
      if err then console.log err
      console.log 'JSON saved.'
  res.redirect '/'
  return



String.prototype.linkify = () ->
  @replace /[A-Za-z]+:\/\/[A-Za-z0-9-_]+\.[A-Za-z0-9-_:%&\?\/.=]+/, (m) ->
    m.link m

String.prototype.atify = () ->
  @replace /@[\w]+/g, (m) ->
    "<a href='http://www.twitter.com/#{m.replace '@', ''}'>#{m}</a>"


# -----------------------------
# Debug Functions
li_test = () ->
  li.apiCall 'GET', '/people/~',
    token:
      oauth_token_secret: req.session.token.oauth_token_secret
      oauth_token: req.session.token.oauth_token
  , (error, result) ->
    console.log result
    return

