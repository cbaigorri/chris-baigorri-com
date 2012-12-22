express = require 'express'
http = require 'http'
twittercb = require __dirname + '/lib/twittercb'
cronjobs = require __dirname + '/lib/cronjobs'

app = express()
server = http.createServer(app).listen 9779

app.use express.bodyParser()
app.use express.methodOverride()
app.use app.router

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
# TODO: add tweets.json to template data
app.get '/', (req, res, next) ->
  req.templateData =
    customVar = 'some custom variable'
  document = docpadInstance.getFile relativePath:'index.html.eco'
  docpadInstance.serveDocument {document, req, res, next}



