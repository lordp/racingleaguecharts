$(function() {
  $('.session-collapsible').on('hide.bs.collapse', function () {
    $('#link-' + this.id).removeClass('glyphicon-minus').addClass('glyphicon-plus');
  }).on('show.bs.collapse', function() {
    $('#link-' + this.id).removeClass('glyphicon-plus').addClass('glyphicon-minus');
  });

  $('.help-popover').popover();
  $(".select2").select2();

  $('#rescan').on('click', function() {
    $(this).html('Please wait...');
    window.location += '/rescan';
  });

  $('#race_compare').on('change', compare_change);
  $('#session_compare').on('change', compare_change);
  function compare_change() {
    var compare = $(this).val();
    var url = window.location.href;
    if (url.indexOf('compare') >= 0) {
      url = url.replace(/compare=(\d+)/, 'compare=' + compare);
    }
    else if (url.indexOf('?') >= 0) {
      url = url.replace(/$/, '&compare=' + compare);
    }
    else {
      url = url.replace(/$/, '?compare=' + compare);
    }

    window.location.assign(url);
  }

});
