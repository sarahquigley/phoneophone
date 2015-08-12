# Enables control over a set of DualTone objects via mouse and/or touch interactions
class AudioSpace
  constructor: (@min_frequency = 500, @max_frequency = 1500) ->
    AudioContext = window.AudioContext || window.webkitAudioContext
    @audio_context = new AudioContext()
    @visuals = new PhoneoPhone.RenderedWaves {
      el: document.getElementById('audiospace'),
      wavesWidth: '100%',
      ease: 'linear',
    }
    @dual_tones = {}
    @add_mouse_control()
    @add_touch_control()

  add_dual_tone: (dual_tone_id, position) =>
    frequency =  @_frequency_at_y(position.y)
    crossfade =  @_crossfade_at_x(position.x)
    dual_tone = @dual_tones[dual_tone_id] = new PhoneoPhone.DualTone(@audio_context, frequency, crossfade)

    _.each dual_tone.tones, (tone, tone_key) ->
      wave_id = "#{dual_tone_id}_#{tone_key}"
      @visuals.add_wave(wave_id, tone.frequency, tone.gain_value, dual_tone.type, position.y)
    , @


  update_dual_tone: (dual_tone_id, position) =>
    dual_tone = @dual_tones[dual_tone_id]
    if _.isObject(dual_tone)
      frequency =  @_frequency_at_y(position.y)
      crossfade =  @_crossfade_at_x(position.x)
      dual_tone.update(frequency, crossfade)

      _.each dual_tone.tones, (tone, tone_key) ->
        wave_id = "#{dual_tone_id}_#{tone_key}"
        @visuals.update_wave(wave_id, tone.frequency, tone.gain_value, position.y)
      , @

  delete_dual_tone: (dual_tone_id) =>
    if _.isObject(@dual_tones[dual_tone_id])
      delete @dual_tones[dual_tone_id]

      _.each dual_tone.tones, (tone, tone_key) ->
        wave_id = "#{dual_tone_id}_#{tone_key}"
        @visuals.delete_wave(wave_id)
      , @

  add_mouse_control: (dual_tone_id, start_event, change_event, stop_event) =>
    self = @
    dual_tone_id = 'mouse'
    addEventListener 'mousedown', (event) ->
      event.preventDefault()
      self.on_start_event(event, dual_tone_id)
    addEventListener 'mousemove', (event) ->
      event.preventDefault()
      self.on_change_event(event, dual_tone_id)
    addEventListener 'mouseup', (event) ->
      event.preventDefault()
      self.on_stop_event(event, dual_tone_id)

  add_touch_control: () =>
    self = @
    addEventListener 'touchstart', (event) ->
      event.preventDefault()
      _.each event.changedTouches, (touch) ->
        self.on_start_event(touch, touch.identifier)

    addEventListener 'touchmove', (event) ->
      event.preventDefault()
      _.each event.changedTouches, (touch) ->
        self.on_change_event(touch, touch.identifier)

    addEventListener 'touchend', (event) ->
      event.preventDefault()
      _.each event.changedTouches, (touch) ->
        self.on_stop_event(touch, touch.identifier)

  on_start_event: (event, dual_tone_id) =>
    @add_dual_tone(dual_tone_id, {x: event.clientX, y: event.clientY})
    @start_tone(dual_tone_id)

  on_change_event: (event, dual_tone_id) =>
    @update_dual_tone(dual_tone_id, {x: event.clientX, y: event.clientY})

  on_stop_event: (event, dual_tone_id) =>
    @stop_tone(dual_tone_id)
    @delete_dual_tone(dual_tone_id)

  start_tone: (dual_tone_id) =>
    if _.isObject(@dual_tones[dual_tone_id])
      @dual_tones[dual_tone_id].start()

  stop_tone: (dual_tone_id) =>
    if _.isObject(@dual_tones[dual_tone_id])
      @dual_tones[dual_tone_id].stop()

  # Private methods
  _frequency_at_y: (y) =>
    ((y / window.innerHeight) * (@max_frequency - @min_frequency)) + @min_frequency

  _crossfade_at_x: (x) =>
    x / window.innerWidth

window.PhoneoPhone = window.PhoneoPhone || {}
PhoneoPhone.AudioSpace = AudioSpace
