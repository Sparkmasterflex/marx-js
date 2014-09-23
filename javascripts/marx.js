window.Marx = function() {
  var _this = this;
  return $.getJSON("http://localhost:9292/json", function(data) {
    _this.marx_json = data;
    return _this.initialize();
  });
};

$.extend(Marx.prototype, {
  initialize: function() {
    return this.create_controls();
  },
  create_controls: function() {
    var _this = this;
    $('body').append("<div class=\"marx-js-controls\">\n  <link rel=\"stylesheet\" href=\"http://localhost:9292/assets/application.css\">\n  <div class=\"marx-form-controls\">\n    <h4>Populate Form Fields</h4>\n    <div class=\"marx-js-group\">\n      <p>Populate all inputs, textareas, check boxes, radio buttons and select boxes</p>\n      <a class='populate-whole-form' href=\"#populate-whole-form\">Go</a>\n    </div>\n    <div class=\"marx-js-group\">\n      <p>Populate TextAreas</p>\n      <a href=\"#populate-textareas\" class=\"populate-textareas\">Go</a>\n    </div>\n    <div class=\"marx-js-group\">\n      <p>Populate Inputs</p>\n      <a href=\"#populate-inputs\" class=\"populate-inputs\">Go</a>\n    </div>\n    <div class=\"marx-js-group\">\n      <p>Populate Check Boxes</p>\n      <a href=\"#populate-checkboxes\" class=\"populate-checkboxes\">Go</a>\n    </div>\n    <div class=\"marx-js-group\">\n      <p>Populate Radio Buttons</p>\n      <a href=\"#populate-radios\" class=\"populate-radios\">Go</a>\n    </div>\n    <div class=\"marx-js-group\">\n      <p>Populate Select Boxes</p>\n      <a href=\"#populate-selects\" class=\"populate-selects\">Go</a>\n    </div>\n  </div>\n  <a href=\"#open-controls\" class=\"open-controls\">MarxJS</a>\n</div>");
    this.$el = $('.marx-js-controls');
    this.$el.addClass('marx-js-collapsed');
    this.$('a.open-controls').click(function(e) {
      return _this.toggle_controls(e);
    });
    return this.$('.marx-js-group a').click(function(e) {
      return _this.popluate_selected_fields(e);
    });
  },
  populate_inputs: function() {
    var _this = this;
    return $.each($('input'), function(i, input) {
      var obj, val_arr;
      if ($(input).val() === "") {
        obj = _this.marx_json[Math.floor(Math.random() * _this.marx_json.length)];
        val_arr = [obj.brother, obj.movie_name];
        if (obj.alt_brother != null) {
          val_arr.push(obj.alt_brother);
        }
        if (['text', 'password'].indexOf($(input).attr('type') >= 0)) {
          $(input).val(val_arr[Math.floor(Math.random() * val_arr.length)]);
        }
        if ($(input).attr('type') === 'number') {
          $(input).val(obj.movie_year);
        }
        if ($(input).attr('type') === 'email') {
          $(input).val("" + obj.brother + "@" + (obj.movie_name.toLowerCase().replace(/\s/g, '')) + ".com");
        }
        if ($(input).attr('type') === 'date') {
          return $(input).val("" + obj.movie_year + "-01-01");
        }
      }
    });
  },
  populate_textareas: function() {
    var _this = this;
    return $.each($('textarea'), function(i, input) {
      var obj;
      obj = _this.marx_json[Math.floor(Math.random() * _this.marx_json.length)];
      return $(input).val(obj.body);
    });
  },
  populate_checkboxes: function() {
    var names;
    names = [];
    $.each($('input[type=checkbox]'), function(i, input) {
      if (!(names.indexOf($(input).attr('name')) >= 0)) {
        return names.push($(input).attr('name'));
      }
    });
    return $.each(names, function(i, name) {
      var checked;
      checked = Math.floor(Math.random() * 2) === 1 ? true : false;
      return $("input[name=" + name + "]").attr('checked', checked);
    });
  },
  populate_radios: function() {
    var names;
    names = [];
    $('input[type=radio]').each(function(i, input) {
      if (!(names.indexOf($(input).attr('name')) >= 0)) {
        return names.push($(input).attr('name'));
      }
    });
    return $.each(names, function(i, name) {
      var total;
      total = $("input[name=" + name + "]").length;
      return $("input[name=" + name + "]:eq(" + (Math.floor(Math.random() * total)) + ")").attr('checked', true);
    });
  },
  populate_selects: function() {
    return $('select').each(function(i, select) {
      var $opt, rand, total;
      total = $(select).find('option').length;
      rand = Math.floor(Math.random() * total);
      $opt = $(select).find("option:eq(" + rand + ")");
      if (($opt.attr('value') != null) && $opt.attr('value') !== "") {
        return $opt.attr('selected', true);
      } else {
        return $opt.next('option').attr('selected', true);
      }
    });
  },
  $: function(el) {
    return this.$el.find(el);
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
    return false;
  }
});
