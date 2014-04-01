$(function() {
  $('.session-collapsible').on('hide.bs.collapse', function () {
    $('#link-' + this.id).removeClass('glyphicon-minus').addClass('glyphicon-plus');
  }).on('show.bs.collapse', function() {
    $('#link-' + this.id).removeClass('glyphicon-plus').addClass('glyphicon-minus');
  });

  $('.help-popover').popover();
  $(".select2").select2();

});
