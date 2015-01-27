var chart_height_multiplier = 60;

// Helper method to return a total time for an array or array slice
function array_sum(array) {
  if (array.length > 0) {
    var race = array.reduce(function (a, b) {
      return a + b;
    });
  }
  else {
    race = 0;
  }

  return parseFloat(race);
}

function convert_seconds_to_lap(seconds, include_micro) {
  var t1 = Math.floor(seconds / 60);
  var t2;
  if (include_micro) {
    t2 = (seconds % 60).toFixed(3);
  }
  else {
    t2 = (seconds % 60).toFixed(0);
  }
  return (t1 > 0 ? t1 + ":" : '') + (t2 < 10 ? "0" + t2 : t2);
}

function graph_one_axis_formatter() {
  return convert_seconds_to_lap(this.value, false);
}

function pace_graph_formatter() {
  return convert_seconds_to_lap(this.y, true);
}

function speed_graph_formatter() {
  var k = (this.y * 3.6).toFixed(3);
  var m = (this.y * 2.23694).toFixed(3);
  return k + " kmh / " + m + " mph / lap " + this.series.options.laps[this.point.x];
}

// The tooltip formatter for the first graph (laps)
function graph_one_formatter() {
  var s = '<b>Lap ' + this.x + '</b>';

  $.each(this.points, function (i, point) {
    // Converts seconds to mm:ss.ddd format - ie 106.322 = 1:46.322
    s += '<br/><span style="color: ' + point.series.color + ';">' + point.series.name + '</span>: ' + convert_seconds_to_lap(point.y, true);
  });

  return s;
}

// The tooltip formatter for the second graph (gaps)
function graph_two_formatter() {
  var s = '<b>Lap ' + this.x + '</b>';

  $.each(this.points, function (i, point) {
    var v = Math.abs(point.y).toFixed(3);
    if (point.y > 0) {
      v = '<span style="font-weight: bold">' + v + '</span>';
    }
    s += '<br/><span style="color: ' + point.series.color + ';">' + point.series.name + '</span>: ' + v;
  });

  return s;
}

function graph_four_formatter() {
  if (this.series.options.laps) {
    return this.y.toFixed(3) + " (lap " + this.series.options.laps[this.point.x] + ")";
  }
  else {
    return this.y.toFixed(3);
  }
}

function time_trial_formatter() {
  return convert_seconds_to_lap(this.y.toFixed(3), true);
}

function position_tooltip_formatter() {
  var s = '<b>Lap ' + this.x + '</b>';

  $.each(this.points, function (i, point) {
    var v = Math.floor(point.y);
    s += '<br/><span style="color: ' + point.series.color + ';">' + point.series.name + '</span>: ' + v;
  });

  return s;
}

function fuel_tooltip_formatter() {
  var s = '<b>Lap ' + this.x + '</b>';

  $.each(this.points, function (i, point) {
    var v = point.y.toFixed(3);
    s += '<br/><span style="color: ' + point.series.color + ';">' + point.series.name + '</span>: ' + v;
  });

  return s;
}

function diff_tooltip_formatter() {
  var s = '<b>Lap ' + this.x + '</b>';

  $.each(this.points, function (i, point) {
    var v = Math.abs(point.y).toFixed(3);
    if (point.y < 0) {
      v = v + " faster";
    }
    else {
      v = v + " slower";
    }
    s += '<br/><span style="color: ' + point.series.color + ';">' + point.series.name + '</span>: ' + v;
  });

  return s;
}

// Helper function to get information from the URL
function getQueryString() {
  var ret = {};
  if (document.location.toString().split('?').length == 1) {
    return ret;
  }

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

  return false;
}

function sort_sector(a, b) {
  return a[1] == b[1] ? 0 : a[1] < b[1] ? -1 : 1;
}

function sort_lap(a, b) {
  return a.laps[0] == b.laps[0] ? 0 : a.laps[0] < b.laps[0] ? -1 : 1;
}

function fastest_sector_time(driver, sector) {
  var fastest_time = 999;
  var fastest_lap = 0;

  $.each(driver['sector' + sector], function(i, lap) {
    if (lap < fastest_time) {
      fastest_lap = i + 1;
      fastest_time = lap;
    }
  });

  var avg = array_sum(driver['sector' + sector]) / driver['sector' + sector].length;

  return [driver.name, fastest_time, fastest_lap, avg];
}

function sort_compare(a, b) {
  return a == b ? 0 : a < b ? -1 : 1
}

function sort_pace(a, b) {
  return a.avg == b.avg ? 0 : a.avg < b.avg ? -1 : 1
}

function sort_speed(a, b) {
  return a.speed == b.speed ? 0 : a.speed < b.speed ? 1 : -1
}

function manage_params(target) {
  var show = params.show ? params.show.split(',') : [];
  var hide = params.hide ? params.hide.split(',') : [];
  var adding = !target.visible;
  var name = target.name;

  if (adding) {
    show.push(name);
    $.each(hide, function(index, item) {
      if (item == name) {
        hide.splice(index, 1);
      }
    });
  }
  else {
    hide.push(name);
    $.each(show, function(index, item) {
      if (item == name) {
        show.splice(index, 1);
      }
    });
  }

  $.each({ show: show, hide: hide}, function(key, val) {
    if (val.length > 0) {
      params[key] = val.join(',');
    }
    else {
      delete params[key];
    }
  });

  update_show_hide_links(target.chart.container.parentNode.id.replace('container-', ''));
}

function update_show_hide_links(tab) {
  if (!tab) {
    tab = params.tab;
  }
  $('#show_chart_' + tab).attr('href', '?tab=' + params.tab + (params.show ? '&show=' + params.show : '') + (params.compare ? '&compare=' + params.compare : ''));
  $('#hide_chart_' + tab).attr('href', '?tab=' + params.tab + (params.hide ? '&hide=' + params.hide : '') + (params.compare ? '&compare=' + params.compare : ''));
}

function set_bar_chart_options(options) {
  options.chart.type = 'bar';
  options.plotOptions.bar = {
    dataLabels: {
      enabled: true,
      padding: 10,
      align: 'right',
      color: '#333333',
      style: {
        fontWeight: 'bold'
      },
      formatter: graph_four_formatter
    }
  };
  options.legend = { enabled: false };
  options.xAxis.title.text = 'Driver';
  options.yAxis.title.text = 'Time';
  options.yAxis.reversed = false;
  options.tooltip.enabled = false;

  return options;
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
      pointStart: 1,
      events: {
        legendItemClick: function(e) {
          manage_params(e.currentTarget);
        }
      }
    },
    column: {
      events: {
        legendItemClick: function(e) {
          manage_params(e.currentTarget);
        }
      }
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

var fastest_overall_lap = {
  driver: '',
  time: 0,
  lap: 0,
  sectors: []
};

// When the browser/page has been loaded...
$(function () {
  if (typeof race == 'object' && race.hasOwnProperty('sessions')) {
    // Figure out what race/league the user wants from the URL
    params = getQueryString();

    // Pre-fill the show/hide parameter if applicable
    if (!params.show) {
      if (params.hide) {
        params.show = $.map(race.sessions, function(driver) {
          if ($.inArray(driver.name, params.hide.split(',')) < 0) {
            return driver.name;
          }
        }).join(',');
      }
      else {
        params.show = $.map(race.sessions, function(driver) { return driver.name }).join(',');
      }
    }
    else {
      if (!params.hide) {
        params.hide = $.map(race.sessions, function(driver) {
          if ($.inArray(driver.name, params.show.split(',')) < 0) {
            return driver.name;
          }
        }).join(',');
      }
      else {
        params.hide = $.map(race.sessions, function(driver) { return driver.name }).join(',');
      }
    }

    // Work out what tab the user wants from the URL
    if (params.tab) {
      $('li.active').removeClass('active').parent().children().children('a#tab-' + params.tab).parent().addClass('active');

      $('.tab-pane').removeClass('active');
      $('#container-' + params.tab).addClass('active');
    }
    else {
      params.tab = 'laps';
    }

    // Initialise the show/hide links
    update_show_hide_links();

    // Apply show/hide param values to the session list
    $.map(race.sessions, function(session) {
      session.visible = !hide_driver(params, session.name);
    }, params);

    // Loop through each driver
    $.each(race.sessions, function (j, driver) {
      driver.data = [];
      // Loop through each lap
      $.each(driver.laps, function (i, lap) {
        // Convert each lap into seconds so the highcharts can understand it
        driver.data[i] = lap;

        // Save the fastest lap
        if (driver.data[i] < fastest_overall_lap.time || fastest_overall_lap.time == 0) {
          fastest_overall_lap = {
            time: driver.data[i],
            driver: j,
            lap: i,
            sectors: [
              driver.sector1 ? parseFloat(driver.sector1[i]) : 0,
              driver.sector2 ? parseFloat(driver.sector2[i]) : 0,
              driver.sector3 ? parseFloat(driver.sector3[i]) : 0
            ]
          };
        }
      });

      options.series.push(driver);
    });

    if (race.time_trial) {
      set_bar_chart_options(options);
      var series = options.series.sort(sort_lap);
      laps = [];
      cats = [];
      $.each(series, function(i,driver) {
        laps.push(driver.laps[0]);
        cats.push(driver.name);
      });
      options.series = [{ data: laps }];
      options.xAxis.categories = cats;
      options.yAxis.min = laps[0] - 5;
      options.plotOptions.bar.dataLabels.formatter = time_trial_formatter;
    }
    else {
      // Set basic options and instruct highcharts to render the chart
      options.title.text = "Lap times";
      options.tooltip.formatter = graph_one_formatter;
      options.yAxis.labels = {
        formatter: graph_one_axis_formatter
      };
    }

    $('#container-laps-child').highcharts(options);

    if (!race.time_trial) {
      // Clear out the series for the second chart
      options.series = [];
      if (options.yAxis.labels) {
        options.yAxis.labels.formatter = null;
      }

      // Determine the average time for the winner (first array value)
      var winner_average = array_sum(race.sessions[0].laps) / race.sessions[0].laps.length;

      // Figure out the gaps between each driver and the winning time
      $.each(race.sessions, function (i, driver) {
        driver.data = [];
        driver.average = [];
        $.each(driver.laps, function (i, lap) {
          // First lap is handled separately
          if (i == 0) {
            driver.average.push(lap);
          }
          // Other laps are added together as you go
          else {
            laps_slice = [];
            $.each(driver.laps.slice(0, i + 1), function (i, lap) {
              laps_slice.push(lap);
            });
            driver.average.push(array_sum(laps_slice));
          }

          // Keep a track of the difference
          driver.data.push(((winner_average * (i + 1)) - driver.average[i]));
        });

        driver.data.unshift(0);
        options.series.push(driver);
      });

      // Change the tooltip formatter, chart title and y-axis title options
      options.tooltip.formatter = graph_two_formatter;
      options.title.text = "Gaps to winner";
      options.yAxis.title.text = 'Gap';
      options.plotOptions.spline.pointStart = 0;

      // Instruct highcharts to render this chart
      $('#container-gaps-child').highcharts(options);

      // Third charts - lap by lap time differences
      options.chart.type = 'column';
      options.yAxis.title.text = 'Difference';
      options.series = [];
      $.each(race.sessions, function (i, driver) {
        var prev_lap = 0;
        driver.data = [];
        $.each(driver.laps, function (i, lap) {
          if (i > 0) {
            driver.data.push(lap - prev_lap);
          }

          prev_lap = lap;
        });

        options.series.push(driver);
      });

      options.title.text = 'Lap diffs';
      options.plotOptions.column.pointStart = 2;
      options.tooltip.formatter = diff_tooltip_formatter;
      $('#container-diffs-child').highcharts(options);
    }
    else {
      $('#tab-gaps').hide();
      $('#tab-diffs').hide();
    }

    // Fuel chart
    if (race.fuel_available) {
      options.title.text = 'Fuel usage';
      options.chart.type = 'spline';
      options.tooltip.formatter = fuel_tooltip_formatter;
      options.yAxis.title.text = 'Fuel Remaining';
      options.series = [];
      $.each(race.sessions, function (i, driver) {
        options.series.push({
          name: driver.name,
          data: driver.fuel,
          visible: !hide_driver(params, driver.name),
          color: driver.color,
          marker: driver.marker
        });
      });

      $('#container-fuel-child').highcharts(options);
    }
    else {
      $('#tab-fuel').hide();
    }

    // Position chart
    if (race.position_available) {
      options.title.text = 'Position Changes';
      options.chart.type = 'spline';
      options.tooltip.formatter = position_tooltip_formatter;
      options.plotOptions.spline.pointStart = 0;
      options.yAxis.title.text = 'Position';
      options.yAxis.tickInterval = 1;
      options.yAxis.min = 1;
      options.yAxis.reversed = true;
      options.series = [];
      $.each(race.sessions, function (i, driver) {
        driver.position.unshift(driver.grid_position);
        options.series.push({
          name: driver.name,
          data: driver.position,
          visible: !hide_driver(params, driver.name),
          color: driver.color,
          marker: driver.marker
        });
      });

      $('#container-position-child').highcharts(options);
    }
    else {
      $('#tab-position').hide();
    }

    // 4th charts - various Bar charts
    set_bar_chart_options(options);
    if (race.sectors_available) {
      var sectors = [[], [], []];
      $.each(race.sessions, function (i, driver) {
        if (!driver.visible) {
          return;
        }
        if (driver.sector1.length > 0) {
          sectors[0].push(fastest_sector_time(driver, 1));
        }
        if (driver.sector2.length > 0) {
          sectors[1].push(fastest_sector_time(driver, 2));
        }
        if (driver.sector3.length > 0) {
          sectors[2].push(fastest_sector_time(driver, 3));
        }
      });

      var tb = {
        "sector1": {},
        "sector2": {},
        "sector3": {},
        "total": 0
      };
      var fl = "Fastest Lap (" + race.sessions[fastest_overall_lap.driver].name + ")";
      $.each(sectors, function(i, sector) {
        var sorted = sector.sort(sort_sector);
        var data = [];
        var cats = [];
        var laps = [];
        var avgs = [];

        $.each(sorted, function(i, value) {
          cats.push(value[0]);
          data.push(value[1]);
          laps.push(value[2]);
          avgs.push([value[0], value[3]]);
        });

        tb["sector" + parseInt(i + 1)] = { "time": data[0], "driver": cats[0] };

        options.series = [{ data: data, laps: laps }];

        options.xAxis.categories = cats;
        options.yAxis.min = Math.floor(data[0] - 5);
        options.title.text = 'Sector ' + (i + 1) + ' - Fastest Times';
        options.chart.renderTo = 'container-sectors-sector' + (i + 1);

        data.unshift({ y: fastest_overall_lap.sectors[i], color: 'red' });
        cats.unshift(fl);
        laps.unshift(fastest_overall_lap.lap + 1);

        $("#" + options.chart.renderTo).css('height', (race.sessions.length + 1) * chart_height_multiplier);

        new Highcharts.Chart(options);

        // Sector average charts
        var averages = avgs.sort(sort_sector);
        var average_cats = [];
        $.each(averages, function(i, s) {
          average_cats.push(s[0]);
        });

        options.title.text = 'Sector ' + (i + 1) + ' - Average Time';
        options.chart.renderTo = 'container-sectors-sector' + (i + 1) + '-average';
        options.series = [{ data: avgs }];
        options.xAxis.categories = average_cats;
        options.yAxis.min = Math.floor(avgs[0][1] - 2);

        $("#" + options.chart.renderTo).css('height', race.sessions.length * chart_height_multiplier);

        new Highcharts.Chart(options);
      });

      for (i = 1; i <= 3; i++) {
        tb["total"] += tb["sector" + i].time;
        $("#tb-" + i + "-driver").html(tb["sector" + i].driver);
        $("#tb-" + i + "-time").html(tb["sector" + i].time);
      }
      var tb_total = convert_seconds_to_lap(tb["total"].toFixed(3), true);
      var tb_diff = parseFloat(fastest_overall_lap.time - tb["total"]).toFixed(3);
      if (tb_diff > 0) {
        tb_total += " (" + tb_diff + " faster)";
      }
      $("#tb-total").html(tb_total);
    }
    else {
      $('#tab-sectors').hide();
    }

    // Pace charts - top 15, 50 and 80% lap times, averaged out per driver
    options.plotOptions.bar.dataLabels.formatter = pace_graph_formatter;
    var pace = {
      top15: [],
      top50: [],
      top80: []
    };

    $.each(race.sessions, function(index, driver) {
      if (!driver.visible) {
        return;
      }
      if (driver.laps.length > 0) {
        var l15 = Math.ceil(driver.laps.length * 0.15);
        var l50 = Math.ceil(driver.laps.length * 0.50);
        var l80 = Math.ceil(driver.laps.length * 0.80);

        pace.top15.push({ name: driver.name, avg: array_sum(driver.laps.sort(sort_compare).slice(0, l15)) / l15 });
        pace.top50.push({ name: driver.name, avg: array_sum(driver.laps.sort(sort_compare).slice(0, l50)) / l50 });
        pace.top80.push({ name: driver.name, avg: array_sum(driver.laps.sort(sort_compare).slice(0, l80)) / l80 });
      }
    });

    for (var p in pace) {
      var n = p.substring(3);

      var laps = [];
      var cats = [];

      var lowest_pace = 999;

      $.each(pace[p].sort(sort_pace), function(i, driver) {
        lowest_pace = (lowest_pace > driver.avg ? driver.avg : lowest_pace);
        laps.push(driver.avg);
        cats.push(driver.name);
      });

      options.title.text = 'Pace - Top ' + n + '% of laps';
      options.chart.renderTo = 'container-pace-' + n;
      options.series = [{ data: laps }];
      options.xAxis.categories = cats;
      options.yAxis.min = Math.floor(lowest_pace - 5);
      options.yAxis.tickInterval = 5;
      options.yAxis.labels.formatter = function() {
        return convert_seconds_to_lap(this.value);
      };

      $("#" + options.chart.renderTo).css('height', race.sessions.length * chart_height_multiplier);

      new Highcharts.Chart(options);
    }

    // Top speed chart
    if (race.speed_available) {
      options.title.text = 'Speed trap';
      options.series = [];
      var speed = [];
      laps = [];
      cats = [];
      var lowest_speed = 999;
      var speed_data = $.map(race.sessions, function(l, i) {
        if (!l.visible) {
          return;
        }
        if (l.speed.length > 0) {
          return { name: l.name, lap: l.speed[0], speed: l.speed[1] }
        }
      });
      $.each(speed_data.sort(sort_speed), function (index, data) {
        lowest_speed = (lowest_speed > data.speed ? data.speed : lowest_speed);
        speed.push(data.speed);
        laps.push(data.lap);
        cats.push(data.name);
      });
      options.series = [{ data: speed, laps: laps }];
      options.xAxis.categories = cats;
      options.plotOptions.bar.dataLabels.formatter = speed_graph_formatter;
      options.chart.renderTo = 'container-speed-child';
      options.yAxis.min = Math.floor(lowest_speed - 1);
      options.yAxis.title.text = 'Speed (m/s)';
      new Highcharts.Chart(options);
    }
    else {
      $('#tab-speed').hide();
    }
  }
});
