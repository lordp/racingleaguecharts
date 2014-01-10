$(function() {
  $('#race_session_list').on('dblclick', function(e) {
    console.log(e.target);
    $('#session_ids').append($(e.target));
  });

  $('#session_ids').on('dblclick', function(e) {
    $('#race_session_list').append($(e.target));
  });
});
