###
Author: Chris Baigorri - @cbaigorri
###

$ = jQuery

# class definition

Modal = (element, options) ->
  @$element = $(element)
  @options = $.extend {}, $.fn.modal.defaults, options
  return

Modal::show = () ->

Modal::hode = () ->
  
Modal::shown = () ->
  
Modal::hidden = () ->
  