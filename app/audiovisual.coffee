class Wave
  constructor: (@id, frequency, gain_value, @type, @yAxis, min_frequency, max_frequency) ->
    @timeModifier = 2
    @lineWidth = 3
    @amplitude = @_amplitude_from_gain_value(gain_value)
    @wavelength = @_wavelength_from_frequency(frequency)
    @segmentLength = 1
    @strokeStyle = @_stroke_style_from_frequency_and_gain_value(frequency, gain_value, min_frequency, max_frequency)

  update: (frequency, gain_value, yAxis, min_frequency, max_frequency) =>
    @amplitude = @_amplitude_from_gain_value(gain_value)
    @wavelength = @_wavelength_from_frequency(frequency)
    @strokeStyle = @_stroke_style_from_frequency_and_gain_value(frequency, gain_value, min_frequency, max_frequency)
    @yAxis = yAxis

  # Private methods
  _wavelength_from_frequency: (frequency) =>
    (1 / frequency) * 1000 * 2

  _amplitude_from_gain_value: (gain_value) =>
    gain_value * 1000

  _stroke_style_from_frequency_and_gain_value: (frequency, gain_value, min_frequency, max_frequency) =>
    hue = Math.round(359 * (frequency/(max_frequency - min_frequency)))
    saturation = 100
    lightness = Math.round(75 * gain_value * 10)
    stroke_style = "hsla(#{hue}, #{saturation}%, #{lightness}%, 0.7)"

class RenderedWaves extends SineWaves

  add_wave: (wave_id, frequency, gain_value, type, yAxis, min_frequency, max_frequency) =>
    if _.any(@waves, (wave) -> wave.id == wave_id)
      throw  new Error("Wave of id #{wave_id} already exists")
    wave = new Wave(wave_id, frequency, gain_value, type, yAxis, min_frequency, max_frequency)
    @waves.push(wave)
    @setupWaveFns()
    wave

  update_wave: (wave_id, frequency, gain_value, yAxis, min_frequency, max_frequency) =>
    wave = _.find(@waves, {id: wave_id})
    if _.isObject(wave)
      wave.update(frequency, gain_value, yAxis, min_frequency, max_frequency)

  delete_wave: (wave_id) =>
    @waves = _.reject @waves, (wave) ->
      wave.id == wave_id

window.PhoneoPhone = window.PhoneoPhone || {}
PhoneoPhone.Wave = Wave
PhoneoPhone.RenderedWaves = RenderedWaves
