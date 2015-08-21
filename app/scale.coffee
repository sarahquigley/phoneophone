class Scale
  constructor: (frequencies, @frequencies_per_octave = 7) ->
    @discrete = false
    @skip = [] # skipped (disabled) positions in every octave
    @frequencies = _.sortBy(frequencies)

  # @param {Number} value - a floating point number between 0 and 1
  get_active_frequency: (value) =>
    frequency = @_convert_to_frequency(value)
    return frequency if !@discrete
    filtered_frequencies = _.reject @_active_frequencies(), (current_frequency, position) ->
      current_frequency > frequency
    , @
    _.last(filtered_frequencies)

  #Private Methods
  # @param {Number} value - a floating point number between 0 and 1
  _convert_to_frequency: (value) =>
    (value * (@_max_frequency() - @_min_frequency())) + @_min_frequency()

  _active_frequencies: () ->
    active_frequencies = _.reject @frequencies, (frequency, position) ->
      _.includes(@skip, position % @frequencies_per_octave)
    , @
    active_frequencies = [_.first(@frequencies)] if _.isEmpty(active_frequencies)
    active_frequencies

  _min_frequency: () ->
    _.first(@_active_frequencies())

  _max_frequency: () ->
    _.last(@_active_frequencies())


class ContinuousScale
  constructor: (frequencies) ->
    @min_frequency = _.min(frequencies)
    @max_frequency = _.max(frequencies)

  get_active_frequency: (value) ->
    @min_frequency + value * (@max_frequency - @min_frequency)


class DiscreteScale
  constructor: (frequencies, skip_positions, frequencies_per_octave = 7) ->
    @frequencies = @_skip_frequencies(_.sortBy(frequencies), skip_positions, frequencies_per_octave)
    @min_frequency = _.first(frequencies)
    @max_frequency = _.last(frequencies)

  get_active_frequency: (value) ->
    continuous_freq = @min_frequency + value * (@max_frequency - @min_frequency)

    _.chain(@frequencies)
      .reject((freq) -> freq > continuous_freq)
      .last()
      .result()

  _skip_frequencies: (frequencies, skip_positions, frequencies_per_octave) ->
    _.reject frequencies, (frequency, position) =>
      _.includes(skip_positions, position % frequencies_per_octave)

window.PhoneoPhone = window.PhoneoPhone || {}
PhoneoPhone.Scale = Scale
