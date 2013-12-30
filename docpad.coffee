# Requires
moment = require('moment')

# The DocPad Configuration File
# It is simply a CoffeeScript Object which is parsed by CSON
docpadConfig = 

  # Template Data
  # =============
  # These are variables that will be accessible via our templates
  # To access one of these within our templates, refer to the FAQ: https://github.com/bevry/docpad/wiki/FAQ

  # Define Configuration
  templateData:

    # Specify some site properties
    site:
      # The production url of our website
      url: "http://chrisbaigorri.com"

      # Here are some old site urls that you would like to redirect from
      oldUrls: [
        'www.chrisbaigorri.com'
      ]

      # The default title of our website
      title: "Chris Baigorri"

      # The website description (for SEO)
      description: """
        Chris Baigorri is a front end devloper living in Toronto, Canada
        """

      # The website keywords (for SEO) separated by commas
      keywords: """
        interface, developer, front-end, html5, css3, javascript, node, website
        """

      # The website author's name
      author: "Chris Baigorri"

      # The website author's email
      email: "root@chrisbaigorri.com"

      # Your company's name
      copyright: "Row House Reno. All rights reserved."


    # Helper Functions
    # ----------------

    # Format the passed date, by default format like: Thursday, November 29 2012 3:53 PM
    formatDate: (date, format='LLLL') -> 
      moment(date).format(format)

    # Format the passed date, by default format like: Thursday, November 29 2012 3:53 PM
    formatDateShort: (date, format='M-D-YYYY') -> 
      moment(date).format(format)

    # Get the prepared site/document title
    # Often we would like to specify particular formatting to our page's title
    # we can apply that formatting here
    getPreparedTitle: ->
      # if we have a document title, then we should use that and suffix the site's title onto it
      if @document.title
        "#{@document.title} | #{@site.title}"
      # if our document does not have it's own title, then we should just use the site's title
      else
        @site.title

    # Get the prepared site/document description
    getPreparedDescription: ->
      # if we have a document description, then we should use that, otherwise use the site's description
      @document.description or @site.description

    # Get the prepared site/document keywords
    getPreparedKeywords: ->
      # Merge the document keywords with the site keywords
      @site.keywords.concat(@document.keywords or []).join(', ')

    # Get the prepared classname
    getPreparedClass: ->
      if @document.title
        className = @document.title.toLowerCase()
        className = className.replace /[!\"#$%&'\(\)\*\+,\.\/:;<=>\?\@\[\\\]\^`\{\|\}~]/g, ''
        className = className.replace /\s/g, '-'

    # Linkify
    linkify: (s) ->
      s.replace /[A-Za-z]+:\/\/[A-Za-z0-9-_]+\.[A-Za-z0-9-_:%&\?\/.=]+/, (m) ->
        m.link m

    # Atify
    atify : (s) ->
      s.replace /@[\w]+/g, (m) ->
        "<a href='http://www.twitter.com/#{m.replace '@', ''}' target='_blank'>#{m}</a>"

    # Relative time
    relativeTime: (time_value) ->
      parsed_date = Date.parse(time_value)
      relative_to = if arguments.length > 1 then arguments[1] else new Date()
      delta = parseInt((relative_to.getTime() - parsed_date) / 1000)
      if delta < 60
        return "less than a minute ago"
      else if delta < 120
        return "about a minute ago"
      else if delta < 2700
        return (parseInt(delta / 60)).toString() + " minutes ago"
      else if delta < 5400
        return "about an hour ago"
      else if delta < 86400
        return "about " + (parseInt(delta / 3600)).toString() + " hours ago"
      else if delta < 172800
        return "one day ago"
      else
        return (parseInt(delta / 86400)).toString() + " days ago"

    # Machine time
    machineTime: (time_value) ->
      parsed_date = Date.parse(time_value)
      return parsed_date



  # Collections
  # ===========
  # These are special collections that our website makes available to us

  collections:
    # For instance, this one will fetch in all documents that have pageOrder set within their meta data
    pages: (database) ->
      database.findAllLive({pageOrder: $exists: true}, [pageOrder:1,title:1])

    # This one, will fetch in all documents that will be outputted to the posts directory
    posts: (database) ->
      database.findAllLive({relativeOutDirPath:'posts'},[date:-1])


  # DocPad Events
  # =============

  # Here we can define handlers for events that DocPad fires
  # You can find a full listing of events on the DocPad Wiki
  events:

    # Server Extend
    # Used to add our own custom routes to the server before the docpad routes are added
    serverExtend: (opts) ->
      # Extract the server from the options
      {server} = opts
      docpad = @docpad

      # As we are now running in an event,
      # ensure we are using the latest copy of the docpad configuraiton
      # and fetch our urls from it
      latestConfig = docpad.getConfig()
      oldUrls = latestConfig.templateData.site.oldUrls or []
      newUrl = latestConfig.templateData.site.url

      # Redirect any requests accessing one of our sites oldUrls to the new site url
      server.use (req,res,next) ->
        if req.headers.host in oldUrls
          res.redirect 301, newUrl+req.url
        else
          next()

    # Write After
    # Used to minify our assets with grunt
    writeAfter: (opts,next) ->
      # Prepare
      safeps = require('safeps')
      pathUtil = require('path')
      docpad = @docpad
      rootPath = docpad.getConfig().rootPath

      # Perform the grunt `min` task
      # https://github.com/gruntjs/grunt/blob/0.3-stable/docs/task_min.md
      command = ["#{rootPath}/node_modules/.bin/grunt", 'default']

      # Execute
      safeps.spawn(command, {save:false,output:true}, next)

      # Chain
      @


# Export our DocPad Configuration
module.exports = docpadConfig
