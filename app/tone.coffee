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
    @tones = {}
    @tones.left = new Tone(@audio_context, 'sine', @frequency, @crossfade * 0.1)
    @tones.right = new Tone(@audio_context, 'sawtooth', @frequency, (1 - @crossfade) * 0.1)

  update: (frequency, crossfade) =>
    @frequency = frequency
    @crossfade = crossfade
    @tones.left.update(@frequency, crossfade * 0.1)
    @tones.right.update(@frequency, (1 - crossfade) * 0.1)

  start: (seconds_from_now = 0) =>
    _.each @tones, (tone) ->
      tone.start(seconds_from_now)

  stop: (seconds_from_now = 0) =>
    _.each @tones, (tone) ->
      tone.stop(seconds_from_now)

window.PhoneoPhone = window.PhoneoPhone || {}
PhoneoPhone.Tone = Tone
PhoneoPhone.DualTone = DualTone
