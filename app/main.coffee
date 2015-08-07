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


class AudioSpace
  constructor: (@min_frequency = 500, @max_frequency = 1500) ->
    AudioContext = window.AudioContext || window.webkitAudioContext
    @audio_context = new AudioContext()
    @tones = {}

  add_dual_tone: (id, position) =>
    frequency =  @_frequency_at_y(position.y)
    crossfade =  @_crossfade_at_x(position.x)
    @tones[id] = new DualTone(@audio_context, frequency, crossfade)

  update_dual_tone: (id, position) =>
    if _.isObject(@tones[id])
      frequency =  @_frequency_at_y(position.y)
      crossfade =  @_crossfade_at_x(position.x)
      @tones[id].update(frequency, crossfade)

  start_tone: (id) =>
    if _.isObject(@tones[id])
      @tones[id].start()

  stop_tone: (id) =>
    if _.isObject(@tones[id])
      @tones[id].stop()

  start_tones: () =>
    _.each @tones, (tone) ->
      tone.start()

  stop_tones: () =>
    _.each @tones, (tone) ->
      tone.stop()

  _frequency_at_y: (y) =>
    ((y / window.innerHeight) * (@max_frequency - @min_frequency)) + @min_frequency

  _crossfade_at_x: (x) =>
    x / window.innerWidth

audio_space = new AudioSpace(50, 1000)

addEventListener 'mousedown', (event) ->
  event.preventDefault()
  audio_space.stop_tone('mouse')
  audio_space.add_dual_tone('mouse', {x: event.clientX, y: event.clientY})
  audio_space.start_tone('mouse')

addEventListener 'mousemove', (event) ->
  event.preventDefault()
  audio_space.update_dual_tone('mouse', {x: event.clientX, y: event.clientY})

addEventListener 'mouseup', (event) ->
  event.preventDefault()
  audio_space.stop_tone('mouse')
