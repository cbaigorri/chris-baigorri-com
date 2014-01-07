###
Author: Chris Baigorri
###

# Namespace
App =
  Classes:
    Router: {}
    Views: {}
    Models: {}
    Collections: {}
  Router: {}
  Views: {}
  Models: {}
  Collections: {}


# Router
App.Classes.Router.AppRouter = Backbone.Router.extend
  currentModal: undefined
  routes:
    'about': 'pageRenderer'
    'blog/:slug': 'blogRenderer'

  pageRenderer: () ->
    @renderer '/about'

  blogRenderer: (slug) ->
    @renderer '/blog/' + slug

  renderer: (url) ->
    if @currentModal is not undefined then @currentModal.destroyView()

    @currentModal = new App.Classes.Views.Modal
      el: $('#postModal')
      url: url

# Navbar
App.Classes.Views.NavBar = Backbone.View.extend
  events:
    'click ul li a': 'filter_Click'

  initialize: () ->
    @

  filter_Click: (e) ->
    $this = $(e.currentTarget)
    $el = this.$el
    if $this.closest('li').hasClass 'active'
      $('li', $el).removeClass 'active'
      selector = '*'
    else
      $('li', $el).removeClass 'active'
      $this.closest('li').addClass 'active'
      selector = $this.attr 'data-filter'

    App.Views.Masonry.$el.isotope filter: selector
    false

# Posts
App.Classes.Views.Posts = Backbone.View.extend
  events:
    'click a.modal2': 'post_Click'

  initialize: () ->
    @

  post_Click: (e) ->
    url = $(e.currentTarget).attr 'href'
    App.Router.AppRouter.navigate url, trigger: true
    false

# Modal
App.Classes.Views.Modal = Backbone.View.extend
  resizeInterval: undefined
  lastHeight: undefined

  initialize: (options) ->
    @options = options || {}
    @template = _.template $('#template-post-modal').html()
    _this = @

    @$el.on 'show', () ->
      $('body').addClass('modal-open')
      return

    @$el.on 'hide', () ->
      $('body').removeClass('modal-open')
      return

    @$el.on 'hidden', () ->
      $('.modal-body').empty()
      return

    @render()
    @

  render: () ->
    console.log @options.url, 'render'
    _this = @
    @$el.html @template()

    $('.zoomScroll').show()

    $('#modal-frame').attr 'src', '/ajax' + @options.url
    @updateContentHeight()
    @resizeInterval = setInterval @updateContentHeight, 250
    @

  updateContentHeight: () ->
    $('#modal-frame').height $('#modal-frame').contents().height()

  destroyView: () ->
    clearInterval @resizeInterval

    # unbind the view
    this.undelegateEvents()

    this.$el.removeData().unbind()

    # Remove view from DOM
    this.remove()
    Backbone.View.prototype.remove.call(this)
    return

  close_Click: (e) ->
    false

# Masonry
App.Classes.Views.Masonry = Backbone.View.extend
  initialize: ()->
    @.$el.isotope
      # options
      layoutMode: 'masonry'
      itemSelector: '.box'
      stamp: '.stamp'
      masonry:
        columnWidth: @.$el.find('.grid-sizer')[0]
        gutter: 10
      getSortData:
        number: ($elem) ->
          return parseInt $($elem).attr('data-time') , 10
      sortBy: 'number'
      sortAscending: false

    @.$el.isotope 'on', 'layoutComplete', () ->
      return true

    return


# Dom Ready
$ ->

  # Navbar
  App.Views.NavBar = new App.Classes.Views.NavBar
    el: $('.nav-filters')

  # Posts
  App.Views.Posts = new App.Classes.Views.Posts
    el: $('.post')

  # Router
  App.Router.AppRouter = new App.Classes.Router.AppRouter()
  Backbone.history.start
    pushState: true

# Doc Ready
window.onload = ()->
  # Isotope
  App.Views.Masonry = new App.Classes.Views.Masonry
    el: $('#isotopeContainer')

