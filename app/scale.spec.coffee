describe 'Scale', ->

  scale = undefined
  frequencies = [
    1, 2, 3, 4, 5, 6, 7,
    8, 9, 10, 11, 12, 13, 14
  ]

  beforeEach ->
    scale = new PhoneoPhone.Scale(frequencies)

  describe '#min_frequency', ->
    describe 'if no positions in octaves are skipped', ->
      it 'should return the lowest frequency in Scale#frequencies', ->
        expect(scale.min_frequency()).toEqual(1)

    describe 'if positions in octaves are skipped', ->
      it 'should return the lowest non-skipped frequency in Scale#frequencies', ->
        scale.skip = [0]
        expect(scale.min_frequency()).toEqual(2)
        scale.skip = [0, 1]
        expect(scale.min_frequency()).toEqual(3)
        scale.skip = [0, 1, 2]
        expect(scale.min_frequency()).toEqual(4)
        scale.skip = [1]
        expect(scale.min_frequency()).toEqual(1)

  describe '#max_frequency', ->
    describe 'if no positions in octaves are skipped', ->
      it 'should return the highest frequency in Scale#frequencies', ->
        expect(scale.max_frequency()).toEqual(14)

    describe 'if positions in octaves are skipped', ->
      it 'should return the highest non-skipped frequency in Scale#frequencies', ->
        scale.skip = [6]
        expect(scale.max_frequency()).toEqual(13)
        scale.skip = [5, 6]
        expect(scale.max_frequency()).toEqual(12)
        scale.skip = [4, 5, 6]
        expect(scale.max_frequency()).toEqual(11)
        scale.skip = [5]
        expect(scale.max_frequency()).toEqual(14)


  describe '#get_nearest_frequency', ->
    describe 'if passed frequency is less than Scale#min_frequency', ->
      it 'should return Scale#min_frequency', ->
        expect(scale.get_nearest_frequency(0)).toEqual(1)
        expect(scale.get_nearest_frequency(0.99)).toEqual(1)

    describe 'if passed frequency is greater than Scale#max_frequency', ->
      it 'should return Scale#max_frequency', ->
        expect(scale.get_nearest_frequency(14.01)).toEqual(14)
        expect(scale.get_nearest_frequency(15)).toEqual(14)

    describe 'if passed frequency is between Scale#min_frequency and Scale#max_frequency', ->
      describe 'if scale is not discrete', ->
        it 'should return the passed frequency', ->
          expect(scale.get_nearest_frequency(1.5)).toEqual(1.5)
          expect(scale.get_nearest_frequency(4.5)).toEqual(4.5)

      describe 'if scale is discrete', ->
        beforeEach ->
          scale.discrete = true

        describe 'if Scale#skip is empty', ->
          it 'should return the frequency in Scale#frequencies that is less than or equal to the passed frequency and closest in value to it', ->
            expect(scale.get_nearest_frequency(1)).toEqual(1)
            expect(scale.get_nearest_frequency(1.5)).toEqual(1)
            expect(scale.get_nearest_frequency(4)).toEqual(4)
            expect(scale.get_nearest_frequency(4.5)).toEqual(4)
            expect(scale.get_nearest_frequency(13.5)).toEqual(13)
            expect(scale.get_nearest_frequency(13)).toEqual(13)

        describe 'if Scale#skip is contains values', ->
          it 'should handle the case where skipping frequencies does not leave enough frequencies', ->
            scale.skip = [0, 1, 2, 3, 4, 5, 6]
            expect(scale.get_nearest_frequency(1)).toEqual(1)
            expect(scale.get_nearest_frequency(2)).toEqual(1)
            expect(scale.get_nearest_frequency(4)).toEqual(1)

          it 'should handle situation where Scale#min_frequency is skipped', ->
            scale.skip = [0]
            expect(scale.get_nearest_frequency(1)).toEqual(2)
            scale.skip = [0, 1]
            expect(scale.get_nearest_frequency(1)).toEqual(3)
            expect(scale.get_nearest_frequency(2)).toEqual(3)

          it 'should handle situation where Scale#max_frequency is skipped', ->
            scale.skip = [6]
            expect(scale.get_nearest_frequency(14)).toEqual(13)
            scale.skip = [5, 6]
            expect(scale.get_nearest_frequency(13)).toEqual(12)
            expect(scale.get_nearest_frequency(14)).toEqual(12)

          it 'should return the frequency in Scale#frequencies that is less than or equal to the passed frequency and closest in value to it after removing the skipped values', ->
            scale.skip = [0, 6]
            expect(scale.get_nearest_frequency(1)).toEqual(2)
            expect(scale.get_nearest_frequency(1.5)).toEqual(2)
            expect(scale.get_nearest_frequency(4)).toEqual(4)
            expect(scale.get_nearest_frequency(4.5)).toEqual(4)
            expect(scale.get_nearest_frequency(7)).toEqual(6)
            expect(scale.get_nearest_frequency(7.5)).toEqual(6)
            expect(scale.get_nearest_frequency(14)).toEqual(13)

