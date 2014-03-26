$(function() {
  $('.session-collapsible').on('hide.bs.collapse', function () {
    $('#short-' + this.id).show();
    $('#link-' + this.id).removeClass('glyphicon-minus').addClass('glyphicon-plus');
  }).on('show.bs.collapse', function() {
    $('#short-' + this.id).hide();
    $('#link-' + this.id).removeClass('glyphicon-plus').addClass('glyphicon-minus');
  });

  $('.help-popover').popover();
  $(".select2").select2();

});
