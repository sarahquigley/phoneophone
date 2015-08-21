describe 'AudioSpace', ->
  audio_space = undefined
  audio_context = new AudioContext()
  el = undefined

  beforeEach ->
    el = new MockElement()
    el.clientWidth = 400
    el.clientHeight = 400
    frequencies = [0, 100, 150, 200, 250, 300, 400]
    audio_space = new PhoneoPhone.AudioSpace(el, frequencies)
    audio_space.dual_tones.dual_tone1 = new PhoneoPhone.DualTone(audio_context, 100)

  describe '#add_dual_tone', ->
    it 'should add a dual_tone to AudioSpace#dual_tones', ->
      audio_space.add_dual_tone('dual_tone2', 100, 0.5)
      expect(audio_space.dual_tones.dual_tone2).toEqual(jasmine.any(PhoneoPhone.DualTone))
      expect(audio_space.dual_tones.dual_tone2.frequency).toEqual(100)
      expect(audio_space.dual_tones.dual_tone2.crossfade).toEqual(0.5)

      
  describe '#update_dual_tone', ->
    it 'should update the correct dual_tone in AudioSpace#dual_tones', ->
      audio_space.update_dual_tone('dual_tone1', 200, 0.7)
      expect(audio_space.dual_tones.dual_tone1.frequency).toEqual(200)
      expect(audio_space.dual_tones.dual_tone1.crossfade).toEqual(0.7)

      
  describe '#delete_dual_tone', ->
    it 'should delete the correct dual_tone from AudioSpace#dual_tones', ->
      audio_space.delete_dual_tone('dual_tone1')
      expect(audio_space.dual_tones.dual_tone1).toBeUndefined()

  describe '#add_controls', ->
    beforeEach ->
      spyOn(audio_space, 'add_mouse_control')
      spyOn(audio_space, 'add_touch_control')
      spyOn(audio_space, 'add_deviceorientation_control')
      audio_space.add_controls()

    it 'should add mouse control', ->
      expect(audio_space.add_mouse_control).toHaveBeenCalled()

    it 'should add touch control', ->
      expect(audio_space.add_touch_control).toHaveBeenCalled()

    it 'should add deviceorientation control', ->
      expect(audio_space.add_deviceorientation_control).toHaveBeenCalled()
      
  describe '#add_mouse_control', ->
    beforeEach ->
      spyOn(el, 'addEventListener')
      audio_space.add_mouse_control()

    it 'should add a mousedown event', ->
      expect(el.addEventListener).toHaveBeenCalledWith('mousedown', jasmine.any(Function))

    it 'should add a mousemove event', ->
      expect(el.addEventListener).toHaveBeenCalledWith('mousemove', jasmine.any(Function))

    it 'should add a mouseup event', ->
      expect(el.addEventListener).toHaveBeenCalledWith('mouseup', jasmine.any(Function))

  describe '#add_touch_control', ->
    beforeEach ->
      spyOn(el, 'addEventListener')
      audio_space.add_touch_control()

    it 'should add a touchstart event', ->
      expect(el.addEventListener).toHaveBeenCalledWith('touchstart', jasmine.any(Function))

    it 'should add a touchmove event', ->
      expect(el.addEventListener).toHaveBeenCalledWith('touchmove', jasmine.any(Function))

    it 'should add a touchend event', ->
      expect(el.addEventListener).toHaveBeenCalledWith('touchend', jasmine.any(Function))

  describe '#add_deviceorientation_control', ->
    beforeEach ->
      spyOn(window, 'addEventListener')
      audio_space.add_deviceorientation_control()

    it 'should add a deviceorientation event', ->
      expect(window.addEventListener).toHaveBeenCalledWith('deviceorientation', jasmine.any(Function))

  describe '#on_start_event', ->
    beforeEach ->
      spyOn(audio_space, 'add_dual_tone')
      spyOn(audio_space, 'start_tone')
      event = {clientX: 200, clientY: 200}
      audio_space.on_start_event(event, 'dual_tone2')

    it 'should add a new dual_tone with provided id', ->
      expect(audio_space.add_dual_tone).toHaveBeenCalledWith('dual_tone2', 200, 0.5)

    it 'should start that new dual_tone', ->
      expect(audio_space.start_tone).toHaveBeenCalledWith('dual_tone2')

  describe '#on_change_event', ->
    it 'should update dual_tone with provided id', ->
      spyOn(audio_space, 'update_dual_tone')
      event = {clientX: 200, clientY: 200}
      audio_space.on_change_event(event, 'dual_tone1')
      expect(audio_space.update_dual_tone).toHaveBeenCalledWith('dual_tone1', 200, 0.5)

  describe '#on_stop_event', ->
    beforeEach ->
      spyOn(audio_space, 'delete_dual_tone')
      spyOn(audio_space, 'stop_tone')
      event = {clientX: 200, clientY: 200}
      audio_space.on_stop_event(event, 'dual_tone1')

    it 'should stop dual_tone with provided id', ->
      expect(audio_space.delete_dual_tone).toHaveBeenCalled()
    
    it 'should delete dual_tone with provided id', ->
      expect(audio_space.stop_tone).toHaveBeenCalledWith('dual_tone1')

  describe '#start_tone', ->
    it 'should start dual_tone with provided id', ->
      spyOn(audio_space.dual_tones.dual_tone1, 'start')
      audio_space.start_tone('dual_tone1')
      expect(audio_space.dual_tones.dual_tone1.start).toHaveBeenCalled()
      
  describe '#stop_tone', ->
    it 'should stop dual_tone with provided id', ->
      spyOn(audio_space.dual_tones.dual_tone1, 'stop')
      audio_space.stop_tone('dual_tone1')
      expect(audio_space.dual_tones.dual_tone1.stop).toHaveBeenCalled()

  describe '#frequency_at_y', ->
    it 'should call AudioSpace#scale\'s get_nearest_frequency method with expected value', ->
      spyOn(audio_space.scale, 'get_active_frequency').and.returnValue(50)
      for n in [0..4]
        expect(audio_space.frequency_at_y(n * 100)).toEqual(50)
        expect(audio_space.scale.get_active_frequency).toHaveBeenCalledWith(n / 4)
        audio_space.scale.get_active_frequency.calls.reset()
      
  describe '#crossfade_at_x', ->
    it 'should convert a position on the x-axis within AudioSpace#el to a crossfade value between 0 and 1', ->
      for n in [0..4]
        expect(audio_space.crossfade_at_x(n * 100)).toEqual(n / 4)
