class Scale
  constructor: (frequencies, @frequencies_per_octave = 7) ->
    @discrete = false
    @skip = [] # skipped (disabled) positions in every octave
    @frequencies = _.sortBy(frequencies)

  min_frequency: () ->
    _.first(@_active_frequencies())

  max_frequency: () ->
    _.last(@_active_frequencies())

  get_nearest_frequency: (current_frequency) =>
    return @min_frequency() if current_frequency < @min_frequency()
    return @max_frequency() if current_frequency > @max_frequency()
    return current_frequency if !@discrete
    filtered_frequencies = _.reject @_active_frequencies(), (frequency, position) ->
      frequency > current_frequency
    , @
    _.last(filtered_frequencies)

  #Private Methods
  _active_frequencies: () ->
    active_frequencies = _.reject @frequencies, (frequency, position) ->
      _.includes(@skip, position % @frequencies_per_octave)
    , @
    active_frequencies = [_.first(@frequencies)] if _.isEmpty(active_frequencies)
    active_frequencies

window.PhoneoPhone = window.PhoneoPhone || {}
PhoneoPhone.Scale = Scale
