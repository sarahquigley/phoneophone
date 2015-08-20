describe 'Tone', ->
  tone = undefined
  audio_context = new AudioContext()

  beforeEach ->
    tone = new PhoneoPhone.Tone(audio_context, 'sine', 100, 1)

  describe '#update', ->
    beforeEach ->
      tone.update(200, 2)

    it 'should update the frequency value of the oscillator node', ->
      expect(tone.oscillator.frequency.value).toEqual(200)

    it 'should update the gain value of the gain node', ->
      expect(tone.gain.gain.value).toEqual(2)

  describe '#start', ->
    it 'should start the oscillator node', ->
      spyOn(tone.oscillator, 'start')
      tone.start()
      expect(tone.oscillator.start).toHaveBeenCalled()

  describe '#stop', ->
    it 'should stop the oscillator node', ->
      spyOn(tone.oscillator, 'stop')
      tone.stop()
      expect(tone.oscillator.stop).toHaveBeenCalled()

describe 'DualTone', ->
  dual_tone = undefined
  audio_context = new AudioContext()

  beforeEach ->
    dual_tone = new PhoneoPhone.DualTone(audio_context, 100)

  describe '#update', ->
    beforeEach ->
      spyOn(dual_tone.left, 'update')
      spyOn(dual_tone.right, 'update')
      dual_tone.update(200, 0.6)

    it 'should update both tones, passing new frequency and crossfade to their update methods', ->
      expect(dual_tone.left.update).toHaveBeenCalledWith(200, (0.4 * 0.1))
      expect(dual_tone.right.update).toHaveBeenCalledWith(200, (0.6 * 0.1))

  describe '#start', ->
    beforeEach ->
      spyOn(dual_tone.left, 'start')
      spyOn(dual_tone.right, 'start')
      dual_tone.start()

    it 'should start both tones', ->
      expect(dual_tone.left.start).toHaveBeenCalled()
      expect(dual_tone.right.start).toHaveBeenCalled()

  describe '#stop', ->
    beforeEach ->
      spyOn(dual_tone.left, 'stop')
      spyOn(dual_tone.right, 'stop')
      dual_tone.stop()

    it 'should stop both tones', ->
      expect(dual_tone.left.stop).toHaveBeenCalled()
      expect(dual_tone.right.stop).toHaveBeenCalled()
