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

  $('.race-compare').on('click', function() {
    params = {
      tracks: $('#track').val() || []
    };

    if (params.tracks.length > 0) {
      $.get('/races/search.json?' + $.param(params), function (data) {
        $('#race_list tbody').empty().append($.map(data, function(item) {
          return "<tr><td><a href=\"?compare=" + item.id + "\">" + item.winner + "</td><td>" + item.track + "</td><td>" + item.laps + "</td><td>" + item.created_at + "</td></tr>";
        }).join(''));
      });
    }
  });


  /*
  var client = new Faye.Client(location.protocol + '//' + location.hostname + ':3001/faye');
  client.subscribe('/livetiming', update_livetiming);

  function update_livetiming(message) {
    console.log(message);
    if (message.hasOwnProperty('driver')) {
      if ($('.livetiming tbody tr#' + message.driver).length == 0) {
        var driver_row = $('<tr/>').attr('id', message.driver).appendTo($('.livetiming tbody'));
        $('<td/>').attr('id', message.driver + '-position').appendTo(driver_row);
        $('<td/>').attr('id', message.driver + '-name').text(message.driver).appendTo(driver_row);
        $('<td/>').attr('id', message.driver + '-lap').appendTo(driver_row);
        $('<td/>').attr('id', message.driver + '-sector-1').appendTo(driver_row);
        $('<td/>').attr('id', message.driver + '-sector-2').appendTo(driver_row);
        $('<td/>').attr('id', message.driver + '-sector-3').appendTo(driver_row);
        $('<td/>').attr('id', message.driver + '-total').appendTo(driver_row);
      }

      if (message.hasOwnProperty('sector1')) {
        $('#' + message.driver + '-sector-1').text(message.sector1);
        $('#' + message.driver + '-lap').text(message.lap);
        $('#' + message.driver + '-position').text(message.position);
        $('#' + message.driver + '-sector-2').empty();
        $('#' + message.driver + '-sector-3').empty();
        $('#' + message.driver + '-total').empty();
      }
      if (message.hasOwnProperty('sector2')) {
        $('#' + message.driver + '-sector-2').text(message.sector2);
        $('#' + message.driver + '-position').text(message.position);
      }
      if (message.hasOwnProperty('total')) {
        var sector1 = parseFloat($('#' + message.driver + '-sector-1').text());
        var sector2 = parseFloat($('#' + message.driver + '-sector-2').text());
        var sector3 = message.total - sector1 - sector2;
        $('#' + message.driver + '-sector-3').text(sector3);
        $('#' + message.driver + '-position').text(message.position);
        $('#' + message.driver + '-total').text(message.total);
      }
    }
  }
  */
});
