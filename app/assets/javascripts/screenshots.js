$(function() {
  function convert_lap(lap) {
    var time = lap.match(/((\d):)?([\d\.]+)/);
    if (typeof time[1] != 'undefined') {
      return parseInt(time[2] * 60) + parseFloat(time[3]);
    }
    else {
      return parseFloat(time[3]);
    }
  }

  function check_lap_times(lap, s1, s2, s3) {
    if (convert_lap(lap).toFixed(3) == (convert_lap(s1) + convert_lap(s2) + convert_lap(s3)).toFixed(3)) {
      return true;
    }

    return false;
  }

  CodeMirror.defineMode("vrl", function() {
    return {
      token: function(stream, state) {
        var re = /^([\d]{2}) (([\d]+:)?[\d]{2}\.[\d]{3}) (([\d]+:)?[\d]{2}\.[\d]{3}) (([\d]+:)?[\d]{2}\.[\d]{3}) (([\d]+:)?[\d]{2}\.[\d]{3})/;
        if (stream.match(re)) {
          var values = stream.string.match(re);
          return check_lap_times(values[2], values[4], values[6], values[8]) ? 'vrl-st-correct-calc-correct' : 'vrl-st-correct-calc-wrong';
        }
        else {
          stream.skipToEnd();
          return null;
        }
      }
    };
  });

  var myTextArea = document.getElementById('screenshot_parsed');
  var myCodeMirror = CodeMirror.fromTextArea(myTextArea, { mode: "vrl" });
  myCodeMirror.on("blur", function() {
    myCodeMirror.save();
  });
});
