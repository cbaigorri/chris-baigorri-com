(function() {

  $(function() {
    return $('#masonryContainer').masonry({
      itemSelector: '.box',
      columnWidth: function(containerWidth) {
        return containerWidth / 5;
      },
      isAnimated: !Modernizr.csstransitions,
      isFitWidth: true,
      animationOptions: {
        duration: 750,
        easing: 'linear',
        queue: false
      }
    });
  });

}).call(this);
