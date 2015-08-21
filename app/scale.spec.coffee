describe 'Scale', ->

  scale = undefined
  frequencies = [
    0, 1, 2, 3, 4, 5, 6,
    7, 8, 9, 10, 11, 12, 13
  ]

  beforeEach ->
    scale = new PhoneoPhone.Scale(frequencies)

  describe '#get_active_frequency', ->
    describe 'if scale is not discrete', ->
      it 'should return the expected frequency', ->
        expect(scale.get_active_frequency(0)).toEqual(0)
        expect(scale.get_active_frequency(0.25)).toEqual(3.25)
        expect(scale.get_active_frequency(0.5)).toEqual(6.5)
        expect(scale.get_active_frequency(0.75)).toEqual(9.75)
        expect(scale.get_active_frequency(1)).toEqual(13)

    describe 'if scale is discrete', ->
      beforeEach ->
        scale.discrete = true

      describe 'if Scale#skip is empty', ->
        it 'should return the frequency in Scale#frequencies that is less than or equal to the passed frequency and closest in value to it', ->
          expect(scale.get_active_frequency(0)).toEqual(0)
          expect(scale.get_active_frequency(0.25)).toEqual(3)
          expect(scale.get_active_frequency(0.5)).toEqual(6)
          expect(scale.get_active_frequency(0.75)).toEqual(9)
          expect(scale.get_active_frequency(1)).toEqual(13)

      describe 'if Scale#skip is contains values', ->
        it 'should handle the case where all frequencies in octave are skipped', ->
          scale.skip = [0, 1, 2, 3, 4, 5, 6]
          expect(scale.get_active_frequency(0)).toEqual(0)
          expect(scale.get_active_frequency(0.25)).toEqual(0)
          expect(scale.get_active_frequency(0.5)).toEqual(0)
          expect(scale.get_active_frequency(0.75)).toEqual(0)
          expect(scale.get_active_frequency(1)).toEqual(0)

        it 'should get correct frequency, given skipped frequencies in octaves', ->
          scale.skip = [0, 3, 6]
          expect(scale.get_active_frequency(0)).toEqual(1)
          expect(scale.get_active_frequency(0.25)).toEqual(2)
          expect(scale.get_active_frequency(0.5)).toEqual(5)
          expect(scale.get_active_frequency(0.75)).toEqual(9)
          expect(scale.get_active_frequency(1)).toEqual(12)
