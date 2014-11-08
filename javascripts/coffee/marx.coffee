window.Marx = (options) ->
  $.getJSON "http://marxjs.sparkmasterflex.com:9292/quotes", (data) =>
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
      <div class="marx-js-controls #{this.settings.position}">
        <link rel="stylesheet" href="http://marxjs.sparkmasterflex.com:9292/marx.css">
      </div>
    """
    this.$el = $('.marx-js-controls')
    open_controls = if this.settings.controls isnt 'toggle-all' then "<a href='#open-controls' class='open-controls'>MarxJS</a>"
    else
      """
        <div class="open-controls">
          <a href="#advanced-controls" class="advanced-controls" title="Show Advanced Controls">Advanced Controls</a>
          <a href="#standard-controls" class="standard-controls" title="Show Standard Controls">Standard Controls</a>
          <a href="#populate-whole-form" class="populate-whole-form" title="Populate Whole Form">MarxJS</a>
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
          @$('.marx-standard-controls').toggle()
          @$('.marx-advanced-controls').hide()
          false
        this.$('a.advanced-controls').click (e) =>
          @$('.marx-advanced-controls').toggle()
          @$('.marx-standard-controls').hide()
          false

        this.$('a.populate-whole-form').click (e) =>
          @$('.marx-standard-controls').hide()
          @$('.marx-advanced-controls').hide()
          @populate_whole_form(e)

  $: (el) -> this.$el.find(el)

  add_standard_controls: ->
    standard = """
      <div class="marx-standard-controls">
        <h4>Populate Form Fields</h4>
        <div class="marx-js-group">
          <p>Populate whole form</p>
          <a class='populate-whole-form' href="#populate-whole-form">Go</a>
        </div>
        <div class="marx-js-group">
          <p>Populate TextAreas</p>
          <a href="#populate-textareas" class="populate-textareas">Go</a>
        </div>
        <div class="marx-js-group">
          <p>Populate Inputs</p>
          <a href="#populate-inputs" class="populate-inputs">Go</a>
        </div>
        <div class="marx-js-group">
          <p>Populate Check Boxes</p>
          <a href="#populate-checkboxes" class="populate-checkboxes">Go</a>
        </div>
        <div class="marx-js-group">
          <p>Populate Radio Buttons</p>
          <a href="#populate-radios" class="populate-radios">Go</a>
        </div>
        <div class="marx-js-group">
          <p>Populate Select Boxes</p>
          <a href="#populate-selects" class="populate-selects">Go</a>
        </div>
      </div>
    """
    this.$('.open-controls').before standard
    this.$('.marx-standard-controls a').click (e) => @popluate_selected_fields(e)

  add_advanced_controls: ->
    advanced = """
      <div class="marx-advanced-controls">
        <h4>Advanced Options</h4>
        <div class="marx-js-group">
          <p>Clear Form</p>
          <a href="#clear-form" class="clear-form">Go</a>
        </div>
        <div class="marx-js-group">
          <p>Populate and Submit</p>
          <a href="#populate-submit" class="populate-submit">Go</a>
        </div>
        <div class="marx-js-group">
          <p><span data-text="Hide">Show</span> Hidden Fields</p>
          <a href="#show-hidden" class="show-hidden">Go</a>
        </div>
        <div class="marx-js-group">
          <p><span data-text="Collapse">Expand</span> Select Boxes</p>
          <a href="#expand-select" class="expand-select">Go</a>
        </div>
        <div class="marx-js-group ipsum">
          <p>Generate Ipsum<br />
            <input min="1" max="#{this.settings.max_ipsum}" type="number" value='#{this.settings.ipsum}' class="no-populate" name="ipsum" /> Paragraphs
          </p>
          <a href="#generate-ipsum" class="generate-ipsum">Go</a>
        </div>
      </div>
    """
    this.$('.open-controls').before advanced
    if this.settings.controls is 'toggle-advanced'
      this.$('.marx-advanced-controls').hide()
      this.$('.marx-standard-controls').append "<a href='#advanced' class='marx-toggle-advanced'>&laquo; Advanced</a>"
      this.$('a.marx-toggle-advanced').click (e) =>
        txt = if $(e.target).hasClass('opened') then "&laquo; Advanced" else "Close &raquo;"
        this.$(e.target)
          .toggleClass('opened')
          .html(txt)
        this.$('.marx-advanced-controls').toggle()
    this.$('.marx-advanced-controls a').click (e) => @advanced_actions(e)


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
        @effected.inputs += 1 if ['checkbox', 'radio', 'hidden'].indexOf $(input).attr('type') < 0
        obj = @marx_json[Math.floor(Math.random() * @marx_json.length)]
        val_arr = [obj.brother, obj.movie_name]
        val_arr.push obj.alt_brother if obj.alt_brother?
        $(input).attr('data-marx-d', true).val val_arr[Math.floor(Math.random() * val_arr.length)] if ['text', 'password'].indexOf $(input).attr('type') >= 0
        $(input).attr('data-marx-d', true).val obj.movie_year if $(input).attr('type') is 'number'
        $(input).attr('data-marx-d', true).val "#{obj.brother}@#{obj.movie_name.toLowerCase().replace(/\s/g, '')}.com" if $(input).attr('type') is 'email'
        $(input).attr('data-marx-d', true).val "#{obj.movie_year}-01-01" if $(input).attr('type') is 'date'

  populate_textareas: ->
    this.effected.textareas = 0
    $.each $("#{this.settings.form} textarea"), (i, input) =>
      @effected.textareas += 1
      obj = @marx_json[Math.floor(Math.random() * @marx_json.length)]
      $(input).attr('data-marx-d', true).val obj.body


  populate_checkboxes: ->
    this.effected.check_boxes = 0
    names = []
    $.each $("#{this.settings.form} input[type=checkbox]"), (i, input) ->
      names.push $(input).attr('name') unless names.indexOf($(input).attr('name')) >= 0
    $.each names, (i, name) =>
      checked = if Math.floor(Math.random() * 2) is 1 then true else false
      $("#{this.settings.form} input[name=#{name}]").attr('data-marx-d', true).attr('checked', checked)
      @effected.check_boxes += 1 if checked



  populate_radios: ->
    this.effected.radio_buttons = 0
    names = []
    $("#{this.settings.form} input[type=radio]").each (i, input) -> names.push $(input).attr('name') unless names.indexOf($(input).attr('name')) >= 0
    $.each names, (i, name) =>
      total = $("#{this.settings.form} input[name=#{name}]").length
      $("#{this.settings.form} input[name=#{name}]:eq(#{Math.floor(Math.random() * total)})").attr('data-marx-d', true).attr('checked', true)
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
      <div class='marx-generated-ipsum #{this.settings.position}'>
        <h4>Marx Ipsum</h4>
        <a href='#close' class='marx-ipsum-close'>X</a>
        <div class='container'></div>
      </div>
    """)
    $('body').append $ipsum
    $.getJSON "http://marxjs.sparkmasterflex.com:9292/monologues", (data) =>
      max = if num > data.length then data.length-1 else num
      console.log "Generated the maximum amount of paragraphs available: #{data.length}"
      monologues = data.sort () -> 0.5 - Math.random()
      for i in [1..max]
        $ipsum.find('.container').append "<p>#{monologues[i].body}</p>"
      $('a.marx-ipsum-close').click (e) ->
        $('.marx-generated-ipsum').slideUp 'fast'
        false



  ###=====================
           EVENTS
  =====================###
  toggle_controls: (e) ->
    this.$el.toggleClass 'marx-js-collapsed'
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
        $.when(
          this.populate_inputs(),
          this.populate_textareas(),
          this.populate_checkboxes(),
          this.populate_radios(),
          this.populate_selects()
        ).then ->
          $(e.target).replace "<span class='spinner'>Loading</span>"
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
      when 'generate-ipsum'
        this.generate_ipsum()

    false
