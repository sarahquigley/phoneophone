class Scale
  constructor: (frequencies) ->
    @discrete = false
    @skip = []
    @frequencies = _.sortBy(frequencies)
    @min_frequency = _.min(@frequencies)
    @max_frequency = _.max(@frequencies)

  get_nearest_frequency: (current_frequency) =>
    return current_frequency if !@discrete
    filtered_frequencies = _.reject @frequencies, (frequency, position) ->
      _.includes(@skip, position % 7) || frequency > current_frequency
    _.last(filtered_frequencies)

window.PhoneoPhone = window.PhoneoPhone || {}
PhoneoPhone.Scale = Scale
