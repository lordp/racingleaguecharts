$(function() {
  function fetch_sessions() {
    params = {
      drivers: $('#driver').val() || [],
      tracks: $('#track').val() || [],
      session_type: $.map($('input.session-compare:checked'), function(item) { return item.id } ) || []
    };

    if (params.drivers.length > 0 || params.tracks.length > 0 || params.session_type.length > 0) {
      $.get('/sessions/search.json?' + $.param(params), function (data) {
        $('#session_list tbody').empty().append($.map(data, function(item) {
          return "<tr><td><a href=\"/sessions/" + item.id + "\">" + item.driver + "</a></td><td>" + item.track + "</td><td>" + item.session_type + "</td><td>" + item.race + "</td><td>" + item.laps + "</td><td>" + item.created_at + "</td></tr>";
        }).join(''));
      });
    }
  }

  $('.session-compare').on('click', fetch_sessions).on('change', fetch_sessions);
});
