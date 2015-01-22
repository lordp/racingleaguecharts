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

  $('a.toggle').click(function (e) {
    e.preventDefault();
    $(this).next().toggle();
  });

  $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
    var href = $(e.target).attr('href');
    var container = $(href + '-child');
    if (container.length == 0) {
      container = $(href);
    }
    if (container.highcharts()) {
      container.highcharts().reflow();
    }
    if (params) {
      params.tab = href.replace('#container-', '');
      update_show_hide_links();
    }
  });

  $('.brand').on('click', function() {
    window.location.assign('/');
  });

  $('.session-filter').on('change', function(e) {
    var filter = $(e.target).data('filter');
    var target = e.target.id.replace('_', '-').toLowerCase();
    if (e.target.checked) {
      $('tr[data-' + filter + '=' + target +']').show();
    }
    else {
      $('tr[data-' + filter + '=' + target +']').hide();
    }

    $('input[data-parent=' + e.target.name + ']').attr('disabled', !e.target.checked);
  });

  $('.tt-results').on('mouseover', function() {
    $(this).children().show();
  }).on('mouseout', function() {
    $(this).children().hide();
  });

  $('#select_all, #select_none').on('click', function() {
    $('.session-filter').children().prop('checked', $(this).attr('id') == 'select_all');
    return false;
  });
});
