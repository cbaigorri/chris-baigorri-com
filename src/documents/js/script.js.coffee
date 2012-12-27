###
Author: Chris Baigorri
###
$ ->

  $isotopeContainer = $('#isotopeContainer');

  # Isotope
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
  $('.navbar .nav a').click (e) ->
    if $(this).closest('li').hasClass 'active'
      $('.navbar .nav li').removeClass 'active'
      selector = '*'
    else 
      $('.navbar .nav li').removeClass 'active'
      $(this).closest('li').addClass 'active'
      selector = $(this).attr 'data-filter'
    
    $isotopeContainer.isotope filter: selector
    false

  # Modals
  $('.post a.modal').bind 'click', (e) ->
    e.preventDefault()
    target = $(this).attr 'data-target'
    url = $(this).attr 'href'
    $(target).dialog
      resizable: false
      draggable: false
      width: '90%'
      height: '100%'
      open: (e, ui) ->
        $('body').addClass 'modal-active'
        console.log url
        $('#myModal .modal-body').load url, () ->
          alert 'Load was performed.'
      close: (e, ui) ->
        $('body').removeClass 'modal-active'
