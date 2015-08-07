class DualTone
  constructor: (@audio_context, @frequency, @crossfade = 0.5) ->
    @left = @_create_tone('sine', @frequency, @crossfade * 0.1)
    @right = @_create_tone('sawtooth', @frequency, (1 - @crossfade) * 0.1)
    @start()

  update_tones: (frequency, crossfade) =>
    @frequency = frequency
    @crossfade = crossfade
    @_update_tone(@left, @frequency, crossfade * 0.1)
    @_update_tone(@right, @frequency, (1 - crossfade) * 0.1)

  start: () =>
    _.each [@left, @right], (tone) ->
      tone.oscillator.start(0)

  stop: () =>
    _.each [@left, @right], (tone) ->
      tone.oscillator.stop(0)

  _update_tone: (tone, frequency, gain) =>
    tone.oscillator.frequency.value = frequency
    tone.gain.gain.value = gain

  _create_tone: (type, frequency, gain) =>
    tone = {}
    tone.oscillator = @_create_oscillator(type, frequency)
    tone.gain = @_create_gain_for_oscillator(tone.oscillator, gain)
    tone

  _create_oscillator: (type, frequency) =>
    oscillatorNode = @audio_context.createOscillator()
    oscillatorNode.type = type
    oscillatorNode.frequency.value = frequency
    oscillatorNode

  _create_gain_for_oscillator: (oscillator, gain) =>
    gainNode = @audio_context.createGain()
    gainNode.gain.value = gain
    gainNode.connect(@audio_context.destination)
    oscillator.connect(gainNode)
    gainNode

class AudioSpace
  constructor: (@min_frequency = 500, @max_frequency = 1500) ->
    AudioContext = window.AudioContext || window.webkitAudioContext
    @audio_context = new AudioContext()
    @tones = {}

  add_dual_tone: (id, position) =>
    frequency =  @_frequency_at_y(position.y)
    crossfade =  @_crossfade_at_x(position.x)
    @tones[id] = new DualTone(@audio_context, frequency, crossfade)

  _frequency_at_y: (y) =>
    y * window.innerHeight / (@max_frequency - @min_frequency)

  _crossfade_at_x: (x) =>
    x * window.innerWidth
