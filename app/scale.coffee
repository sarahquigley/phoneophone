class ContinuousScale
  constructor: (frequencies) ->
    @min_frequency = _.min(frequencies)
    @max_frequency = _.max(frequencies)

  get_active_frequency: (value) ->
    @min_frequency + value * (@max_frequency - @min_frequency)


class DiscreteScale
  constructor: (frequencies, skip_positions=[], frequencies_per_octave = 7) ->
    @frequencies = @_skip_frequencies(_.sortBy(frequencies), skip_positions, frequencies_per_octave)
    @min_frequency = _.first(@frequencies)
    @max_frequency = _.last(@frequencies)

  get_active_frequency: (value) ->
    continuous_freq = @min_frequency + value * (@max_frequency - @min_frequency)

    _.chain(@frequencies)
      .reject((freq) -> freq > continuous_freq)
      .last()
      .value()

  _skip_frequencies: (frequencies, skip_positions, frequencies_per_octave) ->
    _.reject frequencies, (frequency, position) =>
      _.includes(skip_positions, position % frequencies_per_octave)

window.PhoneoPhone = window.PhoneoPhone || {}
PhoneoPhone.ContinuousScale = ContinuousScale
PhoneoPhone.DiscreteScale = DiscreteScale
