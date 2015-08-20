describe 'AudioSpace', ->
  audio_space = undefined
  audio_context = new AudioContext()
  el = undefined

  beforeEach ->
    el = document.createElement('div')
    frequencies = [100, 200, 300, 400, 500, 600, 700]
    audio_space = new PhoneoPhone.AudioSpace(el, frequencies)

  describe '#add_dual_tone', ->
    xit 'should add a dual_tone matching the provided id to AudioSpace#dual_tones', ->
      
  describe '#update_dual_tone', ->
    xit 'should update the dual_tone matching the provided id in AudioSpace#dual_tones', ->
      
  describe '#delete_dual_tone', ->
    xit 'should delete the dual_tone matching the provided id from AudioSpace#dual_tones', ->

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
    xit 'should add a new dual_tone with provided id', ->
    xit 'should start that new dual_tone', ->

  describe '#on_change_event', ->
    xit 'should update dual_tone with provided id', ->

  describe '#on_stop_event', ->
    xit 'should stop dual_tone with provided id', ->
    xit 'should delete dual_tone with provided id', ->

  describe '#start_tone', ->
    xit 'should start dual_tone with provided id', ->

  describe '#stop_tone', ->
    xit 'should stop dual_tone with provided id', ->
