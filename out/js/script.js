(function() {

  $(function() {
    var $isotopeContainer;
    $isotopeContainer = $('#isotopeContainer');
    $isotopeContainer.isotope({
      itemSelector: '.box',
      animationEngine: 'best-available',
      masonry: {
        columnWidth: 120
      },
      getSortData: {
        number: function($elem) {
          return parseInt($elem.attr('data-time'), 10);
        }
      },
      sortBy: 'number',
      sortAscending: false
    });
    $('.navbar .nav a').click(function(e) {
      var selector;
      if ($(this).closest('li').hasClass('active')) {
        $('.navbar .nav li').removeClass('active');
        selector = '*';
      } else {
        $('.navbar .nav li').removeClass('active');
        $(this).closest('li').addClass('active');
        selector = $(this).attr('data-filter');
      }
      $isotopeContainer.isotope({
        filter: selector
      });
      return false;
    });
    return $('.post a.modal').bind('click', function(e) {
      var target, url;
      e.preventDefault();
      target = $(this).attr('data-target');
      url = $(this).attr('href');
      return $(target).dialog({
        resizable: false,
        draggable: false,
        width: '90%',
        height: '100%',
        open: function(e, ui) {
          $('body').addClass('modal-active');
          console.log(url);
          return $('#myModal .modal-body').load(url, function() {
            return alert('Load was performed.');
          });
        },
        close: function(e, ui) {
          return $('body').removeClass('modal-active');
        }
      });
    });
  });

}).call(this);
