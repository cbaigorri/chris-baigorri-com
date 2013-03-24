###
Author: Chris Baigorri
###

# Namespace
App = 
  Classes:
    Views: {}
    Models: {}
    Collections: {}
  Views: {}
  Models: {}
  Collections: {}


# Navbar 
App.Classes.Views.NavBar = Backbone.View.extend
  events:
    'click .nav a': 'filter_Click'

  initialize: () ->
    return

  filter_Click: (e) ->
    $this = $(e.currentTarget)
    $el = $(this.el)
    if $this.closest('li').hasClass 'active'
      $('.nav li', $el).removeClass 'active'
      selector = '*'
    else 
      $('.nav li', $el).removeClass 'active'
      $this.closest('li').addClass 'active'
      selector = $this.attr 'data-filter'
    
    $isotopeContainer.isotope filter: selector
    false


# Posts
App.Classes.Views.Posts = Backbone.View.extend
  currentModal: undefined
  events:
    'click a.modal2': 'post_Click'

  initialize: () ->
    return

  post_Click: (e) ->
    $this = $(e.currentTarget)
    target = $this.attr 'data-target'
    url = $this.attr 'href'
    if @currentModal is not undefined then @currentModal.destroyView()
    @currentModal = new App.Classes.Views.Modal(
      el: $('#postModal')
    )
    @currentModal.url = url
    @currentModal.render()
    console.log 'post_Click' 

    # $(target).dialog
    #   modal: true
    #   resizable: false
    #   draggable: false
    #   width: 'auto'
    #   height: 'auto'
    #   open: (e, ui) ->
    #     $('body').addClass 'modal-active'
    #     $('#myModal .modal-body').load url, () ->
    #       console.log  'Load was performed.'
    #   close: (e, ui) ->
    #     $('body').removeClass 'modal-active'
    false


# Modal
App.Classes.Views.Modal = Backbone.View.extend
  
  initialize: () ->
    @template = _.template $('#template-post-modal').html()
    console.log @url
    _this = @
    $(@el).on 'show', () ->
      $('body').addClass('modal-open')
      return
    $(@el).on 'hide', () ->
      $('body').removeClass('modal-open')
      return
    $(@el).on 'hidden', () ->
      $('.modal-body').empty()
      # _this.destroyView()
      return
    return

  render: () ->
    console.log @url
    $(@el).html @template()
    
    $('#modal-frame').attr('src', @url)
    # $('.modal-body').load @url, () ->
    #   console.log  'Load was performed.'

    $(@el).modal()
    @

  destroyView: () ->
    # unbind the view
    this.undelegateEvents()

    this.$el.removeData().unbind()

    # Remove view from DOM
    this.remove()
    Backbone.View.prototype.remove.call(this)
    return

  close_Click: (e) ->
    false


# Dom Ready
$ ->

  # Isotope
  $isotopeContainer = $('#isotopeContainer');
  $isotopeContainer.isotope
    # options
    itemSelector: '.box'
    animationEngine: 'best-available'
    masonry:
      columnWidth: 120
    getSortData:
      number: ($elem) ->
        return parseInt $elem.attr('data-time') , 10
    sortBy: 'number'
    sortAscending: false
  
  # Navbar
  App.Views.NavBar = new App.Classes.Views.NavBar
    el: $('.navbar')

  # Posts
  App.Views.Posts = new App.Classes.Views.Posts
    el: $('.post')
