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
  constructor: (@audio_context, @frequency, @crossfade = 0.5, @gain_value_scaling_factor = 0.1) ->
    @left = new Tone(@audio_context, 'sine', @frequency, @_gain_value(@crossfade, 'left'))
    @right = new Tone(@audio_context, 'sawtooth', @frequency, @_gain_value(@crossfade))

  update: (frequency, crossfade) =>
    @frequency = frequency
    @crossfade = crossfade
    @left.update(@frequency, @_gain_value(crossfade, 'left'))
    @right.update(@frequency, @_gain_value(crossfade))

  start: (seconds_from_now = 0) =>
    _.each [@left, @right], (tone) ->
      tone.start(seconds_from_now)

  stop: (seconds_from_now = 0) =>
    _.each [@left, @right], (tone) ->
      tone.stop(seconds_from_now)

  # Private methods
  _gain_value: (crossfade, position) =>
    if position == 'left'
      return (1 - crossfade) * @gain_value_scaling_factor
    crossfade * @gain_value_scaling_factor

window.PhoneoPhone = window.PhoneoPhone || {}
PhoneoPhone.Tone = Tone
PhoneoPhone.DualTone = DualTone
