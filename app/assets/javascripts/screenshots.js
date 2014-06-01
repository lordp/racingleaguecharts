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
        var re = /([\d]+) ([\d:\.]+) ([\d:\.]+) ([\d:\.]+) ([\d:\.]+)( ([\d\.]+) ([\d\.]+))?$/;
        var tmp = stream.string;
        if (tmp.match(re)) {
          var values = stream.string.match(re);
          stream.skipToEnd();
          return check_lap_times(values[2], values[3], values[4], values[5]) ? 'vrl-st-correct-calc-correct' : 'vrl-st-correct-calc-wrong';
        }
        else {
          stream.skipToEnd();
          return null;
        }
      }
    };
  });

  var myTextArea = document.getElementById('screenshot_parsed') || document.getElementById('session_lap_text');
  if (myTextArea != null) {
    var myCodeMirror = CodeMirror.fromTextArea(myTextArea, { mode: "vrl" });
    //myCodeMirror.setSize(300, 300);
    myCodeMirror.on("blur", function() {
      myCodeMirror.save();
    });
  }

  $('#session_driver_id').on('change', function() {
    $('#session_screenshot_ids').val(null);
  });

  $('#session_image').fileupload({
    dataType: 'script',
    url: '/say_what/screenshots',
    type: 'POST',
    add: function(e, data) {
      var file, types;
      types = /(\.|\/)(gif|jpe?g|pdf|png|mov|mpeg|mpeg4|avi)$/i;
      file = data.files[0];
      if (types.test(file.type) || types.test(file.name)) {
        data.context = $(tmpl("template-upload", file));
        $('#screenshot_upload').append(data.context);
        return data.submit();
      } else {
        return alert("" + file.name + " is not a gif, jpg or png image file");
      }
    },
    submit: function(e, data) {
      // HACK: Replace the method on the form so saving the screenshot works
      $.each(data.form[0], function(index, input) {
        if (input.name == '_method') {
          data.form[0][index].value = null;
        }
      });
      return true;
    },
    done: function(e, data) {
      // Revert the above HACK
      $.each(data.form[0], function(index, input) {
        if (input.name == '_method') {
          data.form[0][index].value = 'put';
        }
      });
    },
    progress: function(e, data) {
      var progress;
      if (data.context) {
        progress = parseInt(data.loaded / data.total * 100, 10);
        return data.context.find('.bar').css('width', progress + '%');
      }
    }
  });

});
