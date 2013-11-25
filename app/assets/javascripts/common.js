$(function() {
  $('.session-collapsible').on('hide.bs.collapse', function () {
    $('#short-' + this.id).show();
  }).on('show.bs.collapse', function() {
    $('#short-' + this.id).hide();
  });
});
