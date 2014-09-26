window.Marx = function(options) {
  var _this = this;
  return $.getJSON("http://localhost:9292/quotes", function(data) {
    _this.marx_json = data;
    return _this.initialize(options);
  });
};

$.extend(Marx.prototype, {
  settings: {
    controls: 'standard',
    position: 'bottom-right'
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
    var _this = this;
    $('body').append("<div class=\"marx-js-controls\">\n  <link rel=\"stylesheet\" href=\"http://localhost:9292/marx.css\">\n  <a href=\"#open-controls\" class=\"open-controls\">MarxJS</a>\n</div>");
    this.$el = $('.marx-js-controls');
    this.$el.addClass('marx-js-collapsed');
    switch (this.settings.controls) {
      case 'standard':
        this.add_standard_controls();
        return this.$('a.open-controls').click(function(e) {
          return _this.toggle_controls(e);
        });
      case 'advanced':
        this.add_standard_controls();
        this.add_advanced_controls();
        return this.$('a.open-controls').click(function(e) {
          return _this.toggle_controls(e);
        });
      case 'minimum':
        return this.$('a.open-controls').click(function(e) {
          _this.populate_inputs();
          _this.populate_textareas();
          _this.populate_checkboxes();
          _this.populate_radios();
          return _this.populate_selects();
        });
    }
  },
  $: function(el) {
    return this.$el.find(el);
  },
  add_standard_controls: function() {
    var standard,
      _this = this;
    standard = "<div class=\"marx-standard-controls\">\n  <h4>Populate Form Fields</h4>\n  <div class=\"marx-js-group\">\n    <p>Populate whole form</p>\n    <a class='populate-whole-form' href=\"#populate-whole-form\">Go</a>\n  </div>\n  <div class=\"marx-js-group\">\n    <p>Populate TextAreas</p>\n    <a href=\"#populate-textareas\" class=\"populate-textareas\">Go</a>\n  </div>\n  <div class=\"marx-js-group\">\n    <p>Populate Inputs</p>\n    <a href=\"#populate-inputs\" class=\"populate-inputs\">Go</a>\n  </div>\n  <div class=\"marx-js-group\">\n    <p>Populate Check Boxes</p>\n    <a href=\"#populate-checkboxes\" class=\"populate-checkboxes\">Go</a>\n  </div>\n  <div class=\"marx-js-group\">\n    <p>Populate Radio Buttons</p>\n    <a href=\"#populate-radios\" class=\"populate-radios\">Go</a>\n  </div>\n  <div class=\"marx-js-group\">\n    <p>Populate Select Boxes</p>\n    <a href=\"#populate-selects\" class=\"populate-selects\">Go</a>\n  </div>\n</div>";
    this.$('a.open-controls').before(standard);
    return this.$('.marx-standard-controls a').click(function(e) {
      return _this.popluate_selected_fields(e);
    });
  },
  add_advanced_controls: function() {
    var advanced,
      _this = this;
    advanced = "<div class=\"marx-advanced-controls\">\n  <h4>Advanced Options</h4>\n  <div class=\"marx-js-group\">\n    <p>Clear Form</p>\n    <a href=\"#clear-form\" class=\"clear-form\">Go</a>\n  </div>\n  <div class=\"marx-js-group\">\n    <p>Populate and Submit</p>\n    <a href=\"#populate-submit\" class=\"populate-submit\">Go</a>\n  </div>\n  <div class=\"marx-js-group\">\n    <p><span data-text=\"Hide\">Show</span> Hidden Fields</p>\n    <a href=\"#show-hidden\" class=\"show-hidden\">Go</a>\n  </div>\n  <div class=\"marx-js-group\">\n    <p><span data-text=\"Collapse\">Expand</span> Select Boxes</p>\n    <a href=\"#expand-select\" class=\"expand-select\">Go</a>\n  </div>\n  <div class=\"marx-js-group ipsum\">\n    <p>Generate Ipsum<br />\n      <input min=\"1\" max=\"10\" type=\"number\" value='3' class=\"no-populate\" name=\"ipsum\" /> Paragraphs\n    </p>\n    <a href=\"#generate-ipsum\" class=\"generate-ipsum\">Go</a>\n  </div>\n</div>";
    this.$('a.open-controls').before(advanced);
    return this.$('.marx-advanced-controls a').click(function(e) {
      return _this.advanced_actions(e);
    });
  },
  /*=========================
      POPULATE FORM METHODS
  =========================
  */

  populate_inputs: function() {
    var _this = this;
    this.effected.inputs = 0;
    return $.each($('input'), function(i, input) {
      var obj, val_arr;
      if (!($(input).val() !== "" || $(input).hasClass('no-populate'))) {
        if (['checkbox', 'radio', 'hidden'].indexOf($(input).attr('type') < 0)) {
          _this.effected.inputs += 1;
        }
        obj = _this.marx_json[Math.floor(Math.random() * _this.marx_json.length)];
        val_arr = [obj.brother, obj.movie_name];
        if (obj.alt_brother != null) {
          val_arr.push(obj.alt_brother);
        }
        if (['text', 'password'].indexOf($(input).attr('type') >= 0)) {
          $(input).attr('data-marx-d', true).val(val_arr[Math.floor(Math.random() * val_arr.length)]);
        }
        if ($(input).attr('type') === 'number') {
          $(input).attr('data-marx-d', true).val(obj.movie_year);
        }
        if ($(input).attr('type') === 'email') {
          $(input).attr('data-marx-d', true).val("" + obj.brother + "@" + (obj.movie_name.toLowerCase().replace(/\s/g, '')) + ".com");
        }
        if ($(input).attr('type') === 'date') {
          return $(input).attr('data-marx-d', true).val("" + obj.movie_year + "-01-01");
        }
      }
    });
  },
  populate_textareas: function() {
    var _this = this;
    this.effected.textareas = 0;
    return $.each($('textarea'), function(i, input) {
      var obj;
      _this.effected.textareas += 1;
      obj = _this.marx_json[Math.floor(Math.random() * _this.marx_json.length)];
      return $(input).attr('data-marx-d', true).val(obj.body);
    });
  },
  populate_checkboxes: function() {
    var names,
      _this = this;
    this.effected.check_boxes = 0;
    names = [];
    $.each($('input[type=checkbox]'), function(i, input) {
      if (!(names.indexOf($(input).attr('name')) >= 0)) {
        return names.push($(input).attr('name'));
      }
    });
    return $.each(names, function(i, name) {
      var checked;
      checked = Math.floor(Math.random() * 2) === 1 ? true : false;
      $("input[name=" + name + "]").attr('data-marx-d', true).attr('checked', checked);
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
    $('input[type=radio]').each(function(i, input) {
      if (!(names.indexOf($(input).attr('name')) >= 0)) {
        return names.push($(input).attr('name'));
      }
    });
    return $.each(names, function(i, name) {
      var total;
      total = $("input[name=" + name + "]").length;
      $("input[name=" + name + "]:eq(" + (Math.floor(Math.random() * total)) + ")").attr('data-marx-d', true).attr('checked', true);
      return _this.effected.radio_buttons += 1;
    });
  },
  populate_selects: function() {
    var _this = this;
    this.effected.selects = 0;
    return $('select').each(function(i, select) {
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
    $('input[data-marx-hidden=true]').each(function(i, input) {
      var type;
      type = $(input).attr('type') === 'hidden' ? 'text' : 'hidden';
      $(input).attr('type', type);
      return _this.effected.hidden_fields += 1;
    });
    return $('input[type=hidden]').each(function(i, hidden) {
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
        $note.css('top', "" + (20 + (num * 50)) + "px").delay(2000 + (num * 50)).slideUp('fast', function() {
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
    $ipsum = $("<div class='marx-generated-ipsum'>\n  <h4>Marx Ipsum</h4>\n  <a href='#close' class='marx-ipsum-close'>X</a>\n  <div class='container'></div>\n</div>");
    $('body').append($ipsum);
    return $.getJSON("http://localhost:9292/monologues", function(data) {
      var i, _i;
      data.sort(function() {
        return 0.5 - Math.random();
      });
      for (i = _i = 1; 1 <= num ? _i <= num : _i >= num; i = 1 <= num ? ++_i : --_i) {
        $ipsum.find('.container').append("<p>" + data[i].body + "</p>");
      }
      return $('a.marx-ipsum-close').click(function(e) {
        $('.marx-generated-ipsum').slideUp('fast');
        return false;
      });
    });
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
        this.populate_inputs();
        this.populate_textareas();
        this.populate_checkboxes();
        this.populate_radios();
        this.populate_selects();
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
