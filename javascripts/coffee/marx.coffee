###
  moment.js
  version : 1.0.1
  authors : Keith Raymond, Marx.js contributor
  license : MIT
  marxjs.com
###
window.Marx = (options) ->
  this._url = "http://marxjs.com"
  $.getJSON "#{this._url}/characters", (data) =>
    @marx_json = data
    @initialize(options)

$.extend Marx.prototype,
  settings:
    controls: 'standard'
    position: 'bottom-right'
    form: ""
    ipsum: 3
    max_ipsum: 10

  effected:
    inputs: 0
    texareas: 0
    selects: 0
    check_boxes: 0
    radio_buttons: 0
    hidden_fields: 0

  initialize: (options) ->
    $.extend this.settings, options
    this.create_controls()


  ###=========================
        BUILD CONTROLS
  =========================###
  create_controls: ->
    $('body').append """
      <div class="marx-js-controls marx-#{this.settings.position}">
        <link rel="stylesheet" href="#{this._url}/marx.css">
      </div>
    """
    this.$el = $('.marx-js-controls')
    open_controls = if this.settings.controls isnt 'toggle-all' then "<a href='#open-controls' class='open-controls'>Marx.js</a>"
    else
      """
        <div class="open-controls">
          <a href="#advanced-controls" class="advanced-controls" title="Show Advanced Controls">Advanced Controls</a>
          <a href="#standard-controls" class="standard-controls" title="Show Standard Controls">Standard Controls</a>
          <a href="#populate-whole-form" class="quick-populate" title="Populate Whole Form">Marx.js</a>
        </div>
      """
    this.$el.append open_controls
    this.$el.addClass 'marx-js-collapsed'
    switch this.settings.controls
      when 'standard'
        this.add_standard_controls()
        this.$('a.open-controls').click (e) => @toggle_controls(e)
      when 'advanced', 'toggle-advanced'
        this.add_standard_controls()
        this.add_advanced_controls()
        this.$('a.open-controls').click (e) => @toggle_controls(e)
      when 'minimum'
        this.$('a.open-controls').click (e) => @populate_whole_form(e)
      when 'toggle-all'
        this.add_standard_controls()
        this.add_advanced_controls()
        this.$('a.standard-controls').click (e) =>
          $('p.marx-notification').remove()
          @$('.marx-standard-controls').toggle()
          @$('.marx-advanced-controls').hide()
          false
        this.$('a.advanced-controls').click (e) =>
          $('p.marx-notification').remove()
          @$('.marx-advanced-controls').toggle()
          @$('.marx-standard-controls').hide()
          false

        this.$('a.quick-populate').click (e) =>
          @$('.marx-standard-controls').hide()
          @$('.marx-advanced-controls').hide()
          @populate_whole_form(e)

  $: (el) -> this.$el.find(el)

  add_standard_controls: ->
    standard = """
      <div class="marx-standard-controls">
        <h4>Populate Form Fields</h4>
      </div>
    """
    this.$('.open-controls').before standard
    $('.marx-standard-controls').append this.build_action action for action in [
      ['populate-whole-form', 'Populate Whole Form'],
      ['populate-textareas', 'Populate TextAreas'],
      ['populate-inputs', 'Populate Inputs'],
      ['populate-checkboxes', 'Populate Check Boxes'],
      ['populate-radios', 'Populate Radio Buttons'],
      ['populate-selects', 'Populate Select Boxes']
    ]
    this.$('.marx-standard-controls a').click (e) => @popluate_selected_fields(e)

  add_advanced_controls: ->
    advanced = """
      <div class="marx-advanced-controls">
        <h4>Advanced Options</h4>
      </div>
    """
    this.$('.open-controls').before advanced
    $('.marx-advanced-controls').append this.build_action action for action in [
      ['clear-form', 'Clear Form'],
      ['populate-submit', 'Populate and Submit'],
      ['show-hidden', '<span data-text="Hide">Show</span> Hidden Fields'],
      ['expand-select', '<span data-text="Collapse">Expand</span> Select Boxes'],
      ['random-image', 'Download Random Image'],
      ['generate-ipsum', "Generate Ipsum <p class='ipsum'><input type='number' value='#{this.settings.ipsum}' max=''#{this.settings.max_ipsum}' /> Paragraphs</p>"]
    ]
    this.set_toggle_advanced() if this.settings.controls is 'toggle-advanced'
    this.$('.marx-advanced-controls a').click (e) => @advanced_actions(e)

  build_action: (action) ->
    """
      <div class="marx-js-group">
        <a href="##{action[0]}" class="#{action[0]}">Go</a>
        <p>#{action[1]}</p>
      </div>
    """

  set_toggle_advanced: ->
    this.$('.marx-advanced-controls').hide()
    this.$('.marx-standard-controls').append "<a href='#advanced' class='marx-toggle-advanced'>&laquo; Advanced</a>"
    this.$('a.marx-toggle-advanced').click (e) => @toggle_advanced $(e.target)



  ###=========================
      POPULATE FORM METHODS
  =========================###
  populate_whole_form: (e) ->
    this.populate_inputs()
    this.populate_textareas()
    this.populate_checkboxes()
    this.populate_radios()
    this.populate_selects()
    false

  populate_inputs: ->
    @effected.inputs = 0
    $.each $("#{this.settings.form} input"), (i, input) =>
      unless $(input).val() isnt "" or $(input).hasClass 'no-populate'
        obj = this.get_random()
        brother = JSON.parse(obj.brother)
        movie = JSON.parse(obj.movie)
        strings = [brother.name, movie.name, obj.first_name, obj.last_name, obj.description].filter () -> true
        value = switch $(input).attr('type')
          when 'number' then movie.year
          when 'email' then "#{brother.name.toLowerCase().replace(/\s/g, '')}@#{movie.name.toLowerCase().replace(/\s/g, '')}.com"
          when 'url' then "http://#{movie.name.toLowerCase().replace(/\s/g, '')}.com"
          when 'date'
            rand = Math.random()
            year = movie.year.toString()
            "#{year}-0#{year.substr(Math.floor(rand*4), 1)}-2#{year.substr(Math.floor(rand*4), 1)}"
          else
            str = strings[Math.floor(Math.random() * strings.length)]
            if !str? or str is "" then "Marx" else str
        this.show_password($(input), value) if $(input).attr('type') is 'password'

        if ['checkbox', 'radio', 'hidden'].indexOf $(input).attr('type') < 0
          $(input)
            .attr('data-marx-d', true)
            .val(value)
            .trigger('change')
            .trigger 'blur'
          @effected.inputs += 1

  show_password: ($input, password) ->
    $input.after "<p class='marx-password-note'>Password: #{password}</p>"


  populate_textareas: ->
    this.effected.textareas = 0
    $.getJSON "#{this._url}/quotes", (data) =>
      $.each $("#{this.settings.form} textarea"), (i, input) =>
        @effected.textareas += 1
        $(input)
          .attr('data-marx-d', true)
          .val(data[Math.floor(Math.random() * data.length)].body)
          .trigger('change').trigger('blur')


  populate_checkboxes: ->
    this.effected.check_boxes = 0
    names = []
    $.each $("#{this.settings.form} input[type=checkbox]"), (i, input) ->
      names.push $(input).attr('name') unless names.indexOf($(input).attr('name')) >= 0
    $.each names, (i, name) =>
      checked = if Math.floor(Math.random() * 2) is 1 then true else false
      clean_name = name.replace(/\[/g, '\\[').replace(/\]/g, '\\]')
      $("#{this.settings.form} input[name=#{clean_name}]")
        .attr('data-marx-d', true)
        .attr('checked', checked)
        .trigger('change').trigger('blur')
      @effected.check_boxes += 1 if checked



  populate_radios: ->
    this.effected.radio_buttons = 0
    names = []
    $("#{this.settings.form} input[type=radio]").each (i, input) -> names.push $(input).attr('name') unless names.indexOf($(input).attr('name')) >= 0
    $.each names, (i, name) =>
      clean_name = name.replace(/\[/g, '\\[').replace(/\]/g, '\\]')
      total = $("#{this.settings.form} input[name=#{clean_name}]").length
      $("#{this.settings.form} input[name=#{name}]:eq(#{Math.floor(Math.random() * total)})")
        .attr('data-marx-d', true)
        .attr('checked', true)
        .trigger('change').trigger('blur')
      @effected.radio_buttons += 1


  populate_selects: ->
    this.effected.selects = 0
    $("#{this.settings.form} select").each (i, select) =>
      @effected.selects += 1
      total = $(select).attr('data-marx-d', true).find('option').length
      rand = Math.floor(Math.random() * total)
      $opt = $(select).find("option:eq(#{rand})")
      if $opt.attr('value')? and $opt.attr('value') isnt ""
        $opt.attr('selected', true)
      else
        $opt.next('option').attr('selected', true)
      $(select).trigger('change').trigger('blur')

  toggle_hidden_fields: ->
    this.effected.hidden_fields = 0
    $("#{this.settings.form} input[data-marx-hidden=true]").each (i, input) =>
      type = if $(input).attr('type') is 'hidden' then 'text' else 'hidden'
      $(input).attr('type', type)
      @effected.hidden_fields += 1

    $("#{this.settings.form} input[type=hidden]").each (i, hidden) =>
      unless $(hidden).data('marx-d')?
        @effected.hidden_fields += 1
        $(hidden)
          .attr('type', 'text')
          .attr('data-marx-d', true)
          .attr('data-marx-hidden', true)


  trigger_notifications: ->
    num = 0
    $.each this.effected, (key, val) =>
      unless val is 0
        el = key.replace(/_/, ' ')
        $note = $("<p class='marx-notification'>#{val} #{el} elements were altered</p>")
        @$el.append $note
        $note
          .css('top', "#{20 + (num*50)}px")
          .delay(5000 + (num*50))
          .slideUp 'fast', -> $note.remove()
        num += 1
        @effected[key] = 0

  toggle_description: ($link) ->
    $parent = $link.parent('.marx-js-group')
    $span = $parent.find('p span')
    to = $span.data('text')
    from = $span.text()
    $span
      .text(to)
      .data('text', from)

  generate_ipsum: () ->
    $('.marx-generated-ipsum').remove()
    num = this.$('.ipsum input').val()
    $ipsum = $("""
      <div class='marx-generated-ipsum marx-#{this.settings.position}'>
        <h4>Marx Ipsum</h4>
        <a href='#close' class='marx-ipsum-close'>X</a>
        <div class='marx-container'></div>
      </div>
    """)
    $('body').append $ipsum
    $.getJSON "#{this._url}/monologues", (data) =>
      max = if num > data.length then data.length-1 else num
      monologues = data.sort () -> 0.5 - Math.random()
      for i in [1..max]
        $ipsum.find('.marx-container').append "<p>#{monologues[i].body}</p>"
      $('a.marx-ipsum-close').click (e) ->
        $('.marx-generated-ipsum').slideUp 'fast'
        false

  get_random: () -> @marx_json[Math.floor(Math.random() * @marx_json.length)]



  ###=====================
           EVENTS
  =====================###
  toggle_controls: (e) ->
    $('p.marx-notification').remove()
    this.$el.toggleClass 'marx-js-collapsed'
    if this.settings.controls is 'toggle-advanced' and this.$el.hasClass 'marx-js-collapsed'
      this.toggle_advanced $('a.marx-toggle-advanced') if $('.marx-advanced-controls').is(':visible')
    false

  toggle_advanced: ($link) ->
    txt = if $link.hasClass('opened') then "&laquo; Advanced" else "Close &raquo;"
    $link
      .toggleClass('opened')
      .html(txt)
    this.$('.marx-advanced-controls').toggle()
    false

  popluate_selected_fields: (e) ->
    switch $(e.target).attr('class')
      when 'populate-textareas'
        this.populate_textareas()
      when 'populate-inputs'
        this.populate_inputs()
      when 'populate-checkboxes'
        this.populate_checkboxes()
      when 'populate-radios'
        this.populate_radios()
      when 'populate-selects'
        this.populate_selects()
      else
        this.populate_whole_form()

    this.trigger_notifications()
    false

  advanced_actions: (e) ->
    switch $(e.target).attr('class')
      when 'clear-form'
        $('input[data-marx-d=true], textarea[data-marx-d=true]').val ""
        $('input[type=checkbox], input[type=radio]').each (i, cb) -> $(cb).removeAttr('checked') if $(cb).data('marx-d')? is $(cb).data('marx-d') and true
        $('select[data-marx-d=true] option:eq(0)').attr('selected', true)
      when 'populate-submit'
        $.when(this.populate_whole_form()).then ->
          $(e.target).replaceWith "<span class='spinner'>Loading</span>"
          setTimeout () ->
            $('form').submit()
          , 500
      when 'show-hidden'
        this.toggle_description $(e.target)
        $.when(this.toggle_hidden_fields()).then => @trigger_notifications()
      when 'expand-select'
        this.toggle_description $(e.target)
        $('select').each (i, select) =>
          if $(select).attr('size')?
            $(select).removeAttr('size')
          else
            $(select).attr('size', $(select).find('option').length)
      when 'random-image'
        window.location = "#{this._url}/get-image"
      when 'generate-ipsum' then this.generate_ipsum()

    false
