// Helper method to return a total time for an array or array slice
function array_sum(array) {
  return array.reduce(function (a, b) {
    return a + b
  })
}

// Helper method for converting a lap time to seconds
function convert_lap(lap) {
  var time = lap.match(/(\d):([\d\.]+)/);
  return parseInt(time[1] * 60) + parseFloat(time[2]);
}

// The tooltip formatter for the first graph (laps)
function graph_one_formatter() {
  var s = '<b>Lap ' + this.x + '</b>';

  $.each(this.points, function (i, point) {
    // Converts seconds to mm:ss.ddd format - ie 106.322 = 1:46.322
    var t1 = Math.floor(point.y / 60);
    var t2 = (point.y % 60).toFixed(3);
    s += '<br/><span style="color: ' + point.series.color + ';">' + point.series.name + '</span>: ' + t1 + 'm' + (t2 < 10 ? '0' + t2 : t2);
  });

  return s;
}

// The tooltip formatter for the second graph (gaps)
function graph_two_formatter() {
  var s = '<b>Lap ' + this.x + '</b>';

  $.each(this.points, function (i, point) {
    s += '<br/><span style="color: ' + point.series.color + ';">' + point.series.name + '</span>: ' + Math.abs(point.y).toFixed(3);
  });

  return s;
}

function graph_four_formatter() {
  return this.y.toFixed(3);
}

// Helper function to get information from the URL
function getQueryString() {
  var ret = {};
  var parts = (document.location.toString().split('?')[1]).split('&');
  for (var i = 0; i < parts.length; i++) {

    var p = parts[i].split('=');
    // so strings will be correctly parsed:
    p[1] = decodeURIComponent(p[1].replace(/\+/g, " "));

    if (p[0].search(/\[\]/) >= 0) { // then it's an array
      p[0] = p[0].replace('[]','');

      if (typeof ret[p[0]] != 'object') ret[p[0]] = [];
      ret[p[0]].push(p[1]);
    } else {
      ret[p[0]] = p[1];
    }
  }
  return ret;
}

// Helper function to determine which drivers to show or hide.
function hide_driver(params, driver) {
  if ((params.hide && $.inArray(driver, params.hide.split(',')) >= 0) ||
      (params.show && $.inArray(driver, params.show.split(',')) == -1)) {
      return true;
  }
}

function sort_sector(a, b) {
  return a[1] > b[1];
}

// Base options
var options = {
  chart: {
    type: 'spline'
  },
  title: {
    text: ""
  },
  plotOptions: {
    series: {
      animation: false
    },
    spline: {
      pointStart: 1
    }
  },
  xAxis: {
    title: {
      text: 'Lap'
    }
  },
  yAxis: {
    title: {
      text: ''
    }
  },
  tooltip: {
    shared: true
  },
  series: []
};

// When the browser/page has been loaded...
$(function () {
  // Figure out what race/league the user wants from the URL
  params = getQueryString();
  filename = params.league + "-" + params.race + ".json";

  // Work out what tab the user wants from the URL
  if (params.tab) {
    $('li.active').removeClass('active').siblings().children('a#tab-' + params.tab).parent().addClass('active');

    $('.tab-pane').removeClass('active');
    $('#container-' + params.tab).addClass('active');
  }

  // Pull in the data from a JSON object via AJAX
  $.getJSON(filename).done(function (result) {
    data = result.laps;
    options.title.text = result.title;

    // Convert each lap into seconds so the highcharts can understand it
    $.each(data, function (i, driver) {
      driver.data = [];
      $.each(driver.laps, function (i, lap) {
        driver.data[i] = convert_lap(lap);
      });

      // Hide or show drivers if applicable.
      if (hide_driver(params, driver.name)) {
        driver.visible = false;
      }

      options.series.push(driver);
    });

    // Set basic options and instruct highcharts to render the chart
    options.title.text = result.title + " - Laps";
    options.tooltip.formatter = graph_one_formatter;
    $('#container-laps').highcharts(options);

    // Clear out the series for the second chart
    options.series = [];

    // Determine the average time for the winner (first array value)
    var winner_laps = [];
    $.each(data[0].laps, function (i, lap) {
      winner_laps.push(convert_lap(lap));
    });
    var winner_average = array_sum(winner_laps) / winner_laps.length;

    // Figure out the gaps between each driver and the winning time
    $.each(data, function (i, driver) {
      driver.data = [];
      driver.average = [];
      $.each(driver.laps, function (i, lap) {
        // First lap is handled separately
        if (i == 0) {
          driver.average.push(convert_lap(lap));
        }
        // Other laps are added together as you go
        else {
          laps_slice = [];
          $.each(driver.laps.slice(0, i + 1), function (i, lap) {
            laps_slice.push(convert_lap(lap));
          });
          driver.average.push(array_sum(laps_slice));
        }

        // Keep a track of the difference
        driver.data.push(((winner_average * (i + 1)) - driver.average[i]));
      });

      // Hide or show drivers if applicable.
      if (hide_driver(params, driver.name)) {
        driver.visible = false;
      }

      options.series.push(driver);
    });

    // Change the tooltip formatter, chart title and y-axis title options
    options.tooltip.formatter = graph_two_formatter;
    options.title.text = result.title + " - Gaps";
    options.yAxis.title.text = 'Gap';

    // Instruct highcharts to render this chart
    $('#container-gaps').highcharts(options);

    // Third charts - lap by lap time differences
    options.chart.type = 'column';
    options.series = [];
    $.each(data, function (i, driver) {
      var prev_lap = 0;
      driver.data = [];
      $.each(driver.laps, function (i, lap) {
        if (i > 0) {
          driver.data.push(convert_lap(lap) - prev_lap);
        }

        prev_lap = convert_lap(lap);
      });

      // Hide or show drivers if applicable.
      if (hide_driver(params, driver.name)) {
        driver.visible = false;
      }

      options.series.push(driver);
    });

    options.title.text = result.title + ' - Lap diffs';
    $('#container-diffs').highcharts(options);

    // 4th charts - various Bar charts
    if (data[0].sector1) {
      options.chart.type = 'bar';
      options.plotOptions.bar = {
        dataLabels: {
          enabled: true,
          formatter: graph_four_formatter
        }
      };
      options.legend = { enabled: false };
      options.xAxis.title.text = 'Driver';
      options.yAxis.title.text = 'Time';
      options.tooltip.enabled = false;

      var sectors = [[], [], []];
      $.each(data, function (i, driver) {
        sectors[0].push([driver.name, driver.sector1.sort()[0]]);
        sectors[1].push([driver.name, driver.sector2.sort()[0]]);
        sectors[2].push([driver.name, driver.sector3.sort()[0]]);
      });

      $.each(sectors, function(i, sector) {
        var sorted = sector.sort(sort_sector);
        var data = [];
        var cats = [];

        $.each(sorted, function(i, value) {
          cats.push(value[0]);
          data.push(value[1]);
        });

        options.series = [ { data: data } ];
        options.xAxis.categories = cats;

        options.yAxis.min = Math.floor(data[0] - 1);
        options.yAxis.max = Math.ceil(data[data.length - 1]);
        options.title.text = result.title + ' - Sector ' + (i + 1);

        $('#container-sectors-sector' + (i + 1)).highcharts(options);
      });
    }
  }).fail(function(jqxhr, textStatus, error) {
    // Deal with AJAX errors semi-nicely
    $('#error').html(error).show();
  });
});
