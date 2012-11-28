###
Author: Chris Baigorri
###
$ ->

  
  
  $('#masonryContainer').masonry
    itemSelector: '.box'
    columnWidth: (containerWidth) ->
      containerWidth / 5
    isAnimated: !Modernizr.csstransitions
    isFitWidth: true
    animationOptions:
      duration: 750
      easing: 'linear'
      queue: false