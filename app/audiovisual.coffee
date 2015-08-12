class Wave
  constructor: (@id, frequency, gain_value, @type, @yAxis) ->
    @timeModifier = 1
    @lineWidth = 3
    @amplitude = @_amplitude_from_gain_value(gain_value)
    @wavelength = @_wavelength_from_frequency(frequency)
    @segmentLength = 1
    @strokeStyle = @_stroke_style_from_frequency_and_gain_value(frequency, gain_value)

  update: (frequency, gain_value, yAxis) =>
    @amplitude = @_amplitude_from_gain_value(gain_value)
    @wavelength = @_wavelength_from_frequency(frequency)
    @strokeStyle = @_stroke_style_from_frequency_and_gain_value(frequency, gain_value)
    @yAxis = yAxis

  # Private methods
  _wavelength_from_frequency: (frequency) =>
    (1 / frequency) * 1000 * 2

  _amplitude_from_gain_value: (gain_value) =>
    gain_value * 1000

  _stroke_style_from_frequency_and_gain_value: (frequency, gain_value) =>
    'rgba(255, 255, 255, 0.5)'

class RenderedWaves extends SineWaves

  add_wave: (wave_id, frequency, gain_value, type, yAxis) =>
    if _.any(@waves, (wave) -> wave.id == wave_id)
      throw  new Error("Wave of id #{wave_id} already exists")
    wave = new Wave(wave_id, frequency, gain_value, type, yAxis)
    @waves.push(wave)
    @setupWaveFns()
    wave

  update_wave: (wave_id, frequency, gain_value, yAxis) =>
    wave = _.find(@waves, {id: wave_id})
    if _.isObject(wave)
      wave.update(frequency, gain_value, yAxis)

  delete_wave: (wave_id) =>
    @waves = _.reject @waves, (wave) ->
      wave.id == wave_id

window.PhoneoPhone = window.PhoneoPhone || {}
PhoneoPhone.Wave = Wave
PhoneoPhone.RenderedWaves = RenderedWaves
