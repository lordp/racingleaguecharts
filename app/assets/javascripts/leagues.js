$(document).ready(function() {
  $('.split-target').each(function() {
    var target_type = '';
    if ($(this).hasClass('split-target-driver')) {
      target_type = 'driver';
    }
    else {
      target_type = 'team';
    }

    var index = this.id.replace(target_type + '-split-', '');
    if (index > 1) {
      var target = $('#' + target_type + '-points-' + index.toString());
      var split_value = $(target).parent().prev().find('td:eq('+ $(target).index() +')').html() - $(target).html();
      $(this).html(split_value);
    }
    else {
      $(this).html('--');
    }
  });

  $('#result-modal-new').on('show', function() {
    $('#result_driver_id').val($(this).data('modal').options.driver);
    $('#result_race_id').val($(this).data('modal').options.race);
    $('#result_team_id').val($(this).data('modal').options.team);
  });
});
