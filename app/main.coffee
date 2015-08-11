# Represents a single tone (note)
class Tone
  constructor: (@audio_context, @type, @frequency, @gain_value) ->
    @oscillator = @_create_oscillator(@type, @frequency)
    @gain = @_create_gain_for_oscillator(@oscillator, @gain_value)

  update: (frequency, gain_value) =>
    @frequency = frequency
    @gain_value = gain_value
    @oscillator.frequency.value = frequency
    @gain.gain.value = gain_value

  start: (seconds_from_now = 0) =>
    @oscillator.start(seconds_from_now)

  stop: (seconds_from_now = 0) =>
    @oscillator.stop(seconds_from_now)

  # Private methods
  _create_oscillator: (type, frequency) =>
    oscillatorNode = @audio_context.createOscillator()
    oscillatorNode.type = type
    oscillatorNode.frequency.value = frequency
    oscillatorNode

  _create_gain_for_oscillator: (oscillator, gain_value) =>
    gainNode = @audio_context.createGain()
    gainNode.gain.value = gain_value
    gainNode.connect(@audio_context.destination)
    oscillator.connect(gainNode)
    gainNode


# Represents a pair of crossfaded Tone objects of the same frequency
class DualTone
  constructor: (@audio_context, @frequency, @crossfade = 0.5) ->
    @left = new Tone(@audio_context, 'sine', @frequency, @crossfade * 0.1)
    @right = new Tone(@audio_context, 'sawtooth', @frequency, (1 - @crossfade) * 0.1)

  update: (frequency, crossfade) =>
    @frequency = frequency
    @crossfade = crossfade
    @left.update(@frequency, crossfade * 0.1)
    @right.update(@frequency, (1 - crossfade) * 0.1)

  start: (seconds_from_now = 0) =>
    _.each [@left, @right], (tone) ->
      tone.start(seconds_from_now)

  stop: (seconds_from_now = 0) =>
    _.each [@left, @right], (tone) ->
      tone.stop(seconds_from_now)

# Enables control over a set of DualTone objects via mouse and/or touch interactions
class AudioSpace
  constructor: (@min_frequency = 500, @max_frequency = 1500) ->
    AudioContext = window.AudioContext || window.webkitAudioContext
    @audio_context = new AudioContext()
    @dual_tones = {}
    @add_mouse_control()
    @add_touch_control()

  add_dual_tone: (dual_tone_id, position) =>
    frequency =  @_frequency_at_y(position.y)
    crossfade =  @_crossfade_at_x(position.x)
    @dual_tones[dual_tone_id] = new DualTone(@audio_context, frequency, crossfade)

  update_dual_tone: (dual_tone_id, position) =>
    if _.isObject(@dual_tones[dual_tone_id])
      frequency =  @_frequency_at_y(position.y)
      crossfade =  @_crossfade_at_x(position.x)
      @dual_tones[dual_tone_id].update(frequency, crossfade)

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

window.PhoneoPhone = {}
PhoneoPhone.Tone = Tone
PhoneoPhone.DualTone = Tone
PhoneoPhone.AudioSpace = AudioSpace

audio_space = new PhoneoPhone.AudioSpace(50, 1000)
