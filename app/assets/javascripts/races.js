$(function() {
  $('#race_track_id').on('change', function(e) {
    var selected_track = $(e.target[e.target.selectedIndex]).val();
    $('#race_session_ids').empty();
    $.each(sessions[selected_track], function(i, track) {
      $('<option/>').attr('value', track.id).html(track.name).appendTo($('#race_session_ids'));
    });
  });
});
