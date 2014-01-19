$(function() {
  $('#race_track_id').on('change', function(e) {
    var selected_track = $(e.target[e.target.selectedIndex]).val();
    $('#race_session_ids').empty();
    if (sessions.hasOwnProperty(selected_track)) {
      var track_sessions = sessions[selected_track];
    }
    else {
      var track_sessions = [];
      for (var track in sessions) {
        track_sessions = track_sessions.concat(sessions[track])
      }
    }
    $.each(track_sessions, function(i, track) {
      $('<option/>').attr('value', track.id).html(track.name).appendTo($('#race_session_ids'));
    });
  });
});
