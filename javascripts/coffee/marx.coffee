window.Marx = (options) ->
  $.getJSON "http://localhost:9292/quotes", (data) =>
    @marx_json = data
    @initialize(options)

$.extend Marx.prototype,
  settings:
    controls: 'standard'
    position: 'bottom-right'

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
      <div class="marx-js-controls">
        <link rel="stylesheet" href="http://localhost:9292/marx.css">
        <a href="#open-controls" class="open-controls">MarxJS</a>
      </div>
    """
    this.$el = $('.marx-js-controls')
    this.$el.addClass 'marx-js-collapsed'
    switch this.settings.controls
      when 'standard'
        this.add_standard_controls()
        this.$('a.open-controls').click (e) => @toggle_controls(e)
      when 'advanced'
        this.add_standard_controls()
        this.add_advanced_controls()
        this.$('a.open-controls').click (e) => @toggle_controls(e)
      when 'minimum'
        this.$('a.open-controls').click (e) =>
          this.populate_inputs()
          this.populate_textareas()
          this.populate_checkboxes()
          this.populate_radios()
          this.populate_selects()

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
    this.$('a.open-controls').before standard
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
            <input min="1" max="10" type="number" value='3' class="no-populate" name="ipsum" /> Paragraphs
          </p>
          <a href="#generate-ipsum" class="generate-ipsum">Go</a>
        </div>
      </div>
    """
    this.$('a.open-controls').before advanced
    this.$('.marx-advanced-controls a').click (e) => @advanced_actions(e)


  ###=========================
      POPULATE FORM METHODS
  =========================###
  populate_inputs: ->
    @effected.inputs = 0
    $.each $('input'), (i, input) =>
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
    $.each $('textarea'), (i, input) =>
      @effected.textareas += 1
      obj = @marx_json[Math.floor(Math.random() * @marx_json.length)]
      $(input).attr('data-marx-d', true).val obj.body


  populate_checkboxes: ->
    this.effected.check_boxes = 0
    names = []
    $.each $('input[type=checkbox]'), (i, input) ->
      names.push $(input).attr('name') unless names.indexOf($(input).attr('name')) >= 0
    $.each names, (i, name) =>
      checked = if Math.floor(Math.random() * 2) is 1 then true else false
      $("input[name=#{name}]").attr('data-marx-d', true).attr('checked', checked)
      @effected.check_boxes += 1 if checked



  populate_radios: ->
    this.effected.radio_buttons = 0
    names = []
    $('input[type=radio]').each (i, input) -> names.push $(input).attr('name') unless names.indexOf($(input).attr('name')) >= 0
    $.each names, (i, name) =>
      total = $("input[name=#{name}]").length
      $("input[name=#{name}]:eq(#{Math.floor(Math.random() * total)})").attr('data-marx-d', true).attr('checked', true)
      @effected.radio_buttons += 1


  populate_selects: ->
    this.effected.selects = 0
    $('select').each (i, select) =>
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
    $('input[data-marx-hidden=true]').each (i, input) =>
      type = if $(input).attr('type') is 'hidden' then 'text' else 'hidden'
      $(input).attr('type', type)
      @effected.hidden_fields += 1

    $('input[type=hidden]').each (i, hidden) =>
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
          .delay(2000 + (num*50))
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
      <div class='marx-generated-ipsum'>
        <h4>Marx Ipsum</h4>
        <a href='#close' class='marx-ipsum-close'>X</a>
        <div class='container'></div>
      </div>
    """)
    $('body').append $ipsum
    $.getJSON "http://localhost:9292/monologues", (data) =>
      data.sort () -> 0.5 - Math.random()
      for i in [1..num]
        $ipsum.find('.container').append "<p>#{data[i].body}</p>"
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
        this.populate_inputs()
        this.populate_textareas()
        this.populate_checkboxes()
        this.populate_radios()
        this.populate_selects()
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
