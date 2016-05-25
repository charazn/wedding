$ ->
  $('.photos').imagesLoaded ->
    $('.photos').masonry
      itemSelector: '.box'
      isFitWidth: true
