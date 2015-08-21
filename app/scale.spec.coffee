
frequencies = [
  0, 1, 2, 3, 4, 5, 6,
  7, 8, 9, 10, 11, 12, 13
]

describe 'ContinuousScale', ->
  describe '#get_active_frequency', ->
    it 'should return the expected frequency', ->
      scale = new PhoneoPhone.ContinuousScale(frequencies)
      expect(scale.get_active_frequency(0)).toEqual(0)
      expect(scale.get_active_frequency(0.25)).toEqual(3.25)
      expect(scale.get_active_frequency(0.5)).toEqual(6.5)
      expect(scale.get_active_frequency(0.75)).toEqual(9.75)
      expect(scale.get_active_frequency(1)).toEqual(13)

describe 'DiscreteScale', ->
  describe '#get_active_frequency', ->
    describe 'without skipping frequencies', ->
      it 'should return the frequency in frequencies that is less than or equal to the passed frequency and closest in value to it', ->
        scale = new PhoneoPhone.DiscreteScale(frequencies)
        expect(scale.get_active_frequency(0)).toEqual(0)
        expect(scale.get_active_frequency(0.25)).toEqual(3)
        expect(scale.get_active_frequency(0.5)).toEqual(6)
        expect(scale.get_active_frequency(0.75)).toEqual(9)
        expect(scale.get_active_frequency(1)).toEqual(13)

    describe 'with skipping frequencies', ->
      it 'should get correct frequency, given skipped frequencies in octaves', ->
        scale = new PhoneoPhone.DiscreteScale(frequencies, [0,3,6])
        expect(scale.get_active_frequency(0)).toEqual(1)
        expect(scale.get_active_frequency(0.25)).toEqual(2)
        expect(scale.get_active_frequency(0.5)).toEqual(5)
        expect(scale.get_active_frequency(0.75)).toEqual(9)
        expect(scale.get_active_frequency(1)).toEqual(12)
