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


# Modals
App.Classes.Views.Posts = Backbone.View.extend
  events:
    'click a.modal': 'post_Click'

  initialize: () ->
    return

  post_Click: (e) ->
    $this = $(e.currentTarget)
    target = $this.attr 'data-target'
    url = $this.attr 'href'
    $(target).dialog
      resizable: false
      draggable: false
      width: '90%'
      height: '100%'
      open: (e, ui) ->
        $('body').addClass 'modal-active'
        console.log url
        $('#myModal .modal-body').load url, () ->
          console.log  'Load was performed.'
      close: (e, ui) ->
        $('body').removeClass 'modal-active'
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
