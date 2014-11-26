window.Marx = function(options) {
  var _this = this;
  return $.getJSON("http://marxjs.sparkmasterflex.com:9292/characters", function(data) {
    _this.marx_json = data;
    return _this.initialize(options);
  });
};

$.extend(Marx.prototype, {
  settings: {
    controls: 'standard',
    position: 'bottom-right',
    form: "",
    ipsum: 3,
    max_ipsum: 10
  },
  effected: {
    inputs: 0,
    texareas: 0,
    selects: 0,
    check_boxes: 0,
    radio_buttons: 0,
    hidden_fields: 0
  },
  initialize: function(options) {
    $.extend(this.settings, options);
    return this.create_controls();
  },
  /*=========================
        BUILD CONTROLS
  =========================
  */

  create_controls: function() {
    var open_controls,
      _this = this;
    $('body').append("<div class=\"marx-js-controls " + this.settings.position + "\">\n  <link rel=\"stylesheet\" href=\"http://marxjs.sparkmasterflex.com:9292/marx.css\">\n</div>");
    this.$el = $('.marx-js-controls');
    open_controls = this.settings.controls !== 'toggle-all' ? "<a href='#open-controls' class='open-controls'>MarxJS</a>" : "<div class=\"open-controls\">\n  <a href=\"#advanced-controls\" class=\"advanced-controls\" title=\"Show Advanced Controls\">Advanced Controls</a>\n  <a href=\"#standard-controls\" class=\"standard-controls\" title=\"Show Standard Controls\">Standard Controls</a>\n  <a href=\"#populate-whole-form\" class=\"populate-whole-form\" title=\"Populate Whole Form\">MarxJS</a>\n</div>";
    this.$el.append(open_controls);
    this.$el.addClass('marx-js-collapsed');
    switch (this.settings.controls) {
      case 'standard':
        this.add_standard_controls();
        return this.$('a.open-controls').click(function(e) {
          return _this.toggle_controls(e);
        });
      case 'advanced':
      case 'toggle-advanced':
        this.add_standard_controls();
        this.add_advanced_controls();
        return this.$('a.open-controls').click(function(e) {
          return _this.toggle_controls(e);
        });
      case 'minimum':
        return this.$('a.open-controls').click(function(e) {
          return _this.populate_whole_form(e);
        });
      case 'toggle-all':
        this.add_standard_controls();
        this.add_advanced_controls();
        this.$('a.standard-controls').click(function(e) {
          _this.$('.marx-standard-controls').toggle();
          _this.$('.marx-advanced-controls').hide();
          return false;
        });
        this.$('a.advanced-controls').click(function(e) {
          _this.$('.marx-advanced-controls').toggle();
          _this.$('.marx-standard-controls').hide();
          return false;
        });
        return this.$('a.populate-whole-form').click(function(e) {
          _this.$('.marx-standard-controls').hide();
          _this.$('.marx-advanced-controls').hide();
          return _this.populate_whole_form(e);
        });
    }
  },
  $: function(el) {
    return this.$el.find(el);
  },
  add_standard_controls: function() {
    var action, standard, _i, _len, _ref,
      _this = this;
    standard = "<div class=\"marx-standard-controls\">\n  <h4>Populate Form Fields</h4>\n</div>";
    this.$('.open-controls').before(standard);
    _ref = [['populate-whole-form', 'Populate Whole Form'], ['populate-textareas', 'Populate TextAreas'], ['populate-inputs', 'Populate Inputs'], ['populate-checkboxes', 'Populate Check Boxes'], ['populate-radios', 'Populate Radio Buttons'], ['populate-selects', 'Populate Select Boxes']];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      action = _ref[_i];
      $('.marx-standard-controls').append(this.build_action(action));
    }
    return this.$('.marx-standard-controls a').click(function(e) {
      return _this.popluate_selected_fields(e);
    });
  },
  add_advanced_controls: function() {
    var action, advanced, _i, _len, _ref,
      _this = this;
    advanced = "<div class=\"marx-advanced-controls\">\n  <h4>Advanced Options</h4>\n</div>";
    this.$('.open-controls').before(advanced);
    _ref = [['clear-form', 'Clear Form'], ['populate-submit', 'Populate and Submit'], ['show-hidden', '<span data-text="Hide">Show</span> Hidden Fields'], ['expand-select', '<span data-text="Collapse">Expand</span> Select Boxes'], ['generate-ipsum', 'Generate Ipsum']];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      action = _ref[_i];
      $('.marx-advanced-controls').append(this.build_action(action));
    }
    if (this.settings.controls === 'toggle-advanced') {
      this.set_toggle_advanced();
    }
    return this.$('.marx-advanced-controls a').click(function(e) {
      return _this.advanced_actions(e);
    });
  },
  build_action: function(action) {
    return "<div class=\"marx-js-group\">\n  <p>" + action[1] + "</p>\n  <a href=\"#" + action[0] + "\" class=\"" + action[0] + "\">Go</a>\n</div>";
  },
  set_toggle_advanced: function() {
    var _this = this;
    this.$('.marx-advanced-controls').hide();
    this.$('.marx-standard-controls').append("<a href='#advanced' class='marx-toggle-advanced'>&laquo; Advanced</a>");
    return this.$('a.marx-toggle-advanced').click(function(e) {
      var txt;
      txt = $(e.target).hasClass('opened') ? "&laquo; Advanced" : "Close &raquo;";
      _this.$(e.target).toggleClass('opened').html(txt);
      return _this.$('.marx-advanced-controls').toggle();
    });
  },
  /*=========================
      POPULATE FORM METHODS
  =========================
  */

  populate_whole_form: function(e) {
    this.populate_inputs();
    this.populate_textareas();
    this.populate_checkboxes();
    this.populate_radios();
    this.populate_selects();
    return false;
  },
  populate_inputs: function() {
    var _this = this;
    this.effected.inputs = 0;
    return $.each($("" + this.settings.form + " input"), function(i, input) {
      var brother, movie, obj, strings, value;
      if (!($(input).val() !== "" || $(input).hasClass('no-populate'))) {
        if (['checkbox', 'radio', 'hidden'].indexOf($(input).attr('type') < 0)) {
          _this.effected.inputs += 1;
        }
        obj = _this.get_random();
        brother = JSON.parse(obj.brother);
        movie = JSON.parse(obj.movie);
        strings = [brother.name, movie.name, obj.first_name, obj.last_name, obj.description].filter(function() {
          return true;
        });
        value = (function() {
          switch ($(input).attr('type')) {
            case 'number':
              return movie.year;
            case 'email':
              return "" + (brother.name.toLowerCase().replace(/\s/g, '')) + "@" + (movie.name.toLowerCase().replace(/\s/g, '')) + ".com";
            case 'url':
              return "http://" + (movie.name.toLowerCase().replace(/\s/g, '')) + ".com";
            case 'date':
              return "" + movie.year + "-01-01";
            default:
              return strings[Math.floor(Math.random() * strings.length)];
          }
        })();
        return $(input).attr('data-marx-d', true).val(value);
      }
    });
  },
  populate_textareas: function() {
    var _this = this;
    this.effected.textareas = 0;
    return $.getJSON("http://marxjs.sparkmasterflex.com:9292/quotes", function(data) {
      return $.each($("" + _this.settings.form + " textarea"), function(i, input) {
        _this.effected.textareas += 1;
        return $(input).attr('data-marx-d', true).val(data[Math.floor(Math.random() * data.length)].body);
      });
    });
  },
  populate_checkboxes: function() {
    var names,
      _this = this;
    this.effected.check_boxes = 0;
    names = [];
    $.each($("" + this.settings.form + " input[type=checkbox]"), function(i, input) {
      if (!(names.indexOf($(input).attr('name')) >= 0)) {
        return names.push($(input).attr('name'));
      }
    });
    return $.each(names, function(i, name) {
      var checked, clean_name;
      checked = Math.floor(Math.random() * 2) === 1 ? true : false;
      clean_name = name.replace(/\[/g, '\\[').replace(/\]/g, '\\]');
      $("" + _this.settings.form + " input[name=" + clean_name + "]").attr('data-marx-d', true).attr('checked', checked);
      if (checked) {
        return _this.effected.check_boxes += 1;
      }
    });
  },
  populate_radios: function() {
    var names,
      _this = this;
    this.effected.radio_buttons = 0;
    names = [];
    $("" + this.settings.form + " input[type=radio]").each(function(i, input) {
      if (!(names.indexOf($(input).attr('name')) >= 0)) {
        return names.push($(input).attr('name'));
      }
    });
    return $.each(names, function(i, name) {
      var clean_name, total;
      clean_name = name.replace(/\[/g, '\\[').replace(/\]/g, '\\]');
      total = $("" + _this.settings.form + " input[name=" + clean_name + "]").length;
      $("" + _this.settings.form + " input[name=" + name + "]:eq(" + (Math.floor(Math.random() * total)) + ")").attr('data-marx-d', true).attr('checked', true);
      return _this.effected.radio_buttons += 1;
    });
  },
  populate_selects: function() {
    var _this = this;
    this.effected.selects = 0;
    return $("" + this.settings.form + " select").each(function(i, select) {
      var $opt, rand, total;
      _this.effected.selects += 1;
      total = $(select).attr('data-marx-d', true).find('option').length;
      rand = Math.floor(Math.random() * total);
      $opt = $(select).find("option:eq(" + rand + ")");
      if (($opt.attr('value') != null) && $opt.attr('value') !== "") {
        return $opt.attr('selected', true);
      } else {
        return $opt.next('option').attr('selected', true);
      }
    });
  },
  toggle_hidden_fields: function() {
    var _this = this;
    this.effected.hidden_fields = 0;
    $("" + this.settings.form + " input[data-marx-hidden=true]").each(function(i, input) {
      var type;
      type = $(input).attr('type') === 'hidden' ? 'text' : 'hidden';
      $(input).attr('type', type);
      return _this.effected.hidden_fields += 1;
    });
    return $("" + this.settings.form + " input[type=hidden]").each(function(i, hidden) {
      if ($(hidden).data('marx-d') == null) {
        _this.effected.hidden_fields += 1;
        return $(hidden).attr('type', 'text').attr('data-marx-d', true).attr('data-marx-hidden', true);
      }
    });
  },
  trigger_notifications: function() {
    var num,
      _this = this;
    num = 0;
    return $.each(this.effected, function(key, val) {
      var $note, el;
      if (val !== 0) {
        el = key.replace(/_/, ' ');
        $note = $("<p class='marx-notification'>" + val + " " + el + " elements were altered</p>");
        _this.$el.append($note);
        $note.css('top', "" + (20 + (num * 50)) + "px").delay(5000 + (num * 50)).slideUp('fast', function() {
          return $note.remove();
        });
        num += 1;
        return _this.effected[key] = 0;
      }
    });
  },
  toggle_description: function($link) {
    var $parent, $span, from, to;
    $parent = $link.parent('.marx-js-group');
    $span = $parent.find('p span');
    to = $span.data('text');
    from = $span.text();
    return $span.text(to).data('text', from);
  },
  generate_ipsum: function() {
    var $ipsum, num,
      _this = this;
    $('.marx-generated-ipsum').remove();
    num = this.$('.ipsum input').val();
    $ipsum = $("<div class='marx-generated-ipsum " + this.settings.position + "'>\n  <h4>Marx Ipsum</h4>\n  <a href='#close' class='marx-ipsum-close'>X</a>\n  <div class='marx-container'></div>\n</div>");
    $('body').append($ipsum);
    return $.getJSON("http://marxjs.sparkmasterflex.com:9292/monologues", function(data) {
      var i, max, monologues, _i;
      max = num > data.length ? data.length - 1 : num;
      monologues = data.sort(function() {
        return 0.5 - Math.random();
      });
      for (i = _i = 1; 1 <= max ? _i <= max : _i >= max; i = 1 <= max ? ++_i : --_i) {
        $ipsum.find('.marx-container').append("<p>" + monologues[i].body + "</p>");
      }
      return $('a.marx-ipsum-close').click(function(e) {
        $('.marx-generated-ipsum').slideUp('fast');
        return false;
      });
    });
  },
  get_random: function() {
    return this.marx_json[Math.floor(Math.random() * this.marx_json.length)];
  },
  /*=====================
           EVENTS
  =====================
  */

  toggle_controls: function(e) {
    this.$el.toggleClass('marx-js-collapsed');
    return false;
  },
  popluate_selected_fields: function(e) {
    switch ($(e.target).attr('class')) {
      case 'populate-textareas':
        this.populate_textareas();
        break;
      case 'populate-inputs':
        this.populate_inputs();
        break;
      case 'populate-checkboxes':
        this.populate_checkboxes();
        break;
      case 'populate-radios':
        this.populate_radios();
        break;
      case 'populate-selects':
        this.populate_selects();
        break;
      default:
        this.populate_whole_form();
    }
    this.trigger_notifications();
    return false;
  },
  advanced_actions: function(e) {
    var _this = this;
    switch ($(e.target).attr('class')) {
      case 'clear-form':
        $('input[data-marx-d=true], textarea[data-marx-d=true]').val("");
        $('input[type=checkbox], input[type=radio]').each(function(i, cb) {
          if (($(cb).data('marx-d') != null) === $(cb).data('marx-d') && true) {
            return $(cb).removeAttr('checked');
          }
        });
        $('select[data-marx-d=true] option:eq(0)').attr('selected', true);
        break;
      case 'populate-submit':
        $.when(this.populate_inputs(), this.populate_textareas(), this.populate_checkboxes(), this.populate_radios(), this.populate_selects()).then(function() {
          $(e.target).replace("<span class='spinner'>Loading</span>");
          return setTimeout(function() {
            return $('form').submit();
          }, 500);
        });
        break;
      case 'show-hidden':
        this.toggle_description($(e.target));
        $.when(this.toggle_hidden_fields()).then(function() {
          return _this.trigger_notifications();
        });
        break;
      case 'expand-select':
        this.toggle_description($(e.target));
        $('select').each(function(i, select) {
          if ($(select).attr('size') != null) {
            return $(select).removeAttr('size');
          } else {
            return $(select).attr('size', $(select).find('option').length);
          }
        });
        break;
      case 'generate-ipsum':
        this.generate_ipsum();
    }
    return false;
  }
});
