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

window.PhoneoPhone = window.PhoneoPhone || {}
PhoneoPhone.Scale = Scale
