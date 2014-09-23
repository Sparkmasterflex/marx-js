window.Marx = () ->
  $.getJSON "http://localhost:9292/json", (data) =>
    @marx_json = data
    @initialize()

$.extend Marx.prototype,
  initialize: () ->
    this.create_controls()

  create_controls: ->
    $('body').append """
      <div class="marx-js-controls">
        <link rel="stylesheet" href="http://localhost:9292/assets/application.css">
        <div class="marx-form-controls">
          <h4>Populate Form Fields</h4>
          <div class="marx-js-group">
            <p>Populate all inputs, textareas, check boxes, radio buttons and select boxes</p>
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
        <a href="#open-controls" class="open-controls">MarxJS</a>
      </div>
    """
    this.$el = $('.marx-js-controls')
    this.$el.addClass 'marx-js-collapsed'
    this.$('a.open-controls').click (e) => @toggle_controls(e)
    this.$('.marx-js-group a').click (e) => @popluate_selected_fields(e)


  populate_inputs: ->
    $.each $('input'), (i, input) =>
      unless $(input).val() isnt ""
        obj = @marx_json[Math.floor(Math.random() * @marx_json.length)]
        val_arr = [obj.brother, obj.movie_name]
        val_arr.push obj.alt_brother if obj.alt_brother?
        $(input).val val_arr[Math.floor(Math.random() * val_arr.length)] if ['text', 'password'].indexOf $(input).attr('type') >= 0
        $(input).val obj.movie_year if $(input).attr('type') is 'number'
        $(input).val "#{obj.brother}@#{obj.movie_name.toLowerCase().replace(/\s/g, '')}.com" if $(input).attr('type') is 'email'
        $(input).val "#{obj.movie_year}-01-01" if $(input).attr('type') is 'date'

  populate_textareas: ->
    $.each $('textarea'), (i, input) =>
      obj = @marx_json[Math.floor(Math.random() * @marx_json.length)]
      $(input).val obj.body


  populate_checkboxes: ->
    names = []
    $.each $('input[type=checkbox]'), (i, input) ->
      names.push $(input).attr('name') unless names.indexOf($(input).attr('name')) >= 0
    $.each names, (i, name) ->
      checked = if Math.floor(Math.random() * 2) is 1 then true else false
      $("input[name=#{name}]").attr('checked', checked)


  populate_radios: ->
    names = []
    $('input[type=radio]').each (i, input) -> names.push $(input).attr('name') unless names.indexOf($(input).attr('name')) >= 0
    $.each names, (i, name) ->
      total = $("input[name=#{name}]").length
      $("input[name=#{name}]:eq(#{Math.floor(Math.random() * total)})").attr('checked', true)


  populate_selects: ->
    $('select').each (i, select) ->
      total = $(select).find('option').length
      rand = Math.floor(Math.random() * total)
      $opt = $(select).find("option:eq(#{rand})")
      if $opt.attr('value')? and $opt.attr('value') isnt ""
        $opt.attr('selected', true)
      else
        $opt.next('option').attr('selected', true)


  $: (el) ->
    this.$el.find(el)


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

    false
