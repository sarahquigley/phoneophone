# Enables control over a set of DualTone objects via mouse and/or touch interactions
class AudioSpace
  constructor: (@el, frequencies) ->
    AudioContext = window.AudioContext || window.webkitAudioContext
    @scale = new PhoneoPhone.Scale(frequencies)
    @audio_context = new AudioContext()
    @dual_tones = {}
    @add_controls()

  add_dual_tone: (dual_tone_id, frequency, crossfade) =>
    @dual_tones[dual_tone_id] = new PhoneoPhone.DualTone(@audio_context, frequency, crossfade)

  update_dual_tone: (dual_tone_id, frequency, crossfade) =>
    if _.isObject(@dual_tones[dual_tone_id])
      @dual_tones[dual_tone_id].update(frequency, crossfade)

  delete_dual_tone: (dual_tone_id) =>
    if _.isObject(@dual_tones[dual_tone_id])
      delete @dual_tones[dual_tone_id]

  add_controls: () ->
    @add_mouse_control()
    @add_touch_control()
    @add_deviceorientation_control()

  add_mouse_control: (dual_tone_id, start_event, change_event, stop_event) =>
    self = @
    dual_tone_id = 'mouse'
    @el.addEventListener 'mousedown', (event) ->
      event.preventDefault()
      self.on_start_event(event, dual_tone_id)
    @el.addEventListener 'mousemove', (event) ->
      event.preventDefault()
      self.on_change_event(event, dual_tone_id)
    @el.addEventListener 'mouseup', (event) ->
      event.preventDefault()
      self.on_stop_event(event, dual_tone_id)

  add_touch_control: () =>
    self = @
    @el.addEventListener 'touchstart', (event) ->
      event.preventDefault()
      _.each event.changedTouches, (touch) ->
        self.on_start_event(touch, touch.identifier)

    @el.addEventListener 'touchmove', (event) ->
      event.preventDefault()
      _.each event.changedTouches, (touch) ->
        self.on_change_event(touch, touch.identifier)

    @el.addEventListener 'touchend', (event) ->
      event.preventDefault()
      _.each event.changedTouches, (touch) ->
        self.on_stop_event(touch, touch.identifier)

  add_deviceorientation_control: () =>
    self = @
    window.addEventListener 'deviceorientation', (event) ->
      beta = Math.abs(event.beta)
      self.scale.discrete = beta >= 30 && beta <= 150
      self.scale.skip = [] if beta < 60 || beta > 120
      self.scale.skip = [2, 6] if beta >= 60 && beta <= 120

  on_start_event: (event, dual_tone_id) =>
    frequency =  @frequency_at_y(event.clientY)
    crossfade =  @crossfade_at_x(event.clientX)
    @add_dual_tone(dual_tone_id, frequency, crossfade)
    @start_tone(dual_tone_id)

  on_change_event: (event, dual_tone_id) =>
    frequency =  @frequency_at_y(event.clientY)
    crossfade =  @crossfade_at_x(event.clientX)
    @update_dual_tone(dual_tone_id, frequency, crossfade)

  on_stop_event: (event, dual_tone_id) =>
    @stop_tone(dual_tone_id)
    @delete_dual_tone(dual_tone_id)

  start_tone: (dual_tone_id) =>
    if _.isObject(@dual_tones[dual_tone_id])
      @dual_tones[dual_tone_id].start()

  stop_tone: (dual_tone_id) =>
    if _.isObject(@dual_tones[dual_tone_id])
      @dual_tones[dual_tone_id].stop()

  frequency_at_y: (y) =>
    @scale.get_active_frequency(y / @el.clientHeight)

  crossfade_at_x: (x) =>
    x / @el.clientWidth

window.PhoneoPhone = window.PhoneoPhone || {}
PhoneoPhone.AudioSpace = AudioSpace
